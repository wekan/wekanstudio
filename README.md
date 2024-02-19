# WeKanBean

WeKan Multiverse prototype, based on redbean/fullmoon/sqlite3/petclinic tech. For more more info, see docs/starting.md

This is general purpose web framework for creating any app. One `wekan.com`executeable for Windows/Mac/Linux/BSD x86_64/arm64.
With blink, also for s390x, RISC-V etc, running like `blink wekan.com`.

All data is stored in SQLite3 database `wekan.db`, that will be created to same directory as `wekan.com` executeable,
if it does not exist yet.

Database structure is same as in WeKan Open Source kanban https://wekan.github.io https://github.com/wekan/wekan (also features will be same and more),
when exported to SQLite with https://github.com/wekan/minio-metadata .

## Screenshot

Showing table view of `All Boards` page of WeKan Open Source kanban https://wekan.github.io

![screenshot](screenshot.png)

