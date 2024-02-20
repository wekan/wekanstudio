# ChangeLog

## 2024-02-20 WeKan Studio Release

Database:
- Added WeKan SQLite database structure, exporting it with SQLiteBrowser from wekan.db database
- Files:
  - https://github.com/wekan/wekanstudio/blob/main/srv/.lua/schema.sql 
  - https://github.com/wekan/wekanstudio/blob/main/srv/.lua/wekan.lua
    - At bottom, creating database `wekan.db` if it does not exists, with `dbconn:runSqlInFile("/zip/.lua/schema.sql")`
- Not yet added anything for default data, and not importing it, it still had old pet data
  - https://github.com/wekan/wekanstudio/blob/main/srv/.lua/data.sql

All Boards page:
- Files:
  - https://github.com/wekan/wekanstudio/blob/main/srv/templates/boards/allboardsList.fmt
  - https://github.com/wekan/wekanstudio/blob/main/srv/templates/layout.fmt
- Copied Meteor Wekan visual look to WeKan Studio
 - Showing list of boards from database as board icons
- Removed Font Awesome. Instead, using Unicode as icons, for example:
  - 🔔 Notification bell
  - ↔↕⏹ Show desktop drag handles
  - ⭐ Star
  - ⎘ Duplicate
  - 🗑 Move to Archive

Translations:
- Added translations files from WeKan:
  - https://github.com/wekan/wekanstudio/commit/7d65feccfc5d5925a1c68b9ef7e84648ca20681f
- Later will add using translations at All Boards page, similar like in PHP prototype:
  - https://github.com/wekan/php/blob/main/page/translations.php