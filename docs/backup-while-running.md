## Backup while running

> What's the best way to make backups of the sqlite db while a redbean app is running/deployed?

```
local fnew = DBNAME..os.date('-%Y%m%d')
local ftmp = fnew..".tmp"
assert(dbm:execute("VACUUM INTO ?", ftmp))
assert(unix.rename(ftmp, BACKUPPATH..fnew))
```
