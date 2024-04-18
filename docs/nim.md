## Nim

```
echo 'echo "hello world"' > hello.nim

CC=./bin/cosmocc nim c --cc:env -d:useMalloc --os:linux --nimcache:/tmp/nimcache hello

file hello
# hello: DOS/MBR boot sector; partition 1 : ID=0x7f, active, start-CHS (0x0,0,1), end-CHS (0x3ff,255,63), startsector 0, 4294967295 sectors

./hello

# hello world
```
