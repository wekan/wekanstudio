## Instructions to run

1. Clone repo
2. Examine the makefile - it has multiple targets to make your life easier
3. I assume your system has zip/unzip installed and available at the command line
4. The makefile will download a redbean executable from redbean.dev and then zip the contents of /srv into it

### Start in interactive mode

```
make start
```

Makefile:
- Downloads nightly build of Redbean. If you like to compile Redbean yourself, see build info at https://redbean.dev and source code at https://github.com/jart/cosmopolitan
- Adds all files from `srv` directory to .zip file, that is added to end of `redbean.com` executeable, producing one final `wekan.com` executeable
- That same `wekan.com` executeable works at Windows/Mac/Linux/BSD x86_64/arm64, using cross-platform tech from https://github.com/jart/cosmopolitan . There is no need for separate executeable for each CPU/OS.
- When started, if SQLite3 database `wekan.db` does not exist at same directory as `wekan.com`, it will be created.
- For s390x, RISC-V etc, you can compile and run with blink https://github.com/jart/blink , like `blink wekan.com`.

Port defaults to 8000 and is sepecified at the bottom of file https://github.com/wekan/wekanstudio/blob/main/srv/.lua/wekan.lua

Open http://localhost:8000

### Distributing

- It is only needed to distribute `wekan.com` executeable that was created with above command `make start`
- When started, if SQLite3 database `wekan.db` does not exist at same directory as `wekan.com`, it will be created.
- If you would like to have some obfuscation for your code, you can use `luac` to compile your `.lua` files to bytecode. See examples at demo of https://redbean.dev

### Start as a background process
```
make start-daemon
```

In this mode a redbean.pid file will be created and all logs will go to redbean.log

To stop the daemon use
```
make stop-daemon
```

* You may need to manually remove redbean.pid if the process crashes or you otherwise stop the redbean process without called stop-daemon

The make file is a lightly modified version copied from 
https://github.com/ProducerMatt/redbean-template

### Hot reload

1. On linux you should be able to run ```sh reload.sh``` to hot reload as you develop
2. You need inotify-tools installed
3. As you develop tail -f redbean.log to look for issues

reload.sh credit to -> https://www.baeldung.com/linux/monitor-changes-directory-tree
