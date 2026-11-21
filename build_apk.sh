#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BUILD_DIR="$ROOT_DIR/build"
ROOT_FS="$BUILD_DIR/root"

rm -rf "$BUILD_DIR" "$ROOT_DIR/outputs"
mkdir -p \
	"$ROOT_FS/usr/share/licenses/luci-app-ufi-usage" \
	"$ROOT_FS/lib/apk/packages" \
	"$ROOT_DIR/outputs"

cp -a "$ROOT_DIR/root/." "$ROOT_FS/"
cp "$ROOT_DIR/LICENSE" "$ROOT_FS/usr/share/licenses/luci-app-ufi-usage/LICENSE"
cp "$ROOT_DIR/THIRD_PARTY_NOTICES.md" "$ROOT_FS/usr/share/licenses/luci-app-ufi-usage/THIRD_PARTY_NOTICES.md"
cp "$ROOT_DIR/README.md" "$ROOT_FS/usr/share/licenses/luci-app-ufi-usage/README.md"

chmod 0755 "$ROOT_FS/usr/bin/ufi-usage" "$ROOT_FS/etc/init.d/ufi-usage"
chmod 0644 \
	"$ROOT_FS/usr/lib/lua/luci/controller/ufi_usage.lua" \
	"$ROOT_FS/usr/lib/lua/luci/view/ufi_usage/index.htm"

find "$ROOT_FS" -type d -name '__pycache__' -prune -exec rm -rf {} +
find "$ROOT_FS" -type f -name '*.pyc' -delete

cat > "$BUILD_DIR/post-install" <<'EOF'
#!/bin/sh
[ -n "${IPKG_INSTROOT:-}" ] && exit 0
mkdir -p /etc/ufi-usage
chmod 700 /etc/ufi-usage
if [ -x /etc/init.d/ufi-bill ]; then
	/etc/init.d/ufi-bill stop >/dev/null 2>&1 || true
	/etc/init.d/ufi-bill disable >/dev/null 2>&1 || true
fi
rm -f /tmp/luci-indexcache /tmp/luci-indexcache.*
/etc/init.d/rpcd restart >/dev/null 2>&1 || true
/etc/init.d/ufi-usage enable >/dev/null 2>&1 || true
/etc/init.d/ufi-usage restart >/dev/null 2>&1 || true
exit 0
EOF
chmod 0755 "$BUILD_DIR/post-install"

(
	cd "$ROOT_FS"
	find . -type f -o -type l |
		sed 's#^\./#/#' |
		sort > lib/apk/packages/luci-app-ufi-usage.list
)

if [ "${UFI_USAGE_IN_DOCKER:-0}" = "1" ]; then
	/bin/sh "$ROOT_DIR/scripts/build-in-container.sh"
else
	docker run --rm \
		-e UFI_USAGE_IN_DOCKER=1 \
		-v "$ROOT_DIR:/work" \
		-w /work \
		alpine:edge \
		/bin/sh /work/build_apk.sh
fi

echo "$ROOT_DIR/outputs/luci-app-ufi-usage-1.0.0-r25.apk"
