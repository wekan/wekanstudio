# Creating new page

## Currently

1. Add new database query to bottom of https://github.com/wekan/wekanbean/blob/main/srv/.lua/wekan.lua

```
local function allboardsList(r)
  local dbconn = pc:dbconn()
  local boards = assert(dbconn:query("select _id, title, description, color, stars, permission, slug, type, sort from boards where members like '%jmBkZ4KqncQuKWM9r%' AND archived='false' order by stars DESC, type ASC, sort ASC;"))
  return fm.serveContent("boards/allboardsList", {boards = boards})
end
```

2. Add new URL route below that:

```
fm.setRoute(fm.GET "/allboards", allboardsList)
```

3. Add new page to top menu of https://github.com/wekan/wekanbean/blob/main/srv/templates/layout.fmt

```
<li class="nav-item">
  <a class="nav-link {% if active_menu=='allboards' then%}active{%end%}" href="/allboards" title="allboards">
    <span class="fa fa-th-list"></span>
    <span>All Boards</span>
  </a>
</li>
```

4. Add page template, for example to https://github.com/wekan/wekanbean/blob/main/srv/templates/boards/allboardsList.fmt

5. For additional features, see Redbean/Fullmoon/Petclinic links at https://github.com/wekan/wekanbean#description

## Future

Web UI for creating new pages. For example, this kind of form, saved to database:
```
Page name:        _______________

Route:            _______________

SQL Query:        _______________

Template content: _______________
```

