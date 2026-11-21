# Security

## Sensitive local data

The following files must not be committed or shared:

- `/etc/ufi-usage/state.json`
- `/etc/ufi-usage/master.key`
- exported `ecs_token` text files
- LuCI cookies, carrier cookies, and SMS verification codes

The plugin encrypts account identities and carrier sessions with a device-local
key. The exported `ecs_token` is a login credential and should be treated like a
password.

## Reporting

If the repository is hosted on GitHub, report security issues through the
repository's private Security Advisory feature when available. Avoid posting
working tokens, phone numbers, cookies, or `state.json` contents in a public
issue.
