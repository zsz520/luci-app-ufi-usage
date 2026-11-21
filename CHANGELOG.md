# Changelog

## 1.0.0-r27

- Added China Unicom WeChat Mini Program `openid` login.
- Added RSA token exchange, mini-program headers, micro-hall session bootstrap, and account broadcast parsing.
- Added mini-program account refresh without storing phone passwords, SMS codes, or login cookies.

## 1.0.0-r26

- Added China Unicom `myPackage` package and contract profile retrieval.
- Added current-month real fee, tenure, contract countdown, rebate, and speed-limit data.
- Added family-sharing member usage for flow, voice, and SMS.
- Added responsive family-member cards to the LuCI usage panel.

## 1.0.0-r25

- Added one-click `ecs_token` export for China Unicom accounts.
- Export opens a masked token dialog with copy, reveal, and TXT download actions.
- Token export reuses the encrypted LuCI session and does not write the token to logs.

## 1.0.0-r24

- Made account dialogs follow the active LuCI light or dark theme.

## 1.0.0-r23

- Added a dedicated CSS loading ring for manual refresh.
- Kept the refresh indicator visible for at least 1.2 seconds.

## Earlier 1.0.0 revisions

- Renamed the plugin from the bill-oriented package to `luci-app-ufi-usage`.
- Migrated legacy account state and data paths while keeping carrier API field names.
- Added full-width usage cards, icon-only account actions, and improved responsive layout.
- Added China Unicom SMS, token, QR, and password login flows.
- Added China Mobile, Cloud Card, and Xiaojing Card usage providers.
