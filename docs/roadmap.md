# Roadmap

## In Progress

### Pages

- All Boards: https://github.com/wekan/wekanstudio/blob/main/CHANGELOG.md

## Upcoming Features

### Pages

- Login+Registration
  - https://kevinfiol.com/blog/a-tour-of-beancms/
- Profile
  - User name
- Dashboard
  - Balances
  - Charts
    - https://echarts.apache.org/en/
    - https://news.ycombinator.com/item?id=43664455
  - Maps like
    - https://leafletjs.com
    - https://organicmaps.app
- Transfer
- Board Settings
  - IFTTT Rules
  - Outgoing Webhooks
- Admin Panel
- Also other pages from:
  - https://github.com/wekan/wekan
  - https://github.com/wekan/php
  - https://github.com/wekan/wami

### Page content

- HTML/CSS, compatible with all web browsers
- No cookies.
- No storing to browser localstorage.
- Optional Javascript. Not required. If needed, try:
  - Existing WeKan Javascript code, like JQuery draggable/sortable
  - RaphaelJS, that also works SVG and VML also with legacy browsers like IE https://github.com/wekan/wekan/issues/3392#issuecomment-1296475023 , https://github.com/raphaeljsorg
  - https://unpoly.com , better for progressive enhancement with less code changes, recommended by HTMX creator https://www.youtube.com/watch?v=9H5VK9vJ-aw 
  - https://leanrada.com/htmz/ , https://news.ycombinator.com/item?id=39429370
- Unicode icons. Not Font Awesome.
- Optional realtime updates:
  - Datastar using SSE like at fullmoon
    - https://chrismalek.me/posts/data-star-first-impressions/
    - https://news.ycombinator.com/item?id=43655914

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

###¤ a) Cookie

- Fullmoon's session signs a cookie with the HMAC of a secret only the server knows
  - https://github.com/pkulchenko/fullmoon/blob/58fc985f8e4d0a030a5d9b83127bb61f3d1a7f85/fullmoon.lua#L1289-L1329
- For encryption, a pure lua library like https://github.com/philanc/plc/ is required
  - https://github.com/pkulchenko/fullmoon/blob/58fc985f8e4d0a030a5d9b83127bb61f3d1a7f85/fullmoon.lua
- Reading around a bit, apparently this is a common scheme with a couple tweaks:
  - If you don't have any secret data in there (e.g. just ID and timestamp), you only need
    a signature and don't have to encrypt the authorization HTTP header instead of (or in addition to?)
    the session cookies.
  - So if I'm reading the Fullmoon code right, "session" is an encrypted cookie, very similar to JWT
    (but a Lua version). I did dig up this article which suggests my strategy is inferior to just
    storing the session data on the server side and cookie-ing (encrypted or via HTTPS or both)
    the random ID of the session data.
  - http://cryto.net/~joepie91/blog/2016/06/13/stop-using-jwt-for-sessions/
  - Which honestly doesn't sound too hard. Store it in an in-memory table if the server is always
    running (deploys will kick everyone but eh, so will leaving your browser open till the session expires),
    or in a Redis cache if I really want it to be robust (I'm sure Redbean can talk to Redis somehow),
    or even just in an encrypted table in Sqlite (call it poor man's Redis, but it would work).
  - Oh, and I could use the session mechanism in Fullmoon to store the client-side key/ID securely.

#### b) Initial design of login without cookies and without localstorage

- Similar to browser fingerprinting
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

## Other databases

- Someone made a HTTP client to the arangodb database and it works pretty well
- Redis client for redbean usage https://github.com/solisoft/luaonbeans/blob/main/.lua/redis.lua
- Maybe make a HTTP client for DataBunker SQLite/MySQL/PostgreSQL ?
  - https://databunker.org
  - https://github.com/securitybunker/databunker#readme
- Fullmoon also supports this with simple CGI interface: https://github.com/pkulchenko/fullmoon/blob/master/examples/showcase.lua#L115

## About DDoS protection of Redbean

- https://ipv4.games runs on Redbean and SQLlite. It's been DDoS'd by botnets with 49131669 IPs.
  It's also a write heavy application. Runs on a VM with 2 cores.
