# WeKan Studio

At port 7700, srv/.init.lua

## Screenshot

In WeKan Studio, showing current visual look of `All Boards` page of WeKan Open Source kanban https://wekan.github.io

More info about progress at https://github.com/wekan/wekanstudio/blob/main/CHANGELOG.md

![screenshot](screenshot.png)

## TL;DR

- BLWRSL (Blow Resilient) (BSD/Linux/Mac/Windows / Redbean / SQLite / Lua). Similar like LAMP (Linux/Apache/MySQL/PHP).
- One executeable: Redbean/Lua/SQLite + .zip file at end of same executeable. Like Go, but same executeable works at Windows/Mac/Linux/BSD, no need for separate exe per OS/CPU.

## Starting

```
git clone https://github.com/wekan/wekanstudio

cd wekanstudio

make start
```

## Stopping

2 times keyboard keys `Ctrl` and `c`:

```
Ctrl-c Ctrl-c
```

## 1) Executeable file: wekan.com

- 100%: wekan.com one server executeable
  - 50%: C89 executeable
    - Cosmopolitan Cross-Platform https://github.com/jart/cosmopolitan https://deepwiki.com/jart/cosmopolitan/1-overview
      - BSD/Linux/Mac/Windows x86_64/s390x
      - blink x86_64 emulator: `blink wekan.com`
        - s390x/RISC-V: `git clone https://github.com/cosmopolitan/blink && cd blink && ./configure && make -j$(nproc) && ./blink wekan.com`
        - Android Termux from Play Store or F-Droid: `pkg install blink && blink wekan.com`
    - Redbean webserver https://redbean.dev https://github.com/jart/cosmopolitan/blob/master/tool/net/redbean.c
    - Lua interpreter https://en.wikipedia.org/wiki/Lua_(programming_language)
    - SQLite https://sqlite.org https://github.com/jart/cosmopolitan/blob/master/tool/net/lsqlite3.c
  - 50%: `srv` directory zip archive added to end of above C89 executeable, to make one executeable
    - `srv/.init.lua` load wekan.lua, starting port
    - `srv/.lua/`
      - `wekan.lua`: Functions for Templates, Router, Database name `wekan.db`, 
      - `schema.sql`: SQLite database schema like `CREATE TABLE`
      - `data.sql`: Optionally data with `INSERT INTO`
      - `fullmoon.lua`: Fullmoon web framework https://github.com/pkulchenko/fullmoon
      - `dblib.lua`: Database library 
      - `formlib.lua`: Form library
      - `util.lua`: Utilities
    - `srv/templates`: Backend templates with HTML/CSS/Lua
    - `srv/assets/` Frontend static HTML/CSS/JS

## 2) Database file: wekan.db

- SQLite database. It will be created to same directory where `wekan.com` is, if it does not already exist.

## Web browsers

- Tested with all browsers, works also without Javascript:
  - Modern browsers based on: Chromium, Firefox, Safari
  - Upcoming browsers: Ladybird
  - Limited Javascript: Netsurf, Amiga IBrowse, ReactOS 32bit Wine Internet Explorer
  - Without Javascript: Lynx, ELinks, w3m w3m-img, FreeDOS Dillo
  - Legacy browsers: Netscape, IE
- If browser has Javascript support, Javascript code can use https://unpoly.com for additional effects.
- No cookies. No localstorage. Sessions stored to serverside database, based on browser properties. More info at https://github.com/wekan/wekanstudio/blob/main/docs/roadmap.md#sessions

## Backend: Lua/SQLite

- SSR (Server Side Rendering). Like Web 1.0, with HTML/CSS at frontend using HTML Forms with POST/GET. Redbean at backend. Similar like LAMP.

## Cross-platform distro Cosmos

Related to Redbean, that is one part of Cosmos:

https://justine.lol/cosmo3/

## Full source build of Cosmopolitan

This is needed, if you are packaging Cosmopolitan related for some distro,
that requires full source build, and can not use precompiled compiler.

You'll need to use gcc-12.3 now, because that's the latest version
ahgamut has patched to build with cosmopolitan libc:

https://github.com/ahgamut/gcc/tree/portcosmo-12.3

Use the latest commit. To compile gcc, run:
```
make all-gcc

make install -i
```
Gcc's default build process tries to compile libgcc and libgomp
with the newly built xgcc binary, which ahgamut has not gotten
completely right just yet.

## WeKan Studio: General purpose web framework

This is general purpose web framework for creating any app, having features from:

- WeKan Open Source kanban https://wekan.github.io https://github.com/wekan/wekan/wiki/Deep-Dive-Into-WeKan
  - Same features, with changes to use minimal amount of code
  - Same API:
    - https://wekan.github.io/api/ 
    - https://github.com/wekan/wekan/blob/main/api.py
- WeKan Multiverse prototypes https://github.com/wekan/wekan/wiki/WeKan-Multiverse-Roadmap
- Database structure is same as in WeKan Open Source kanban https://wekan.github.io https://github.com/wekan/wekan (also features will be same and more),
  when exported to SQLite with https://github.com/wekan/minio-metadata

Web framework is based on:

- [Cosmopolitan](https://github.com/jart/cosmopolitan) cross-platform one executeable for Windows/Mac/Linux/BSD x86_64/arm64. There is no need for separate executeable for each CPU/OS.
- [Blink](https://github.com/jart/blink), that is x86_64 emulator faster than Qemu. With Blink, it is possible to run also at s390x, RISC-V etc, running like `blink wekan.com`.
- [Redbean](https://redbean.dev) webserver tech, where to end of C89/SQLite3/Lua server executeable is added Lua code and HTML/CSS/images etc like .zip file, files read from there directly without extracting
- [SQLite3](https://sqlite.org) database, that is included to Redbean.
- [Fullmoon](https://github.com/pkulchenko/fullmoon) Lua web framework, that is designed for Redbean webserver.
- [Petclinic](https://github.com/xet7/pet) example, that was ported from Java to Fullmoon, and added code that makes possible to use same SQLite database from many CGI-like Lua processes.

Native apps will be added for many CPU/OS. They will use same WeKan APIs, and native hardware features.

## Security

See https://redbean.dev about DDoS protection, sandboxing, asan and other security features.

If you know about any other technology, that can handle DDoS without CloudFlare, please email support@wekan.team

## Docs

How to build and run `wekan.com`:

https://github.com/wekan/wekanstudio/blob/main/docs/starting.md

Also other Docs at https://github.com/wekan/wekanstudio/tree/main/docs

## Docker

TODO. Related:

https://github.com/solisoft/luaonbeans/blob/main/Dockerfile
