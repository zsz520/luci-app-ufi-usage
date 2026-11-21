# luci-app-ufi-usage

面向 OpenWrt 25.12+ 的 LuCI 套餐余量面板，支持中国移动、中国联通、云上卡和小鲸卡。

本项目参考并改编自 [Asunano/UFI-AXIS](https://github.com/Asunano/UFI-AXIS)
和 [AliYa-chen/unicomvue](https://github.com/AliYa-chen/unicomvue)，遵循 MIT
许可证。

## 功能

- 中国移动：短信验证码登录、自动登录、余额、套餐、通用/定向流量。
- 中国联通：短信验证码、精简 60 秒倒计时、`ecs_token` 登录、App 扫码登录，
  以及运营商允许时的服务密码登录。
- 中国联通微信小程序：支持手机号 + 短信验证码免抓包登录，内置联通官方滑块，
  并使用 `token_online` 自动续期；也可填写一次明文 `openid` 恢复已有小程序会话。
- 联通套餐档案：套餐名称、入网时间、网龄、合约到期天数、返费信息和限速阈值。
- 联通家庭共享：按成员显示流量、语音、短信用量和共享占比。
- 联通本月实时费用：从余额接口的 `realfeecustnew` 读取。
- `ecs_token` 一键导出：自动复制到剪贴板，支持遮罩显示、再次复制和 TXT 下载，
  便于迁移到另一台 OpenWrt 设备。
- 云上卡：充值号登录、流量、有效期、真实用量和订单记录。
- 小鲸卡：充值号加绑定手机号后四位登录。
- 账号、Cookie、设备身份和运营商会话使用设备本地密钥加密。
- 移动自动登录仅在插入 SIM 与账号手机号完全一致时读取新短信。
- 套餐语义去重、无限量/共享标签、全宽进度条和桌面/手机自适应布局。

## 兼容性

当前构建在 OpenWrt 25.12.5 和 MU300/F50 环境测试。运营商接口可能因省份、
号码类型或固件版本发生变化；无法保证所有设备都能完成自动登录或读取全部字段。

运行依赖：

- `luci-base`
- `luci-compat`
- `python3`
- `openssl-util`
- `curl`
- MU300 系列固件提供的 `mu300dash` ubus 服务，用于 SIM 和短信访问

## 安装

从 Releases 下载最新的 `luci-app-ufi-usage-*.apk`，上传到路由器后执行：

```sh
apk add --allow-untrusted /tmp/luci-app-ufi-usage-*.apk
```

安装后进入：

```text
LuCI -> 服务 -> 余量面板
```

也可以通过 LuCI 的“系统 -> 软件包”上传 APK 安装。

## 使用

1. 点击“添加账号”，选择运营商类型。
2. 中国移动使用短信验证码登录。
3. 中国联通可选择 App 短信验证码、小程序验证码、`ecs_token`、App 扫码，或运营商允许时的服务密码。
4. 小程序验证码会先完成联通官方滑块，再向手机发送短信；登录会话由后台自动续期。
5. 需要迁移普通联通会话时，点击账号操作区的下载箭头导出 `ecs_token`。
6. 在另一台设备选择“中国联通 -> Token 登录”，粘贴导出的 Token。

## 安全说明

- 不持久化移动或联通账号密码。
- 账号手机号、登录 Cookie、二维码票据、续期 Token 和联通设备身份均加密保存。
- API 默认遮罩手机号和卡号。
- `ecs_token` 一键导出默认遮住完整内容，不会写入系统日志。
- `ecs_token` 等同登录凭证，不要发送给他人，迁移完成后建议删除导出的 TXT 文件。
- 请勿公开 `/etc/ufi-usage/state.json`、`/etc/ufi-usage/master.key` 或导出文件。

## 构建

构建需要 Docker 和联网环境：

```sh
./build_apk.sh
```

默认输出：

```text
outputs/luci-app-ufi-usage-1.0.0-r28.apk
```

后端自测：

```sh
docker run --rm \
  -v "$PWD:/work" \
  -w /work \
  alpine:edge \
  /bin/sh -lc 'apk add --no-cache python3 openssl >/dev/null && python3 root/usr/bin/ufi-usage selftest'
```

## 目录结构

```text
root/                       LuCI、控制器、初始化脚本和后端
scripts/                    apk-tools 容器构建脚本
.github/workflows/build.yml GitHub Actions 自动构建
build_apk.sh                本地构建入口
THIRD_PARTY_NOTICES.md      上游项目与许可证声明
CHANGELOG.md                版本记录
SECURITY.md                 敏感数据与漏洞报告说明
```

## 许可证

本仓库采用 MIT License。上游项目的版权和许可证文本见
[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。
