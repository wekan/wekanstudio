## QuickJS

> I wonder if it's possible to pack a portable quickJS binary + one JS file into one ?
> the idea is to build a standalone executable with the JS engine and the JS code, all in one ?

You'd have to patch the quickjs source a little and recompile, but it should be possible. The general steps are:

1. patch quickjs source to add the line LoadZipArgs(&argc, &argv) at the start of wherever the main function is located
2. build qjs.com APE binary with cosmocc
3. `zip qjs.com my-file.js`
4. `echo '--script /zip/my-file.js' > .args`
5. `zip qjs.com .args`
