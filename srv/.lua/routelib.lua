
-- framework setup
local fm = require "fullmoon"

-- local setup
require "formlib"
require "dblib"
local util = require "util"

-- set template folder and extensions
fm.setTemplate({ "/templates/", fmt = "fmt" })

local pc = {}

-- set routes and handlers
local function welcome(r)
  return fm.serveContent("welcome")
end

local function showError(r)
  error("bogus!")  
end


local function findOwners(r)
    if r.params.lastName then
        local dbconn = pc:dbconn()
        local owners = assert(dbconn:query("select *, (select group_concat(name) from pets where pets.owner_id=owners.id) as pets from owners where last_name LIKE ? order by last_name",
            {r.params.lastName.."%"}))

        fm.logInfo(string.format("Rows: %s", #owners))

        return fm.serveContent("owners/ownersList", {owners = owners})
     else
       return fm.serveContent("owners/findOwners", {})
     end
end

local function showOwner(r)
    if r.params.id then
        local dbconn = pc:dbconn()
        local owner = assert(dbconn:queryOne("select * from owners where id=?", {r.params.id}))
        local pets = dbconn:query("select pets.id, pets.name, birth_date, types.name as type from pets, types where pets.type_id = types.id and pets.owner_id= ? order by      pets.name", {r.params.id})
        for _, pet in ipairs(pets) do
          local pet_id = pet.id
          local visits = assert(dbconn:query("select * from visits, pets where visits.pet_id=pets.id and pet_id = ? order by visit_date", {pet_id}))
          pet.visits = visits
        end

        if owner then
          return fm.serveContent("owners/ownerDetails", {owner = owner, pets = pets}) 
        end
    end
    return fm.serveRedirect(303, "/oops")
end

local function ownerForm()
    local form = Form:new({
    fields = {
        {name="first_name", label="First Name", widget="text", validators = {{minlen=1, msg = "must not be empty"},{maxlen=64, msg="must be more than 64 characters"}}},
        {name="last_name", label="Last Name", widget="text", validators = {{minlen=1, msg = "must not be empty"},{maxlen=64, msg="must be more than 64 characters"}}},
        {name="address", label="Address", widget="text", validators = {{minlen=1, msg = "must not be empty"},{maxlen=256, msg="must be more than 256 characters"}}},
        {name="city", label="City", widget="text", validators = {{minlen=1, msg = "must not be empty"},{maxlen=64, msg="must be less than 64 characters"}}},
        {name="telephone", label="Telephone", widget="text", validators = {{minlen=1, msg = "must not be empty"},
            {pattern="%d%d%d%d%d%d%d%d%d%d", msg="must be 10 digits  with no spaces or punctuation"}}}}
    })
    return form
end

local function editOwner(r)
  local dbconn = pc:dbconn()
  local form = ownerForm()
  
  if r.method == 'GET' then
    local owner = assert(dbconn:queryOne("select * from owners where id=?", {r.params.id}))
    form:bind(owner)
    return fm.serveContent("owners/createOrUpdateOwnerForm", {form = form, action='edit'}) 
  else
    form:bind(r.params)
    form:validate(r.params)
    fm.logInfo(util.dump(form))
    if form.valid then
      -- todo this would be a lot cleaner with named sql placeholders
      -- then we could just pass the form and have it match up by name
      assert(dbconn:execute("update owners set first_name=?, last_name=?, address=?, city=?, telephone=? where id=?",
        {r.params.first_name, r.params.last_name, r.params.address, r.params.city, r.params.telephone, r.params.id}))
    end
    return fm.serveRedirect(303, "/owners/"..r.params.id)
  end
end


local function newOwner(r)
  local form = ownerForm()
    
  if r.method == 'GET' then
    return fm.serveContent("owners/createOrUpdateOwnerForm", {form=form})
  else
    form:bind(r.params)
    form:validate(r.params)
    if form.valid then
      local dbconn = pc:dbconn()
      local results = assert(dbconn:queryOne("insert into owners (first_name, last_name, address, city, telephone) values (?, ?, ?, ?, ?) returning id",
         {r.params.first_name, r.params.last_name, r.params.address, r.params.city, r.params.telephone}))
      local owner_id = results.id
      return fm.serveRedirect(303, "/owners/"..owner_id)   
    end
    return fm.serveContent("owners/createOrUpdateOwnerForm", {form=form})
  end
end


local function petForm()
    local form = Form:new({
    fields = {
        {name="name", label="Name", widget="text", validators = {{minlen=1, msg = "must not be empty"},{maxlen=64, msg="must be more than 64 characters"}}},
        {name="birth_date", label="Birth Date", widget="date", validators = {{minlen=1, msg = "please select a date"}}},
        {name="type_id", label="Type", widget="select", options={}, validators = {}}}
    })
    return form
end

local function editPet(r)
  local dbconn = pc:dbconn()
  local form = petForm()
  local typeOptions = assert(dbconn:query("select id as value, name as label from types order by name"))
  form:setFieldOptions('type_id', typeOptions)
  
  if r.method == 'GET' then
    local owner = assert(dbconn:queryOne("select * from owners where id=?", {r.params.id}))
    local pet = assert(dbconn:queryOne("select * from pets where id=?", {r.params.pet_id}))
    form:bind(pet)
  else
    form:bind(r.params)
    form:validate(r.params)
    if form.valid then
      -- todo this would be a lot cleaner with named sql placeholders
      -- then we could just pass the form and have it match up by name
      assert(dbconn:execute("update pets set name=?, birth_date=?, type_id=? where id=?",
        {r.params.name, r.params.birth_date, r.params.type_id, r.params.pet_id}))
      return fm.serveRedirect(303, "/owners/"..r.params.id)
    end
  end
  return fm.serveContent("pets/createOrUpdatePetForm", {form = form, owner=owner, action='edit'}) 
end

local function newPet(r)
  local dbconn = pc:dbconn()
  local form = petForm()
  local typeOptions = assert(dbconn:query("select id as value, name as label from types order by name"))
  form:setFieldOptions('type_id', typeOptions)
    
  if r.method == 'GET' then    
    local owner = assert(dbconn:queryOne("select * from owners where id=?", {r.params.id}))
  else
    form:bind(r.params)
    form:validate(r.params)
    fm.logInfo(util.dump(form))
    if form.valid then
      assert(pc:dbconn():execute("insert into pets (name, birth_date, type_id, owner_id) values (?, ?, ?, ?)",
         {r.params.name, r.params.birth_date, r.params.type_id, r.params.id}))
      return fm.serveRedirect(303, "/owners/"..r.params.id)   
    end
  end
  return fm.serveContent("pets/createOrUpdatePetForm", {form=form, owner=owner})
end

local function visitForm()
    local form = Form:new({
    fields = {
        {name="visit_date", label="Visit Date", widget="date", validators = {{minlen=1, msg = "please choose a visit date"}}},
        {name="description", label="Description", widget="text", validators = {{minlen=1, msg = "must not be empty"},{maxlen=64, msg="must be more than 256 characters"}}},
        }
    })
    return form
end

local function newVisit(r)
  local dbconn = pc:dbconn()
  local form = visitForm()
    
  local owner = assert(dbconn:queryOne("select * from owners where id=?", {r.params.id}))
  local pet = assert(dbconn:queryOne("select * from pets where id=?", {r.params.pet_id}))
  local visits = assert(dbconn:query("select * from visits, pets where visits.pet_id=pets.id and pet_id = ? order by visit_date", {r.params.pet_id}))
    
  if r.method == 'GET' then    
    return fm.serveContent("pets/createOrUpdateVisitForm", {form=form, owner=owner, pet=pet, visits=visits})
  else
    form:bind(r.params)
    form:validate(r.params)
    if form.valid then
      assert(pc:dbconn():execute("insert into visits (pet_id, visit_date, description) values (?, ?, ?)",
         {r.params.pet_id, r.params.visit_date, r.params.description}))
      return fm.serveRedirect(303, "/owners/"..r.params.id)   
    end
    return fm.serveContent("pets/createOrUpdateVisitForm", {form=form, owner=owner, pet=pet, visits=visits})
  end
end


local function vetList(r)
  local dbconn = pc:dbconn()
  local vets = assert(dbconn:query("select *, (select group_concat(name) from specialties, vet_specialties where vet_specialties.vet_id=vets.id and vet_specialties.specialty_id=specialties.id) as specialties from vets order by last_name"))
  return fm.serveContent("vets/vetList", {vets = vets}) 
end        

-- Login

local function signUp(r)
  return fm.serveContent("login/signUp", {})
end

local function forgotPassword(r)
  return fm.serveContent("login/forgotPassword", {})
end

-- All Pages

local function allPages(r)
  return fm.serveContent("allPages", {})
end

-- Boards

local function allboardsList(r)
  local dbconn = pc:dbconn()
  -- local boards = assert(dbconn:query("select title, description, stars, permission, slug, type, sort from boards where archived='false' AND type='board' order by stars DESC, sort ASC;"))
  -- local boards = assert(dbconn:query("select title, description, stars, permission, slug, type, sort from boards where members like '%jmBkZ4KqncQuKWM9r%' AND archived='false' order by stars DESC, type ASC, sort ASC;"))
  local starboards = assert(dbconn:query("select _id, title, description, color, stars, permission, slug, type, sort from boards where members like '%jmBkZ4KqncQuKWM9r%' AND archived='false' AND stars>0 AND type='board' order by stars DESC, type ASC, sort ASC;"))
  local nostarboards = assert(dbconn:query("select _id, title, description, color, stars, permission, slug, type, sort from boards where members like '%jmBkZ4KqncQuKWM9r%' AND archived='false' AND stars=0 AND type='board' order by stars DESC, type ASC, sort ASC;"))
  local templateboards = assert(dbconn:query("select _id, title, description, color, stars, permission, slug, type, sort from boards where members like '%jmBkZ4KqncQuKWM9r%' AND archived='false' AND (type='template-board' OR type='template-container') order by stars DESC, type ASC, sort ASC;"))
  return fm.serveContent("boards/allboardsList", {starboards=starboards, nostarboards=nostarboards, templateboards=templateboards })
end

local function allboardsList2(r)
  return fm.serveContent("boards/allboardsList2", {})
end

local function allboardsList3(r)
  return fm.serveContent("boards/allboardsList3", {})
end

local function shortcuts(r)
  return fm.serveContent("boards/shortcuts", {})
end

local function templates(r)
  return fm.serveContent("boards/templates", {})
end

local function board(r)
  return fm.serveContent("boards/board", {})
end

local function public(r)
  return fm.serveContent("boards/public", {})
end

-- Cards

local function card(r)
  return fm.serveContent("cards/card", {})
end

local function myCards(r)
  return fm.serveContent("cards/myCards", {})
end

local function dueCards(r)
  return fm.serveContent("cards/dueCards", {})
end

local function signIn(r)
  return fm.serveContent("login/signIn", {})
end

-- Search

local function globalSearch(r)
  return fm.serveContent("search/globalSearch", {})
end

-- Admin

local function adminReports(r)
  return fm.serveContent("admin/adminReports", {})
end

local function attachments(r)
  return fm.serveContent("admin/attachments", {})
end

local function brokenCards(r)
  return fm.serveContent("admin/brokenCards", {})
end

local function information(r)
  return fm.serveContent("admin/information", {})
end

local function people(r)
  return fm.serveContent("admin/people", {})
end

local function translation(r)
  return fm.serveContent("admin/translation", {})
end

local function adminSettings(r)
  return fm.serveContent("admin/adminSettings", {})
end

-- Import Export

local function import(r)
  return fm.serveContent("importexport/import", {})
end

fm.setRoute("/", allPages)
fm.setRoute("/owners/new", newOwner)
fm.setRoute(fm.GET "/owners/find", findOwners)
fm.setRoute(fm.GET "/owners/:id[%d]", showOwner)
fm.setRoute("/owners/:id[%d]/edit", editOwner)
fm.setRoute("/owners/:id[%d]/pets/new", newPet)
fm.setRoute("/owners/:id[%d]/pets/:pet_id[%d]/edit", editPet)
fm.setRoute("/owners/:id[%d]/pets/:pet_id[%d]/visits/new", newVisit)
fm.setRoute(fm.GET "/vets", vetList)
fm.setRoute(fm.GET "/allboards",  allboardsList)
fm.setRoute(fm.GET "/allboards2", allboardsList2)
fm.setRoute(fm.GET "/allboards3", allboardsList3)
fm.setRoute(fm.GET "/sign-in", signIn)
fm.setRoute(fm.GET "/sign-up", signUp)
fm.setRoute(fm.GET "/forgot-password", forgotPassword)
fm.setRoute(fm.GET "/oops", showError)
fm.setRoute(fm.GET "/public", public)
-- fm.setRoute(fm.GET "/b/:id/:slug", board)
fm.setRoute(fm.GET "/board", board)
-- fm.setRoute(fm.GET "/b/:boardId/:slug/:cardId", card)
fm.setRoute(fm.GET "/card", card)
fm.setRoute(fm.GET "/shortcuts", shortcuts)
fm.setRoute(fm.GET "/templates", templates)
fm.setRoute(fm.GET "/my-cards", myCards)
fm.setRoute(fm.GET "/due-cards", dueCards)
fm.setRoute(fm.GET "/global-search", globalSearch)
fm.setRoute(fm.GET "/broken-cards", brokenCards)
fm.setRoute(fm.GET "/import", import)
fm.setRoute(fm.GET "/setting", adminSettings)
fm.setRoute(fm.GET "/information", information)
fm.setRoute(fm.GET "/people", people)
fm.setRoute(fm.GET "/admin-reports", adminReports)
fm.setRoute(fm.GET "/attachments", attachments)
fm.setRoute(fm.GET "/translation", translation)

-- // We maintain a list of redirections to ensure that we don't break old URLs
-- // when we change our routing scheme.
-- const redirections = {
--   '/boards': '/',
--   '/boards/:id/:slug': '/b/:id/:slug',
--   '/boards/:id/:slug/:cardId': '/b/:id/:slug/:cardId',
--  '/import': '/import/trello',
--};
--
--_.each(redirections, (newPath, oldPath) => {
--  FlowRouter.route(oldPath, {
--    triggersEnter: [
--      (context, redirect) => {
--        redirect(FlowRouter.path(newPath, context.params));
--      },
--    ],
--  });
--});


-- set static assets
fm.setRoute("/*", "/assets/*")

function pc.run(port)
    -- start the app on port specified
    fm.run({ port = port or 8000 })
end

--- This is now loaded from settings.lua:
--- local DBNAME = 'wekan.db'
require "dbsettings"

function pc:initDb()
    fm.logInfo("Initializing database")
    local dbm = fm.makeStorage(DBNAME)
    self.dbm = dbm
    local dbconn = self:dbconn()
    dbconn:runSqlInFile("/zip/.lua/schema.sql")
    -- dbconn:runSqlInFile("/zip/.lua/data.sql")

end

function pc:dbconn()
  return Dbconn:new({dbm = self.dbm})
end

return pc
