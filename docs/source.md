# Source

## WeKan Multiverse Roadmap

WeBean is one prototype of WeKan Multiverse:

https://github.com/wekan/wekan/wiki/WeKan-Multiverse-Roadmap

## Frontend

- UI look very similar to WeKan https://wekan.github.io
- HTML/CSS, optional Javascript
- Targeting browsers, optional Javascript
  - Netsurf, Amiga IBrowse: Optional Javascript, if some benefit
  - FreeDOS Dillo, Lynx, Links, "sudo apt install w3m w3m-img" with image support
  - Modern browsers https://github.com/wekan/wekan/wiki/Browser-compatibility-matrix

## Backend

- https://redbean.dev
  - From Cosmopolitan https://github.com/jart/cosmopolitan
  - Trying to use all possible security features of Redbean
  - Windows/Linux/Mac/BSD x86_86/arm64 single executeable redbean.com
    - Files added to end of wekan.com like embedded .zip file
    - Cron like feature to be used with WeKan scheduled tasks
    - SQLite3 database wekan.db, separate file
      - Database tables and fields lowercase (optional underscore _ if 2 words together)
- Pet store fork https://github.com/xet7/pet , that uses Fullmoon web framework
- WeKan https://wekan.github.io , https://github.com/wekan/wekan
