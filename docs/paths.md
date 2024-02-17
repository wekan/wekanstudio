# Paths

## Makefile

Start WeKan:
```
make start
```

## Start script

```
srv/.init.lua

pc = require "wekan" , starts srv/.lua/wekan.lua
pc:initDb()          , runs srv/.lua/schema.sql and srv/.lua/data.sql from wekan.lua 
pc.run(8000)         , starts at port 8000
```
