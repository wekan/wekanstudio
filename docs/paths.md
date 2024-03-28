# Paths

## Makefile

Start Studio:
```
make start
```

## Start script

```
srv/.init.lua

pc = require "routelib" , starts srv/.lua/routelib.lua
pc:initDb()          , runs srv/.lua/schema.sql and srv/.lua/data.sql from routelib.lua 
pc.run(8000)         , starts at port 8000
```
