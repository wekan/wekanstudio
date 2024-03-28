# CGI

Fullmoon also supports this with a simple CGI interface:

https://github.com/pkulchenko/fullmoon/blob/master/examples/showcase.lua#L114-L122

This code:
- Adds route like `/cgi` , it could also be any other URL like `/api` or `/product`.
- That route runs another `redbean.com` executeable process. It could also be Node.js process, or some other process.
- Some other routes are at https://github.com/wekan/wekanstudio/blob/main/srv/.lua/routelib.lua#L228
- That executeable runs some code, and exists with Redbean Lua code `unix.exit()`.
- Redbean specific additional commands are listed at https://redbean.dev

```lua
-- this route serves a CGI script launching another redbean process
fm.setRoute("/cgi", fm.serveContent("cgi",
    {'./redbean.com', nph = true, env = {HTTP_DNT = false},
    '-e', [[
print('HTTP/1.1 202 Accepted\r\nContent-Type: text/plain\r\n\r\nEnvironment:')
for _,v in ipairs(unix.environ()) do
  Sleep(0.1)
  print(v)
end]], '-e', 'unix.exit()'}))
```


# TODO

Add samples of all functionality like:

- CGI
- plain file
- form
- etc

Some of those are already at https://github.com/pkulchenko/fullmoon/blob/master/examples/showcase.lua
