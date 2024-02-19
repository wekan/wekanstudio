# WeKanBean

## Description

This is general purpose web framework for creating any app, having features from:

- WeKan Open Source kanban https://wekan.github.io https://github.com/wekan/wekan/wiki/Deep-Dive-Into-WeKan
- WeKan Multiverse prototypes https://github.com/wekan/wekan/wiki/WeKan-Multiverse-Roadmap
- Database structure is same as in WeKan Open Source kanban https://wekan.github.io https://github.com/wekan/wekan (also features will be same and more),
  when exported to SQLite with https://github.com/wekan/minio-metadata

Web framework is based on:

- [Cosmopolitan](https://github.com/jart/cosmopolitan) cross-platform one executeable for Windows/Mac/Linux/BSD x86_64/arm64. There is no need for separate executeable for each CPU/OS.
- [Blink](https://github.com/jart/blink), that is x86_64 emulator faster than Qemu. With Blink, it is possible to run also at s390x, RISC-V etc, running like `blink wekan.com`.
- [Redbean](https://redbean.dev) webserver tech, where to end of C89/SQLite3/Lua server executeable is added Lua code and HTML/CSS/images etc like .zip file, files read from there
- [SQLite3](https://sqlite.org) database, that is included to Redbean.
- [Fullmoon](https://github.com/pkulchenko/fullmoon) Lua web framework, that is designed for Redbean webserver.
- [Petclinic](https://github.com/xet7/pet) example, that was ported from Java to Fullmoon, and added code that makes possible to use same SQLite database from many CGI-like Lua processes.

Native apps will be added for many CPU/OS. They will use APIs of above web framework.

## Security

See https://redbean.dev about DDoS protection, sandboxing, asan and other security features.

If you know about any other technology, that can handle DDoS without CloudFlare, please email support@wekan.team

## Docs

See at this repo `docs/starting.md` how to build `wekan.com` and run it. 

## Screenshot

Showing table view of `All Boards` page of WeKan Open Source kanban https://wekan.github.io

![screenshot](screenshot.png)
