#!/bin/sh
set -eu

OUT=/work/outputs
ROOT=/work/build/root
POST=/work/build/post-install
PACKAGE="$OUT/luci-app-ufi-usage-1.0.0-r28.apk"

rm -f "$PACKAGE"
apk mkpkg \
	--compat 3.0 \
	--compression none \
	--info "name:luci-app-ufi-usage" \
	--info "version:1.0.0-r28" \
	--info "description:余量面板 - LuCI carrier usage panel for China Mobile, China Unicom, Cloud Card and Xiaojing Card" \
	--info "arch:noarch" \
	--info "license:MIT" \
	--info "origin:luci-app-ufi-usage" \
	--info "url:https://github.com/Asunano/UFI-AXIS" \
	--info "maintainer:Codex local build" \
	--info "depends:python3 curl openssl-util luci-base luci-compat" \
	--script "post-install:$POST" \
	--files "$ROOT" \
	--output "$PACKAGE"

apk adbdump "$PACKAGE" | head -80
(cd "$OUT" && sha256sum "$(basename "$PACKAGE")" > "$(basename "$PACKAGE").sha256")
