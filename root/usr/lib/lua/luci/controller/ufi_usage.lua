local http = require "luci.http"
local sys = require "luci.sys"

module("luci.controller.ufi_usage", package.seeall)

local MAX_REQUEST = 65536

function index()
	if not nixio.fs.access("/usr/bin/ufi-usage") then
		return
	end

	entry({"admin", "services", "ufi_usage"}, template("ufi_usage/index"), nil).dependent = false
	entry({"admin", "services", "ufi_usage", "api"}, call("action_api")).leaf = true
end

local function shell_quote(value)
	return "'" .. tostring(value):gsub("'", "'\\''") .. "'"
end

function action_api()
	if http.getenv("REQUEST_METHOD") ~= "POST" then
		http.status(405, "Method Not Allowed")
		http.prepare_content("application/json")
		http.write_json({ ok = false, error = "仅接受 POST 请求" })
		return
	end

	local body = http.content() or ""
	if #body == 0 or #body > MAX_REQUEST then
		http.status(413, "Payload Too Large")
		http.prepare_content("application/json")
		http.write_json({ ok = false, error = "请求为空或超过大小限制" })
		return
	end

	local request_path = string.format(
		"/tmp/ufi-usage-request-%s-%s.json",
		tostring(sys.process.info("pid")),
		tostring(os.time())
	)
	local handle = io.open(request_path, "w")
	if not handle then
		http.status(500, "Internal Server Error")
		http.prepare_content("application/json")
		http.write_json({ ok = false, error = "无法创建临时请求文件" })
		return
	end
	handle:write(body)
	handle:close()
	nixio.fs.chmod(request_path, "600")

	local output = sys.exec(
		"/usr/bin/python3 /usr/bin/ufi-usage api "
		.. shell_quote(request_path)
		.. " 2>/dev/null"
	)
	nixio.fs.unlink(request_path)

	local jsonc = require "luci.jsonc"
	local parsed = jsonc.parse(output or "")
	if type(parsed) ~= "table" then
		http.prepare_content("application/json")
		http.write_json({ ok = false, error = "余量后端没有返回有效数据" })
		return
	end
	http.prepare_content("application/json")
	http.write(output)
end
