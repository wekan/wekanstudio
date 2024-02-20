# Roadmap

## In Progress

### Pages

- All Boards: https://github.com/wekan/wekanbean/blob/main/CHANGELOG.md

## Upcoming Features

### Pages

- Login
- Registration
- Profile
  - User name
- Dashboard
  - Balances
  - Charts
- Transfer
- Board Settings
  - IFTTT Rules
  - Outgoing Webhooks
- Admin Panel
- Also other pages from:
  - https://github.com/wekan/wekan
  - https://github.com/wekan/php 

### Page content

- HTML/CSS, compatible with all web browsers
- No cookies.
- No storing to browser localstorage.
- Optional Javascript. Not required.
- Unicode icons. Not Font Awesome.

### Scheduled actions

- Using cron like features of https://redbean.dev
- Used for:
  - Rate limited import from other apps via API. For example:
    - Import from Trello with attachments https://github.com/wekan/wekan/tree/main/trello
    - Import from Jira
    - Import from GitHub
    - Sync Roadmap at https://github.com/wekan/wekan/wiki/Sync
  - Timed IFTTT Rules like Trello Butler. For example:
    - Every monday copy card from other board to this board this list.
    - https://github.com/wekan/wekan/wiki/IFTTT
  - Timed sync of users from LDAP:
    - This works correctly: https://github.com/wekan/wekan/blob/main/ldap-sync/ldap-sync.py
    - Currently, Meteor WeKan synced-cron does not sync correcly
  - Summaries of notifications
    - Notification Settings https://github.com/wekan/wekan/issues/2026

### Sessions

- Based on database structure of Meteor WeKan https://wekan.github.io , with additional fields
- Stored to SQLite database table
- Table fields, for example:
  - Headers from client browser
  - User agent
  - IP address
  - Screen resolution
  - Time
  - Any other available info
  - Salt
  - Hashed one-time token of all above, included to webpage hidden submit field
- User is not logged in anymore, if:
  - If request is older that for example one hour (configurable setting) 
  - If user IP address changes
  - If someone is using browser that is in any way different
  - If webpage does not contain hashed one-time token
  - IP address, only login from one country allowed. Other countries prevented by default, can be added later.
    Country detection based on CloudFlare headers, MaxMind, or other IP databases.

### Logging

- For GDPR related features, inspiration from https://databunker.org https://github.com/securitybunker/databunker
- All changes per user
  - For auditing purposes, if someone misuses data. For example, changes agreed estimate content to be different.
  - For historical progress of project as charts.
  - Summary of data, and some newest data at Dashboard.

### Native apps

- For using hardware-specific features
- Minimal RAM usage
- Offline use, when not connected to Internet. Syncing, when connected to Internet.

