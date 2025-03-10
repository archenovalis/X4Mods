-- ffi setup
local ffi = require("ffi")
local C = ffi.C
ffi.cdef [[
  typedef uint64_t UniverseID;

  typedef struct {
    float x;
    float y;
    float z;
  } Coord3D;
  typedef struct {
    const char* id;
    const char* name;
    int32_t state;
    const char* requiredversion;
    const char* installedversion;
  } InvalidPatchInfo;
  typedef struct {
    const char* classid;
    Coord3D size;
    bool inverted;
  } RegionBoundary;
  typedef struct {
    const char* id;
    uint32_t numfields;
    uint32_t numboundaries;
    uint32_t numresources;
    Coord3D size;
    float density;
    float speed;
    float rotationSpeed;
    float defaultNoiseScale;
    float defaultMinNoiseValue;
    float defaultMaxNoiseValue;
  } RegionDefinition;
  typedef struct {
    const char* fieldtype;
    const char* groupref;
  } RegionField;
  typedef struct {
    const char* wareid;
    const char* yield;
  } RegionResource;
  typedef struct {
    Coord3D offset;
    Coord3D tangent;
    float weight;
    float inlength;
    float outlength;
  } SplineData;
  typedef struct {
    const char* name;
    const char* id;
    const char* source;
    bool deleteable;
  } UIConstructionPlan;
  typedef struct {
    float x;
    float y;
    float z;
    float yaw;
    float pitch;
    float roll;
  } UIPosRot;

  void AddCluster(const char* macroname, UIPosRot offset);
  void AddGateConnection(UniverseID gateid, UniverseID othergateid);
  UniverseID AddHoloMap(const char* texturename, float x0, float x1, float y0, float y1, float aspectx, float aspecty);
  void AddSector(UniverseID clusterid, const char* macroname, UIPosRot offset);
  void ClearSelectedMapComponents(UniverseID holomapid);
  uint64_t ConvertStringTo64Bit(const char* idstring);
  void ExportMap(const char* mapname, const char* extensionid, bool personal);
  bool FindMacro(const char* macroname);
  uint32_t GetAllFactions(const char** result, uint32_t resultlen, bool includehidden);
  uint32_t GetCatalogTemplates(const char** result, uint32_t resultlen, const char* classid);
  int32_t GetCheckpointSequence(UniverseID checkpointid);
  const char* GetClusterBackground(UniverseID clusterid);
  const char* GetComponentName(UniverseID componentid);
  uint32_t GetConstructionPlanInvalidPatches(InvalidPatchInfo* result, uint32_t resultlen, const char* constructionplanid);
  uint32_t GetConstructionPlans(UIConstructionPlan* result, uint32_t resultlen);
  UniverseID GetContextByClass(UniverseID componentid, const char* classname, bool includeself);
  uint32_t GetHighwaySplinePoints(SplineData* result, uint32_t resultlen, UniverseID highwayid);
  const char* GetMacroClass(const char* macroname);
  uint32_t GetMacrosStartingWith(const char** result, uint32_t resultlen, const char* partialmacroname);
  uint32_t GetMapEditorObjectList(UniverseID* result, uint32_t resultlen);
  uint32_t GetNumAllFactions(bool includehidden);
  uint32_t GetNumCatalogTemplates(const char* classid);
  uint32_t GetNumConstructionPlans(void);
  uint32_t GetNumHighwaySplinePoints(UniverseID highwayid);
  uint32_t GetNumMacrosStartingWith(const char* partialmacroname);
  uint32_t GetNumMapEditorObjectList(void);
  uint32_t GetNumRegionDefinitions(void);
  uint32_t GetNumSectors(UniverseID clusterid);
  UIPosRot GetObjectPositionInSector(UniverseID objectid);
  UniverseID GetPlayerGalaxyID(void);
  UniverseID GetPlayerID(void);
  UIPosRot GetPositionalOffset(UniverseID positionalid, UniverseID spaceid);
  uint32_t GetRegionBoundaries(RegionBoundary* result, uint32_t resultlen, const char* regiondefinition);
  const char* GetRegionDefinition(UniverseID regionid);
  uint32_t GetRegionDefinitions(RegionDefinition* result, uint32_t resultlen);
  uint32_t GetRegionFields(RegionField* result, uint32_t resultlen, const char* regiondefinition);
  uint32_t GetRegionResources(RegionResource* result, uint32_t resultlen, const char* regiondefinition);
  bool IsConstructionPlanValid(const char* constructionplanid, uint32_t* numinvalidpatches);
  bool IsMasterVersion(void);
  bool IsPlayerContext(UniverseID componentid);
  void RemoveComponent(UniverseID componentid);
  void RemoveGateConnection(UniverseID gateid, UniverseID othergateid);
  void RemoveHoloMap(void);
  void ReplaceHighwaySpline(UniverseID highwayid, SplineData* splinepoints, uint32_t numsplinepoints, UniverseID holomapid);
  void RevealMap(void);
  void SaveUIUserData(void);
  void SetCheckpointSequence(UniverseID checkpointid, int32_t sequence);
  void SetClusterBackground(UniverseID clusterid, const char* macroname);
  void SetComponentDescription(UniverseID componentid, const char* desc);
  void SetEditBoxText(const int editboxid, const char* text);
  void SetKnownTo(UniverseID componentid, const char* factionid);
  void SetMapPicking(UniverseID holomapid, bool enable);
  void SetMapRelativeMousePosition(UniverseID holomapid, bool valid, float x, float y);
  void SetObjectForcedRadarVisible(UniverseID objectid, bool value);
  void SetObjectSectorPos(UniverseID objectid, UniverseID sectorid, UIPosRot offset);
  void SetComponentOwner(UniverseID componentid, const char* factionid);
  void SetPositionalOffset(UniverseID positionalid, UIPosRot offset);
  void SetRegionDefinition(UniverseID regionid, const char* definition);
  void SetSelectedMapComponent(UniverseID holomapid, UniverseID componentid);
  void ShowEditorMap(UniverseID holomapid, UniverseID sectorid);
  void SpawnLocalHighwayAtPos(const char* macroname, UniverseID sectorid, UIPosRot offset);
  UniverseID SpawnObjectAtPos2(const char* macroname, UniverseID sectorid, UIPosRot offset, const char* ownerid);
  UniverseID SpawnRegionAtPos(const char* regiondefinition, UniverseID sectorid, UIPosRot offset);
  UniverseID SpawnStationAtPos(const char* macroname, UniverseID sectorid, UIPosRot offset, const char* constructionplanid, const char* ownerid);
  void StartMapBoxSelect(UniverseID holomapid, bool selectenemies);
  void StartPanMap(UniverseID holomapid);
  void StartRotateMap(UniverseID holomapid);
  void StopMapBoxSelect(UniverseID holomapid);
  bool StopPanMap(UniverseID holomapid);
  bool StopRotateMap(UniverseID holomapid);
  void ZoomMap(UniverseID holomapid, float zoomstep);
]]

local UixMenu = {
  name = "Cheat_MapEditorMenu",
  holomap = 0,

  macrosearch = "",
  regiondefinition = "",
  constructionplan = "",
  cpfaction = "player",
  mapname = "",
  exportExtension = C.IsMasterVersion() and "" or "basegame",

  searchindex = {},
  selectedcomponent = 0,
  spawnTableMode = "object",
  frameData = {},
}

local EditorConfig = {
  mapFontSize = Helper.standardFontSize,
  backarrow = "table_arrow_inv_left",
  backarrowOffsetX = 3,
  standardFontSize = 10,
  headerTextHeight = 34,
  standardTextHeight = 19,
  standardTextOffsetX = 5,
  font = "Zekton outlined",
  fontBold = "Zekton bold outlined",
  headerFontSize = 13,
  headerTextOffsetX = 5,
  infoFontSize = 9,

  mainFrameLayer = 6,
  infoFrameLayer = 5,
  infoFrame2Layer = 4,
  contextFrameLayer = 2,
  topLevelLayer = 1,

  leftBar = {
    { name = "Spawn Object",                    icon = "mapob_poi",       mode = "object" },   -- TEMPTEXT Florian
    { name = "Spawn Construction Plan Station", icon = "mapob_factory",   mode = "station" },  -- TEMPTEXT Florian
    { name = "Spawn Region",                    icon = "mapob_region",    mode = "region" },   -- TEMPTEXT Florian
    { name = "Spawn Local Highway",             icon = "maplegend_hw_01", mode = "highway" },  -- TEMPTEXT Florian
    { name = "Settings",                        icon = "menu_options",    mode = "settings" }, -- TEMPTEXT Florian
  },

  clusterGridEdgeLength = 10000000,
}

EditorConfig.headerTextProperties = {
  font = EditorConfig.fontBold,
  fontsize = EditorConfig.headerFontSize,
  x = EditorConfig.headerTextOffsetX,
  y = 6,
  minRowHeight = EditorConfig.headerTextHeight,
  titleColor = Color["row_title"],
}

__CORE_DETAILMONITOR_MAPEDITOR = __CORE_DETAILMONITOR_MAPEDITOR or {
  opacity = 98,
}

local MapMenu = nil
local ModLua = {}

function ModLua.init()
  Menus = Menus or {}
  table.insert(Menus, UixMenu)
  if Helper then
    Helper.registerMenu(UixMenu)
  end
  MapMenu = Helper.getMenu("MapMenu")
  MapMenu.registerCallback("buttonToggleObjectList_on_start", UixMenu.buttonToggleObjectList_on_start)
  MapMenu.registerCallback("createSideBar_on_start", UixMenu.createSideBar_on_start)
  MapMenu.registerCallback("createInfoFrame_on_menu_infoTableMode", UixMenu.displayMapEditor)
  MapMenu.registerCallback("cleanup", UixMenu.cleanup)
end

function UixMenu.cleanup()
  UixMenu.noupdate = nil
  if UixMenu.holomap ~= 0 then
    C.RemoveHoloMap()
    UixMenu.holomap = 0
  end
  UixMenu.activatemap = nil

  UixMenu.selectedcomponent = 0
  UixMenu.selectedComponentSector = nil
  UixMenu.selectedComponentOffset = nil
end

function UixMenu.addToLeftBar(config)
  local mapEditorMenuExists
  for _, leftBarEntry in ipairs(config.leftBar) do
    if leftBarEntry.mode == "cheat_mapeditor" then
      mapEditorMenuExists = true
    end
  end
  if not mapEditorMenuExists then
    local mapEditorBtn = {
      name = "Cheat Map Editor",
      icon = "shipbuildst_repair",
      mode = "cheat_mapeditor",
      helpOverlayID = "mapmenu_sidebar_mapeditor",
      helpOverlayText = "Map Editor"
    }

    table.insert(config.leftBar, 3, mapEditorBtn)
  end
  UixMenu.config = config
end

function UixMenu.buttonToggleObjectList_on_start(objectlistparam, config)
  UixMenu.addToLeftBar(config)
end

function UixMenu.createSideBar_on_start(config)
  UixMenu.addToLeftBar(config)
end

function UixMenu.displayMapEditor()
  if MapMenu ~= nil then
    Helper.closeMenu(MapMenu, "close")
    MapMenu.cleanup()
  end
  OpenMenu("Cheat_MapEditorMenu", { 0, 0 }, nil)
end

function UixMenu.onShowMenu()
  UixMenu.sideBarWidth = Helper.scaleX(Helper.sidebarWidth)

  if UixMenu.mapname == "" then
    local galaxy = C.GetPlayerGalaxyID()
    local galaxymacro = GetComponentData(ConvertStringToLuaID(tostring(galaxy)), "macro")
    UixMenu.mapname = string.match(galaxymacro, "(.-)_galaxy_macro") or ""
    local cropbasename = string.match(UixMenu.mapname, "^basegame_map_(.+)")
    if cropbasename then
      UixMenu.mapname = cropbasename
    end
  end

  UixMenu.objects = {}
  local n = C.GetNumMapEditorObjectList()
  if n > 0 then
    local buf = ffi.new("UniverseID[?]", n)
    n = C.GetMapEditorObjectList(buf, n)
    for i = 0, n - 1 do
      local id = buf[i]
      C.SetObjectForcedRadarVisible(id, true)
      C.SetKnownTo(id, "player")
      table.insert(UixMenu.objects, { id = id })
    end
  end

  UixMenu.getRegionDefinitions()
  UixMenu.getConstructionPlans()
  UixMenu.getFactions()

  -- map
  UixMenu.rendertargetWidth = Helper.viewWidth
  UixMenu.rendertargetHeight = Helper.viewHeight

  --C.RevealMap()
  AddUITriggeredEvent("CheatMenu", "full_reveal")

  UixMenu.displayMenu()
end

function UixMenu.displayMenu()
  UixMenu.createMainFrame()
  UixMenu.createInfoFrame()
end

function UixMenu.createMainFrame()
  UixMenu.createMainFrameRunning = true
  Helper.removeAllWidgetScripts(UixMenu, EditorConfig.mainFrameLayer)

  UixMenu.mainFrame = Helper.createFrameHandle(UixMenu, {
    layer = EditorConfig.mainFrameLayer,
    standardButtons = { back = true, close = true },
    width = Helper.viewWidth,
    height = Helper.viewHeight,
    x = 0,
    y = 0,
  })

  -- rendertarget
  local alpha = __CORE_DETAILMONITOR_MAPEDITOR.opacity
  UixMenu.mainFrame:addRenderTarget({
    width = UixMenu.rendertargetWidth,
    height = UixMenu.rendertargetHeight,
    x = 0,
    y = 0,
    scaling = false,
    alpha = alpha,
    clear = false
  })

  -- left bar
  UixMenu.createSideBar(UixMenu.mainFrame)

  UixMenu.mainFrame:display()
end

function UixMenu.getRegionDefinitions()
  UixMenu.regiondefinitions = {}
  UixMenu.regiondefinitionbyref = {}
  local n = C.GetNumRegionDefinitions()
  if n > 0 then
    local buf = ffi.new("RegionDefinition[?]", n)
    n = C.GetRegionDefinitions(buf, n)
    for i = 0, n - 1 do
      local entry = {}

      entry.id = ffi.string(buf[i].id)
      entry.size = { x = 2 * buf[i].size.x, y = 2 * buf[i].size.y, z = 2 * buf[i].size.z }
      entry.density = buf[i].density
      entry.speed = buf[i].speed
      entry.rotationSpeed = buf[i].rotationSpeed
      entry.defaultNoiseScale = buf[i].defaultNoiseScale
      entry.defaultMinNoiseValue = buf[i].defaultMinNoiseValue
      entry.defaultMaxNoiseValue = buf[i].defaultMaxNoiseValue

      entry.fields = {}
      local buf_fields = ffi.new("RegionField[?]", buf[i].numfields)
      local numfields = C.GetRegionFields(buf_fields, buf[i].numfields, entry.id)
      for j = 0, numfields - 1 do
        local field = {}

        field.fieldtype = ffi.string(buf_fields[j].fieldtype)
        field.groupref = ffi.string(buf_fields[j].groupref)

        table.insert(entry.fields, field)
      end

      entry.boundaries = {}
      local buf_boundaries = ffi.new("RegionBoundary[?]", buf[i].numboundaries)
      local numboundaries = C.GetRegionBoundaries(buf_boundaries, buf[i].numboundaries, entry.id)
      for j = 0, numboundaries - 1 do
        local boundary = {}

        boundary.classid = ffi.string(buf_boundaries[j].classid)
        boundary.halfsize = { x = buf_boundaries[j].size.x, y = buf_boundaries[j].size.y, z = buf_boundaries[j].size.z }
        boundary.inverted = buf_boundaries[j].inverted

        table.insert(entry.boundaries, boundary)
      end

      entry.resources = {}
      local buf_resources = ffi.new("RegionResource[?]", buf[i].numresources)
      local numresources = C.GetRegionResources(buf_resources, buf[i].numresources, entry.id)
      for j = 0, numresources - 1 do
        local resource = {}

        resource.ware = ffi.string(buf_resources[j].wareid)
        resource.yield = ffi.string(buf_resources[j].yield)

        table.insert(entry.resources, resource)
      end

      table.insert(UixMenu.regiondefinitions, entry)
      UixMenu.regiondefinitionbyref[entry.id] = entry
    end
  end
end

function UixMenu.getConstructionPlans()
  UixMenu.constructionplans = {}
  local n = C.GetNumConstructionPlans()
  local buf = ffi.new("UIConstructionPlan[?]", n)
  n = C.GetConstructionPlans(buf, n)
  local ischeatversion = true
  for i = 0, n - 1 do
    local id = ffi.string(buf[i].id)
    local source = ffi.string(buf[i].source)
    if source ~= "local" then
      local isvalid = true
      local mouseovertext
      local numinvalidpatches = ffi.new("uint32_t[?]", 1)
      if C.IsConstructionPlanValid(id, numinvalidpatches) then
        mouseovertext = id
      else
        isvalid = false
        local numpatches = numinvalidpatches[0]
        local patchbuf = ffi.new("InvalidPatchInfo[?]", numpatches)
        numpatches = C.GetConstructionPlanInvalidPatches(patchbuf, numpatches, id)
        mouseovertext = ReadText(1001, 2685) .. ReadText(1001, 120) -- Missing, old or disabled extensions:
        for j = 0, numpatches - 1 do
          if j > 3 then
            mouseovertext = mouseovertext .. "\n- ..."
            break
          end
          mouseovertext = mouseovertext ..
              "\n- " ..
              ffi.string(patchbuf[j].name) ..
              " (" .. ffi.string(patchbuf[j].id) .. " - " .. ffi.string(patchbuf[j].requiredversion) .. ")"
          if patchbuf[j].state == 2 then
            mouseovertext = mouseovertext .. " " .. ReadText(1001, 2686)
          elseif patchbuf[j].state == 3 then
            mouseovertext = mouseovertext .. " " .. ReadText(1001, 2687)
          elseif patchbuf[j].state == 4 then
            mouseovertext = mouseovertext ..
                " " .. string.format(ReadText(1001, 2688), ffi.string(patchbuf[j].installedversion))
          end
        end
      end

      table.insert(UixMenu.constructionplans,
        { id = id, text = ffi.string(buf[i].name), icon = "", displayremoveoption = false, active = isvalid, mouseovertext = (mouseovertext or "") })
    end
  end
  table.sort(UixMenu.constructionplans, function(a, b) return a.text < b.text end)
end

function UixMenu.getFactions()
  -- all factions
  UixMenu.factions = {}
  local n = C.GetNumAllFactions(false)
  local buf = ffi.new("const char*[?]", n)
  n = C.GetAllFactions(buf, n, false)
  for i = 0, n - 1 do
    local id = ffi.string(buf[i])
    if id ~= "player" then
      table.insert(UixMenu.factions,
        { id = id, text = GetFactionData(id, "name"), icon = "", displayremoveoption = false })
    end
  end
  table.sort(UixMenu.factions, function(a, b) return a.text < b.text end)
  -- player faction in front
  table.insert(UixMenu.factions, 1, { id = "player", text = "Player", icon = "", displayremoveoption = false }) -- TEMPTEXT Florian
end

function UixMenu.refreshMainFrame()
  if not UixMenu.createMainFrameRunning then
    UixMenu.createMainFrame()
  end
end

function UixMenu.createSideBar(frame)
  local spacingHeight = UixMenu.sideBarWidth / 4
  local defaultInteractiveObject = UixMenu.spawnTableMode == nil
  local ftable = frame:addTable(1,
    {
      tabOrder = 21,
      width = UixMenu.sideBarWidth,
      x = Helper.frameBorder,
      y = Helper.frameBorder,
      scaling = false,
      borderEnabled = false,
      reserveScrollBar = false,
      defaultInteractiveObject =
          defaultInteractiveObject
    })

  local leftbar = EditorConfig.leftBar
  for _, entry in ipairs(leftbar) do
    if (entry.condition == nil) or entry.condition() then
      if not entry.spacing then
        entry.active = true
        if entry.active then
          local selectedmode = false
          if type(entry.mode) == "table" then
            for _, mode in ipairs(entry) do
              if mode == UixMenu.spawnTableMode then
                selectedmode = true
                break
              end
            end
          else
            if entry.mode == UixMenu.spawnTableMode then
              selectedmode = true
            end
          end
        end
      end
    end
  end

  for _, entry in ipairs(leftbar) do
    if (entry.condition == nil) or entry.condition() then
      if entry.spacing then
        local row = ftable:addRow(false, { fixed = true })
        row[1]:createIcon("mapst_seperator_line", { width = UixMenu.sideBarWidth, height = spacingHeight })
      else
        local mode = entry.mode
        if type(entry.mode) == "table" then
          mode = mode[1]
        end
        local row = ftable:addRow(true, { fixed = true })
        local bgcolor = Color["row_title_background"]
        if type(entry.mode) == "table" then
          for _, mode in ipairs(entry) do
            if mode == UixMenu.spawnTableMode then
              bgcolor = Color["row_background_blue"]
              break
            end
          end
        else
          if entry.mode == UixMenu.spawnTableMode then
            bgcolor = Color["row_background_blue"]
          end
        end
        local color = Color["icon_normal"]

        row[1]:createButton({
          active = entry.active,
          height = UixMenu.sideBarWidth,
          bgColor = bgcolor,
          mouseOverText = entry
              .name,
          helpOverlayID = entry.helpOverlayID,
          helpOverlayText = entry.helpOverlayText
        }):setIcon(entry.icon,
          { color = color })
        row[1].handlers.onClick = function() return UixMenu.buttonToggleSpawnTable(mode) end
      end
    end
  end
end

function UixMenu.createInfoFrame()
  UixMenu.createInfoFrameRunning = true
  Helper.removeAllWidgetScripts(UixMenu, EditorConfig.infoFrameLayer)

  UixMenu.infoFrame = Helper.createFrameHandle(UixMenu, {
    layer = EditorConfig.infoFrameLayer,
    standardButtons = {},
    width = Helper.viewWidth,
    height = Helper.viewHeight,
    x = 0,
    y = 0,
  })

  UixMenu.createSpawnTable(UixMenu.infoFrame)
  UixMenu.createComponentTable(UixMenu.infoFrame)
  UixMenu.createExportTable(UixMenu.infoFrame)

  UixMenu.infoFrame:display()
end

function UixMenu.refreshInfoFrame()
  if not UixMenu.createInfoFrameRunning then
    UixMenu.createInfoFrame()
  end
end

function UixMenu.createSpawnTable(frame)
  local numcols = 3
  local ftable = frame:addTable(numcols,
    {
      tabOrder = 1,
      width = 500,
      x = Helper.frameBorder + UixMenu.sideBarWidth + 2 * Helper.borderSize,
      y = Helper
          .frameBorder
    })

  if UixMenu.spawnTableMode == "object" then
    local row = ftable:addRow(nil, { fixed = true })
    row[1]:setColSpan(numcols):createText("Spawn Object", Helper.headerRowCenteredProperties) -- TEMPTEXT Florian

    local row = ftable:addRow(true, { fixed = true })
    row[1]:setColSpan(numcols):createEditBox({ height = Helper.standardTextHeight, defaultText = "Find macro..." })
        :setText(UixMenu.macrosearch) -- TEMPTEXT Florian
    row[1].handlers.onTextChanged = function(_, text, textchanged)
      UixMenu.macrosearch = text; UixMenu.refreshInfoFrame2()
    end
    row[1].handlers.onEditBoxActivated = function()
      UixMenu.showMacroSuggestions = true; UixMenu.refreshInfoFrame2()
    end
    row[1].handlers.onEditBoxDeactivated = function()
      UixMenu.showMacroSuggestions = false; UixMenu.refreshInfoFrame2(); UixMenu.refreshInfoFrame()
    end

    local row = ftable:addRow(nil, { fixed = true })
    row[1]:setColSpan(numcols):createText(UixMenu.macroSearchText, { color = UixMenu.macroSearchColor })

    local searchhistory = {}
    for macro, name in pairs(UixMenu.searchindex) do
      table.insert(searchhistory, { macro = macro, name = name })
    end
    table.sort(searchhistory, Helper.sortName)

    ftable:addEmptyRow()

    local row = ftable:addRow(nil, { fixed = true })
    row[1]:setColSpan(numcols):createText("History", Helper.headerRowCenteredProperties) -- TEMPTEXT Florian

    if #searchhistory > 0 then
      for _, entry in ipairs(searchhistory) do
        local row = ftable:addRow(true, {})
        row[1]:setColSpan(numcols):createButton({}):setText(entry.name .. " (" .. entry.macro .. ")")
        row[1].handlers.onClick = function() UixMenu.macrosearch = entry.macro end
      end
    else
      local row = ftable:addRow(true, {})
      row[1]:setColSpan(numcols):createText("--- No entries ---") -- TEMPTEXT Florian
    end

    local row = ftable:addRow(true, {})
    row[3]:createButton({}):setText("Clear", { halign = "center" }) -- TEMPTEXT Florian
    row[3].handlers.onClick = function()
      UixMenu.searchindex = {}; UixMenu.refreshInfoFrame()
    end
  elseif UixMenu.spawnTableMode == "region" then
    local row = ftable:addRow(nil, { fixed = true })
    row[1]:setColSpan(numcols):createText("Spawn Region", Helper.headerRowCenteredProperties) -- TEMPTEXT Florian

    local regionoptions = {}
    for _, definition in ipairs(UixMenu.regiondefinitions) do
      table.insert(regionoptions, { id = definition.id, text = definition.id, icon = "", displayremoveoption = false })
    end

    local row = ftable:addRow(true, {})
    row[1]:createText("Region Definition:") -- TEMPTEXT Florian
    row[2]:setColSpan(2):createDropDown(regionoptions,
      { height = Helper.standardTextHeight, startOption = UixMenu.regiondefinition }):setTextProperties({
      fontsize = EditorConfig
          .mapFontSize
    })
    row[2].handlers.onDropDownConfirmed = function(_, id) UixMenu.regiondefinition = id end

    ftable:addEmptyRow()

    local row = ftable:addRow(nil, {})
    row[1]:setColSpan(numcols):createText(UixMenu.regionSearchText)
  elseif UixMenu.spawnTableMode == "station" then
    local row = ftable:addRow(nil, { fixed = true })
    row[1]:setColSpan(numcols):createText("Spawn Construction Plan Station", Helper.headerRowCenteredProperties) -- TEMPTEXT Florian

    local row = ftable:addRow(true, {})
    row[1]:createText("Construction Plan:") -- TEMPTEXT Florian
    row[2]:setColSpan(2):createDropDown(UixMenu.constructionplans,
      { height = Helper.standardTextHeight, startOption = UixMenu.constructionplan }):setTextProperties({
      fontsize = EditorConfig
          .mapFontSize
    })
    row[2].handlers.onDropDownConfirmed = function(_, id) UixMenu.constructionplan = id end

    local row = ftable:addRow(true, {})
    row[1]:createText("Station Owner:") -- TEMPTEXT Florian
    row[2]:setColSpan(2):createDropDown(UixMenu.factions,
      { height = Helper.standardTextHeight, startOption = UixMenu.cpfaction }):setTextProperties({
      fontsize = EditorConfig
          .mapFontSize
    })
    row[2].handlers.onDropDownConfirmed = function(_, id) UixMenu.cpfaction = id end

    ftable:addEmptyRow()

    local row = ftable:addRow(nil, {})
    row[1]:setColSpan(numcols):createText(UixMenu.stationSearchText)
  elseif UixMenu.spawnTableMode == "settings" then
    local row = ftable:addRow(nil, { fixed = true })
    row[1]:setColSpan(numcols):createText("Settings", Helper.headerRowCenteredProperties) -- TEMPTEXT Florian

    local row = ftable:addRow(true, {})
    row[1]:createText("Map Opacity:") -- TEMPTEXT Florian
    row[2]:setColSpan(2):createSliderCell({
      height = Helper.standardTextHeight,
      min = 0,
      max = 100,
      start = __CORE_DETAILMONITOR_MAPEDITOR.opacity,
      hideMaxValue = true,
    })
    row[2].handlers.onSliderCellChanged = function(_, value)
      __CORE_DETAILMONITOR_MAPEDITOR.opacity = value; C.SaveUIUserData(); UixMenu.refreshMainFrame()
    end
  elseif UixMenu.spawnTableMode == "highway" then
    local row = ftable:addRow(nil, { fixed = true })
    row[1]:setColSpan(numcols):createText("Spawn Local Highway", Helper.headerRowCenteredProperties) -- TEMPTEXT Florian

    local row = ftable:addRow(nil, {})
    row[1]:setColSpan(numcols):createText("Ctrl+RMB on the map to spawn a local highway") -- TEMPTEXT Florian
  end
end

function UixMenu.macroSearchText()
  if C.FindMacro(UixMenu.macrosearch) then
    local name = GetMacroData(UixMenu.macrosearch, "name")
    UixMenu.searchindex[string.lower(UixMenu.macrosearch)] = name

    local class = ffi.string(C.GetMacroClass(UixMenu.macrosearch))
    local postfix = ""
    if IsMacroClass(UixMenu.macrosearch, "object") then
      postfix = "\n\nCtrl+RMB on the map to spawn this object"                                     -- TEMPTEXT Florian
    end
    return ColorText["text_positive"] .. "[Found]\27X " .. name .. "\nClass: " .. class .. postfix -- TEMPTEXT Florian
  end
  return UixMenu.macrosearch .. "\n \n \n "
end

function UixMenu.regionSearchText()
  if UixMenu.regiondefinition ~= "" then
    local def = UixMenu.regiondefinitionbyref[UixMenu.regiondefinition]
    if def then
      local text = ""

      text = text ..
          "Bounding Box: " ..
          tostring(def.size.x) ..
          "m / " ..
          tostring(def.size.y) ..
          "m / " .. tostring(def.size.z) .. "m" -- TEMPTEXT Florian
      text = text ..
          "\nDensity: " ..
          def.density -- TEMPTEXT Florian
      text = text ..
          "\nSpeed: " ..
          def.speed ..
          "m/s? - unused?" -- TEMPTEXT Florian
      text = text ..
          "\nRotation Speed: " ..
          def.rotationSpeed ..
          "rad/s? - unused?" -- TEMPTEXT Florian
      text = text ..
          "\nDefault Noise Scale: " ..
          def.defaultNoiseScale -- TEMPTEXT Florian
      text = text ..
          "\nDefault Min Noise Value: " ..
          def.defaultMinNoiseValue -- TEMPTEXT Florian
      text = text ..
          "\nDefault Max Noise Value: " ..
          def.defaultMaxNoiseValue -- TEMPTEXT Florian

      text = text ..
          "\n\nBoundaries:" -- TEMPTEXT Florian
      for _, boundary in ipairs(def.boundaries) do
        local size = ""
        if boundary.classid == "sphere" then
          size = "r = " ..
              boundary.halfsize.x ..
              "m" -- TEMPTEXT Florian
        elseif boundary.classid == "cylinder" then
          size = "r = " ..
              boundary.halfsize.x ..
              "m, l = " .. 2 * boundary.halfsize.y .. "m" -- TEMPTEXT Florian
        elseif boundary.classid == "box" then
          size = "x = " ..
              2 * boundary.halfsize.x ..
              "m, y = " ..
              2 * boundary.halfsize.y ..
              "m, z = " .. 2 * boundary.halfsize.z .. "m" -- TEMPTEXT Florian
        elseif boundary.classid == "splinetube" then
          size = "tube r = " ..
              boundary.halfsize.x ..
              "m" -- TEMPTEXT Florian
        end

        text = text ..
            "\n   Type: " ..
            boundary.classid ..
            " (" ..
            size .. ")" .. (boundary.inverted and " - inverted" or "") -- TEMPTEXT Florian
      end

      text = text .. "\n\nFields:"                                                           -- TEMPTEXT Florian
      for _, field in ipairs(def.fields) do
        text = text .. "\n   Type: " .. field.fieldtype .. " - GroupRef: " .. field.groupref -- TEMPTEXT Florian
      end

      text = text .. "\n\nResources:"                                                   -- TEMPTEXT Florian
      for _, resource in ipairs(def.resources) do
        text = text .. "\n   Ware: " .. resource.ware .. " - Yield: " .. resource.yield -- TEMPTEXT Florian
      end

      text = text .. "\n\nCtrl+RMB on the map to spawn this region" -- TEMPTEXT Florian

      return text
    end
  end
  return ""
end

function UixMenu.stationSearchText()
  if UixMenu.constructionplan ~= "" then
    return "\nCtrl+RMB on the map to spawn this station" -- TEMPTEXT Florian
  end
  return ""
end

function UixMenu.macroSearchColor()
  if C.FindMacro(UixMenu.macrosearch) then
    return Color["text_normal"]
  end
  return Color["text_inactive"]
end

function UixMenu.createComponentTable(frame)
  local width = 500

  local numcols = 3
  local ftable = frame:addTable(numcols,
    { tabOrder = 2, width = width, x = Helper.viewWidth - width - Helper.frameBorder, y = Helper.frameBorder })

  if UixMenu.gateconnection ~= UixMenu.selectedcomponent then
    UixMenu.gateconnection = nil
  end

  local row = ftable:addRow(nil, { fixed = true })
  row[1]:setColSpan(numcols):createText("Selected Component", Helper.headerRowCenteredProperties) -- TEMPTEXT Florian

  if UixMenu.selectedcomponent ~= 0 then
    if C.IsComponentClass(UixMenu.selectedcomponent, "object") then
      UixMenu.selectedComponentSector = C.GetContextByClass(UixMenu.selectedcomponent, "sector", false)
      UixMenu.selectedComponentOffset = C.GetObjectPositionInSector(UixMenu.selectedcomponent)

      UixMenu.addNameRows(ftable, UixMenu.selectedcomponent)

      UixMenu.addObjectOffsetRow(ftable, "X", "x", "m")               -- TEMPTEXT Florian
      UixMenu.addObjectOffsetRow(ftable, "Y", "y", "m")               -- TEMPTEXT Florian
      UixMenu.addObjectOffsetRow(ftable, "Z", "z", "m")               -- TEMPTEXT Florian
      UixMenu.addObjectOffsetRow(ftable, "Yaw", "yaw", "°", true)     -- TEMPTEXT Florian
      UixMenu.addObjectOffsetRow(ftable, "Pitch", "pitch", "°", true) -- TEMPTEXT Florian
      UixMenu.addObjectOffsetRow(ftable, "Roll", "roll", "°", true)   -- TEMPTEXT Florian

      ftable:addEmptyRow()

      local luaselectedcomponent = ConvertStringToLuaID(tostring(UixMenu.selectedcomponent))
      local owner, destination, destinationsector = GetComponentData(luaselectedcomponent, "owner", "destination",
        "destinationsector")

      local row = ftable:addRow(true, {})
      row[1]:createText("Owner:") -- TEMPTEXT Florian
      row[2]:setColSpan(2):createDropDown(UixMenu.factions, { height = Helper.standardTextHeight, startOption = owner })
          :setTextProperties({ fontsize = EditorConfig.mapFontSize })
      row[2].handlers.onDropDownConfirmed = function(_, id) C.SetComponentOwner(UixMenu.selectedcomponent, id) end

      if C.IsComponentClass(UixMenu.selectedcomponent, "checkpoint") then
        ftable:addEmptyRow()

        local row = ftable:addRow(true, {})
        row[1]:setColSpan(2):createText("Sequence:") -- TEMPTEXT Florian
        local editbox = row[3]:createEditBox({ height = Helper.standardTextHeight }):setText(C.GetCheckpointSequence(
          UixMenu.selectedcomponent))
        row[3].handlers.onTextChanged = function(_, text, textchanged)
          if (text ~= "") and tonumber(text) then
            C.SetCheckpointSequence(UixMenu.selectedcomponent, tonumber(text))
          end
        end
        row[3].handlers.onEditBoxDeactivated = function(_, text, textchanged)
          C.SetEditBoxText(editbox.id,
            tostring(C.GetCheckpointSequence(UixMenu.selectedcomponent)))
        end
      elseif C.IsComponentClass(UixMenu.selectedcomponent, "gate") then
        ftable:addEmptyRow()

        if destination then
          local name = GetComponentData(destinationsector, "name")

          local row = ftable:addRow(true, {})
          row[1]:setColSpan(2):createText("Destination:") -- TEMPTEXT Florian
          row[3]:createText(name)

          local row = ftable:addRow(true, {})
          row[3]:createButton({}):setText("Remove Connection", { halign = "center" }) -- TEMPTEXT Florian
          row[3].handlers.onClick = function()
            C.RemoveGateConnection(UixMenu.selectedcomponent, C.ConvertStringTo64Bit(tostring(destination))); UixMenu
                .refreshInfoFrame()
          end
        else
          local row = ftable:addRow(true, {})
          row[1]:setColSpan(3):createButton({}):setText("Add Gate Connection") -- TEMPTEXT Florian
          row[1].handlers.onClick = function()
            UixMenu.gateconnection = UixMenu.selectedcomponent; UixMenu.refreshInfoFrame()
          end

          if UixMenu.gateconnection then
            local row = ftable:addRow(true, {})
            row[1]:setColSpan(3):createText("Select another inactive gate to set the connection", { wordwrap = true }) -- TEMPTEXT Florian
          end
        end
      end

      ftable:addEmptyRow()

      local row = ftable:addRow(true, {})
      row[3]:createButton({}):setText("Remove", { halign = "center" }) -- TEMPTEXT Florian
      row[3].handlers.onClick = function()
        C.RemoveComponent(UixMenu.selectedcomponent); UixMenu.selectedcomponent = 0; UixMenu.refreshInfoFrame()
      end
    elseif C.IsComponentClass(UixMenu.selectedcomponent, "region") then
      UixMenu.selectedComponentCluster = C.GetContextByClass(UixMenu.selectedcomponent, "cluster", false)
      UixMenu.selectedComponentOffset = C.GetPositionalOffset(UixMenu.selectedcomponent, 0)

      UixMenu.addPositionalOffsetRow(ftable, "X", "x", "m")               -- TEMPTEXT Florian
      UixMenu.addPositionalOffsetRow(ftable, "Y", "y", "m")               -- TEMPTEXT Florian
      UixMenu.addPositionalOffsetRow(ftable, "Z", "z", "m")               -- TEMPTEXT Florian
      UixMenu.addPositionalOffsetRow(ftable, "Yaw", "yaw", "°", true)     -- TEMPTEXT Florian
      UixMenu.addPositionalOffsetRow(ftable, "Pitch", "pitch", "°", true) -- TEMPTEXT Florian
      UixMenu.addPositionalOffsetRow(ftable, "Roll", "roll", "°", true)   -- TEMPTEXT Florian

      ftable:addEmptyRow()

      local regionoptions = {}
      for _, definition in ipairs(UixMenu.regiondefinitions) do
        table.insert(regionoptions, { id = definition.id, text = definition.id, icon = "", displayremoveoption = false })
      end

      local row = ftable:addRow(true, {})
      row[1]:createText("Region Definition:") -- TEMPTEXT Florian
      row[2]:setColSpan(2):createDropDown(regionoptions,
        { height = Helper.standardTextHeight, startOption = ffi.string(C.GetRegionDefinition(UixMenu.selectedcomponent)) })
          :setTextProperties({ fontsize = EditorConfig.mapFontSize })
      row[2].handlers.onDropDownConfirmed = function(_, id) C.SetRegionDefinition(UixMenu.selectedcomponent, id) end

      ftable:addEmptyRow()

      local row = ftable:addRow(true, {})
      row[3]:createButton({}):setText("Remove", { halign = "center" }) -- TEMPTEXT Florian
      row[3].handlers.onClick = function()
        C.RemoveComponent(UixMenu.selectedcomponent); UixMenu.selectedcomponent = 0; UixMenu.refreshInfoFrame()
      end
    elseif C.IsComponentClass(UixMenu.selectedcomponent, "sector") then
      UixMenu.selectedComponentCluster = C.GetContextByClass(UixMenu.selectedcomponent, "cluster", false)
      UixMenu.selectedComponentOffset = C.GetPositionalOffset(UixMenu.selectedcomponent, 0)
      local selectedComponentClusterOffset = C.GetPositionalOffset(UixMenu.selectedComponentCluster, 0)
      local q, r = UixMenu.snapToClusterGrid(selectedComponentClusterOffset)
      UixMenu.selectedComponentClusterGridOffset = { q = q, r = r }

      local row = ftable:addRow(nil, {})
      row[1]:setColSpan(numcols):createText("Sector", Helper.subHeaderTextProperties) -- TEMPTEXT Florian
      UixMenu.addNameRows(ftable, UixMenu.selectedcomponent)

      UixMenu.addPositionalOffsetRow(ftable, "X", "x", "m")               -- TEMPTEXT Florian
      UixMenu.addPositionalOffsetRow(ftable, "Y", "y", "m")               -- TEMPTEXT Florian
      UixMenu.addPositionalOffsetRow(ftable, "Z", "z", "m")               -- TEMPTEXT Florian
      UixMenu.addPositionalOffsetRow(ftable, "Yaw", "yaw", "°", true)     -- TEMPTEXT Florian
      UixMenu.addPositionalOffsetRow(ftable, "Pitch", "pitch", "°", true) -- TEMPTEXT Florian
      UixMenu.addPositionalOffsetRow(ftable, "Roll", "roll", "°", true)   -- TEMPTEXT Florian

      ftable:addEmptyRow()

      local row = ftable:addRow(true, {})
      row[3]:createButton({ active = function() return not C.IsPlayerContext(UixMenu.selectedcomponent) end }):setText(
        "Remove", { halign = "center" }) -- TEMPTEXT Florian
      row[3].handlers.onClick = function()
        C.RemoveComponent(UixMenu.selectedcomponent); UixMenu.selectedcomponent = 0; UixMenu.refreshInfoFrame(); UixMenu.activatemap = true
      end

      local row = ftable:addRow(nil, {})
      row[1]:setColSpan(numcols):createText("Cluster", Helper.subHeaderTextProperties) -- TEMPTEXT Florian
      UixMenu.addNameRows(ftable, UixMenu.selectedComponentCluster)

      UixMenu.addClusterOffsetRow(ftable, "X", "q") -- TEMPTEXT Florian
      UixMenu.addClusterOffsetRow(ftable, "Z", "r") -- TEMPTEXT Florian

      local clusterbackground = ffi.string(C.GetClusterBackground(UixMenu.selectedComponentCluster))
      local clusterbackgroundoptions = {}
      local n = C.GetNumCatalogTemplates("celestialbody")
      if n > 0 then
        local buf = ffi.new("const char*[?]", n)
        n = C.GetCatalogTemplates(buf, n, "celestialbody")
        for i = 0, n - 1 do
          local template = ffi.string(buf[i])

          table.insert(clusterbackgroundoptions,
            { id = template, text = template, icon = "", displayremoveoption = false })
        end
      end
      table.sort(clusterbackgroundoptions, function(a, b) return a.text < b.text end)

      local row = ftable:addRow(true, {})
      row[1]:createText("Cluster Background (not for hardcoded cluster):") -- TEMPTEXT Florian
      row[2]:setColSpan(2):createDropDown(clusterbackgroundoptions,
        { height = Helper.standardTextHeight, startOption = clusterbackground }):setTextProperties({
        fontsize = EditorConfig
            .mapFontSize
      })
      row[2].handlers.onDropDownConfirmed = function(_, id)
        return C.SetClusterBackground(UixMenu.selectedComponentCluster,
          id)
      end ]]

      ftable:addEmptyRow()

      local row = ftable:addRow(true, {})
      row[2]:setColSpan(2):createButton({
        active = function()
          return C.GetNumSectors(UixMenu.selectedComponentCluster) <
              3
        end
      })
          :setText("Add Sector", { halign = "center" }) -- TEMPTEXT Florian
      row[2].handlers.onClick = function() return UixMenu.buttonAddSector(UixMenu.selectedComponentCluster) end

      ftable:addEmptyRow()

      local row = ftable:addRow(true, {})
      row[3]:createButton({ active = function() return not C.IsPlayerContext(UixMenu.selectedComponentCluster) end })
          :setText("Remove", { halign = "center" }) -- TEMPTEXT Florian
      row[3].handlers.onClick = function()
        C.RemoveComponent(UixMenu.selectedComponentCluster); UixMenu.selectedcomponent = 0; UixMenu.refreshInfoFrame(); UixMenu.activatemap = true
      end
    elseif C.IsComponentClass(UixMenu.selectedcomponent, "highway") then
      local row = ftable:addRow(nil, {})
      row[1]:setColSpan(numcols):createText("Highway", Helper.subHeaderTextProperties) -- TEMPTEXT Florian

      UixMenu.getSpline()
      for i, point in ipairs(UixMenu.splinepoints) do
        local row = ftable:addRow(true, {})
        local name = "Point " .. i -- TEMPTEXT Florian
        if i == 1 then
          name = "Start Point"     -- TEMPTEXT Florian
        elseif i == #UixMenu.splinepoints then
          name = "End Point"       -- TEMPTEXT Florian
        end
        row[1]:createText(name)
        if i ~= #UixMenu.splinepoints then
          row[2]:createButton({}):setText("Add Point", { halign = "center" }) -- TEMPTEXT Florian
          row[2].handlers.onClick = function() UixMenu.buttonAddSplinePoint(i) end
        end
        if (i ~= 1) and (i ~= #UixMenu.splinepoints) then
          row[3]:createButton({}):setText("Remove Point", { halign = "center" }) -- TEMPTEXT Florian
          row[3].handlers.onClick = function()
            UixMenu.getSpline(); table.remove(UixMenu.splinepoints, i); UixMenu.updateSpline()
          end
        end
      end

      ftable:addEmptyRow()

      local row = ftable:addRow(true, {})
      row[3]:createButton({}):setText("Remove", { halign = "center" }) -- TEMPTEXT Florian
      row[3].handlers.onClick = function()
        C.RemoveComponent(UixMenu.selectedcomponent); UixMenu.selectedcomponent = 0; UixMenu.refreshInfoFrame()
      end
    end
  end
end

function UixMenu.buttonAddSplinePoint(i)
  UixMenu.getSpline()

  local offset = {}
  offset.x = (UixMenu.splinepoints[i].offset.x + UixMenu.splinepoints[i + 1].offset.x) / 2
  offset.y = (UixMenu.splinepoints[i].offset.y + UixMenu.splinepoints[i + 1].offset.y) / 2
  offset.z = (UixMenu.splinepoints[i].offset.z + UixMenu.splinepoints[i + 1].offset.z) / 2

  local tangent = {}
  tangent.x = (UixMenu.splinepoints[i].tangent.x + UixMenu.splinepoints[i + 1].tangent.x) / 2
  tangent.y = (UixMenu.splinepoints[i].tangent.y + UixMenu.splinepoints[i + 1].tangent.y) / 2
  tangent.z = (UixMenu.splinepoints[i].tangent.z + UixMenu.splinepoints[i + 1].tangent.z) / 2

  local weight = (UixMenu.splinepoints[i].weight + UixMenu.splinepoints[i + 1].weight) / 2
  local inlength = (UixMenu.splinepoints[i].inlength + UixMenu.splinepoints[i + 1].inlength) / 2
  local outlength = (UixMenu.splinepoints[i].outlength + UixMenu.splinepoints[i + 1].outlength) / 2

  table.insert(UixMenu.splinepoints, i + 1,
    { offset = offset, tangent = tangent, weight = weight, inlength = inlength, outlength = outlength })

  UixMenu.updateSpline()
end

function UixMenu.getSpline()
  UixMenu.splinepoints = {}
  local n = C.GetNumHighwaySplinePoints(UixMenu.selectedcomponent)
  local buf = ffi.new("SplineData[?]", n)
  n = C.GetHighwaySplinePoints(buf, n, UixMenu.selectedcomponent)
  for i = 0, n - 1 do
    local offset = {}
    offset.x = buf[i].offset.x
    offset.y = buf[i].offset.y
    offset.z = buf[i].offset.z

    local tangent = {}
    tangent.x = buf[i].tangent.x
    tangent.y = buf[i].tangent.y
    tangent.z = buf[i].tangent.z

    table.insert(UixMenu.splinepoints,
      {
        offset = offset,
        tangent = tangent,
        weight = buf[i].weight,
        inlength = buf[i].inlength,
        outlength = buf[i]
            .outlength
      })
  end
end

function UixMenu.updateSpline()
  local n = #UixMenu.splinepoints
  local splinedata = ffi.new("SplineData[?]", n)
  for i, point in ipairs(UixMenu.splinepoints) do
    splinedata[i - 1].offset = point.offset
    splinedata[i - 1].tangent = point.tangent
    splinedata[i - 1].weight = point.weight
    splinedata[i - 1].inlength = point.inlength
    splinedata[i - 1].outlength = point.outlength
  end
  C.ReplaceHighwaySpline(UixMenu.selectedcomponent, splinedata, n, UixMenu.holomap)
  UixMenu.refreshInfoFrame();
end

function UixMenu.buttonAddSector(cluster)
  local numsectors = C.GetNumSectors(cluster)

  local offset = ffi.new("UIPosRot")
  offset.x = numsectors * EditorConfig.clusterGridEdgeLength
  offset.y = 0
  offset.z = numsectors * EditorConfig.clusterGridEdgeLength

  C.AddSector(cluster, "editor_cluster_001_sector_001_macro", offset)

  UixMenu.activatemap = true
  -- todo: add sector as known to player
  --menu.revealmap = getElapsedTime()
  AddUITriggeredEvent("CheatMenu", "full_reveal")
end

function UixMenu.addObjectOffsetRow(ftable, name, coord, suffix, converttodeg)
  local row = ftable:addRow(true, {})
  row[1]:setColSpan(2):createText(name .. ":")
  if converttodeg then
    UixMenu.selectedComponentOffset[coord] = UixMenu.selectedComponentOffset[coord] * 180 / math.pi
  end
  local editbox = row[3]:createEditBox({ height = Helper.standardTextHeight }):setText(Helper.round(
    UixMenu.selectedComponentOffset[coord], 2) .. suffix)
  row[3].handlers.onEditBoxActivated = function()
    C.SetEditBoxText(editbox.id,
      tostring(Helper.round(UixMenu.selectedComponentOffset[coord], 2)))
  end
  row[3].handlers.onTextChanged = function(_, text, textchanged)
    if text ~= "" then UixMenu.selectedComponentOffset[coord] = tonumber(text) end
    C.SetObjectSectorPos(UixMenu.selectedcomponent, UixMenu.selectedComponentSector, UixMenu.selectedComponentOffset)
  end
  row[3].handlers.onEditBoxDeactivated = function()
    C.SetEditBoxText(editbox.id,
      Helper.round(UixMenu.selectedComponentOffset[coord], 2) .. suffix)
  end
end

function UixMenu.addPositionalOffsetRow(ftable, name, coord, suffix, converttodeg)
  local row = ftable:addRow(true, {})
  row[1]:setColSpan(2):createText(name .. ":")
  if converttodeg then
    UixMenu.selectedComponentOffset[coord] = UixMenu.selectedComponentOffset[coord] * 180 / math.pi
  end
  local editbox = row[3]:createEditBox({ height = Helper.standardTextHeight }):setText(Helper.round(
    UixMenu.selectedComponentOffset[coord], 2) .. suffix)
  row[3].handlers.onEditBoxActivated = function()
    C.SetEditBoxText(editbox.id,
      tostring(Helper.round(UixMenu.selectedComponentOffset[coord], 2)))
  end
  row[3].handlers.onTextChanged = function(_, text, textchanged)
    if text ~= "" then UixMenu.selectedComponentOffset[coord] = tonumber(text) end
    C.SetPositionalOffset(UixMenu.selectedcomponent, UixMenu.selectedComponentOffset)
  end
  row[3].handlers.onEditBoxDeactivated = function()
    C.SetEditBoxText(editbox.id,
      Helper.round(UixMenu.selectedComponentOffset[coord], 2) .. suffix)
  end
end

function UixMenu.addClusterOffsetRow(ftable, name, coord)
  local row = ftable:addRow(true, {})
  row[1]:setColSpan(2):createText(name .. ":")
  local editbox = row[3]:createEditBox({ height = Helper.standardTextHeight }):setText(Helper.round(UixMenu
    .selectedComponentClusterGridOffset[coord]))
  row[3].handlers.onTextChanged = UixMenu.editboxClusterCoord
end

function UixMenu.editboxClusterCoord(_, text, coord)
  if text ~= "" then
    UixMenu.selectedComponentClusterGridOffset[coord] = tonumber(text)
  end
  local offset = ffi.new("UIPosRot")
  offset.x, offset.z = UixMenu.convertClusterGridToCoord(UixMenu.selectedComponentClusterGridOffset.q,
    UixMenu.selectedComponentClusterGridOffset.r)
  C.SetPositionalOffset(UixMenu.selectedComponentCluster, offset)
end

function UixMenu.addNameRows(ftable, component)
  local luacomponent = ConvertStringToLuaID(tostring(component))
  local name, rawname, description, rawdescription = GetComponentData(luacomponent, "name", "rawname", "description",
    "rawdescription")

  local row = ftable:addRow(nil, {})
  row[1]:createText("Name:") -- TEMPTEXT Florian
  row[2]:setColSpan(2):createText(name)

  local row = ftable:addRow(true, {})
  row[2]:setColSpan(2):createEditBox({ height = Helper.standardTextHeight }):setText(rawname)
  row[2].handlers.onEditBoxDeactivated = function(_, text, textchanged)
    SetComponentName(luacomponent, text); UixMenu.refreshInfoFrame()
  end

  ftable:addEmptyRow()

  local row = ftable:addRow(nil, {})
  row[1]:createText("Description:") -- TEMPTEXT Florian
  row[2]:setColSpan(2):createText(description)

  local row = ftable:addRow(true, {})
  row[2]:setColSpan(2):createEditBox({ height = Helper.standardTextHeight }):setText(rawdescription)
  row[2].handlers.onEditBoxDeactivated = function(_, text, textchanged)
    C.SetComponentDescription(component, text); UixMenu.refreshInfoFrame()
  end

  ftable:addEmptyRow()
end

function UixMenu.createExportTable(frame)
  local width = 500

  local numcols = 3
  local ftable = frame:addTable(numcols,
    { tabOrder = 3, width = width, x = Helper.viewWidth - width - Helper.frameBorder, y = Helper.frameBorder })

  local row = ftable:addRow(nil, { fixed = true })
  row[1]:setColSpan(numcols):createText("Add Cluster", Helper.headerRowCenteredProperties) -- TEMPTEXT Florian

  local row = ftable:addRow(true, { fixed = true })
  row[1]:setColSpan(numcols):createText("Ctrl+RMB into the void to add a cluster at that position.", { wordwrap = true }) -- TEMPTEXT Florian

  -- export disabled in public version
  --[[   ftable:addEmptyRow()

  local row = ftable:addRow(nil, { fixed = true })
  row[1]:setColSpan(numcols):createText("Export Map", Helper.headerRowCenteredProperties) -- TEMPTEXT Florian

  local ismaster = C.IsMasterVersion()
  local ischeat = true
  local extensionoptions = {}

  if not ismaster then
    table.insert(extensionoptions, { id = "basegame", text = "Base Game", icon = "", displayremoveoption = false }) -- TEMPTEXT Florian
  end

  local isSelectedExtensionPersonal = false
  local extensions = GetExtensionList()
  for _, extension in ipairs(extensions) do
    if extension.enabled and ((not ismaster) or (not extension.egosoftextension)) and (ischeat or extension.personal) then
      if UixMenu.exportExtension == "" then
        UixMenu.exportExtension = extension.id
      end
      table.insert(extensionoptions,
        { id = extension.id, text = extension.name .. (extension.personal and " (Personal)" or ""), icon = "", displayremoveoption = false }) -- TEMPTEXT Florian
    end
    if UixMenu.exportExtension == extension.id then
      isSelectedExtensionPersonal = extension.personal
    end
  end

  if #extensionoptions > 1 then
    local row = ftable:addRow(true, { fixed = true })
    row[1]:createText("Extension:") -- TEMPTEXT Florian
    row[2]:setColSpan(2):createDropDown(extensionoptions,
      { height = Helper.standardTextHeight, startOption = UixMenu.exportExtension }):setTextProperties({
      fontsize = EditorConfig
          .mapFontSize
    })
    row[2].handlers.onDropDownConfirmed = function(_, id)
      UixMenu.exportExtension = id; UixMenu.refreshInfoFrame()
    end
  end

  local row = ftable:addRow(true, { fixed = true })
  if isSelectedExtensionPersonal then
    row[1]:setColSpan(numcols):createText(
      "The map will be saved as '*_galaxy_macro.xml' in '$extensionfolder/maps' sub-folder of your personal X4 folder.\n\nThis file will contain all cluster, sector and zone macros of this map, each starting with the prefix '*_'.\n\nMake sure to add a macro index entry in the $extensionfolder to reference the exported map, e.g. '<entry name=\"extensionmap_*\" value=\"maps\\extensionmap_*\" />'",
      { wordwrap = true }) -- TEMPTEXT Florian
  else
    if UixMenu.exportExtension == "basegame" then
      row[1]:setColSpan(numcols):createText(
        "The map will be saved as 'basegame_map_*_galaxy_macro.xml' in 'maps'.\n\nThis file will contain all cluster, sector and zone macros of this map, each starting with the prefix 'basegame_map_*_'.",
        { wordwrap = true }) -- TEMPTEXT Florian
    else
      row[1]:setColSpan(numcols):createText(
        "The map will be saved as '*_galaxy_macro.xml' in '$extensionfolder/maps'.\n\nThis file will contain all cluster, sector and zone macros of this map, each starting with the prefix '*_'.\n\nMake sure to add a macro index entry in the $extensionfolder to reference the exported map, e.g. '<entry name=\"extensionmap_*\" value=\"maps\\extensionmap_*\" />'",
        { wordwrap = true }) -- TEMPTEXT Florian
    end
  end

  local row = ftable:addRow(true, { fixed = true })
  row[1]:setColSpan(numcols):createEditBox({ height = Helper.standardTextHeight, defaultText = "Enter map name here" })
      :setText(UixMenu.mapname) -- TEMPTEXT Florian
  row[1].handlers.onTextChanged = function(_, text, textchanged) UixMenu.mapname = text end

  local row = ftable:addRow(true, { fixed = true })
  row[3]:createButton({ active = function() return (UixMenu.mapname ~= "") and (UixMenu.exportExtension ~= "") end })
      :setText(
        "Export", { halign = "center" }) -- TEMPTEXT Florian
  row[3].handlers.onClick = function()
    -- todo: export map without using ExportMap?
    local filename = string.gsub(UixMenu.mapname, "[^%w_%-%() ]", "_"); return C.ExportMap(filename,
      (UixMenu.exportExtension ~= "basegame") and UixMenu.exportExtension or "", isSelectedExtensionPersonal)
  end ]]

  ftable.properties.y = Helper.viewHeight - ftable:getFullHeight() - ftable.properties.y
end

function UixMenu.createInfoFrame2()
  UixMenu.createInfoFrame2Running = true
  -- remove old data
  Helper.removeAllWidgetScripts(UixMenu, EditorConfig.infoFrame2Layer)

  UixMenu.infoFrame2 = Helper.createFrameHandle(UixMenu, {
    layer = EditorConfig.infoFrame2Layer,
    standardButtons = {},
    width = Helper.viewWidth,
    height = Helper.viewHeight,
    x = 0,
    y = 0,
  })

  if UixMenu.showMacroSuggestions then
    UixMenu.createMacroSearchTable(UixMenu.infoFrame2)
  end

  UixMenu.infoFrame2:display()
end

function UixMenu.refreshInfoFrame2()
  if not UixMenu.createInfoFrame2Running then
    UixMenu.createInfoFrame2()
  end
end

function UixMenu.createMacroSearchTable(frame)
  local width = 500
  local numcols = 3

  local ftable = frame:addTable(numcols,
    {
      tabOrder = 11,
      width = width,
      x = Helper.frameBorder + UixMenu.sideBarWidth + 2 * Helper.borderSize + width +
          Helper.borderSize,
      y = Helper.frameBorder
    })

  local row = ftable:addRow(nil, { fixed = true })
  row[1]:setColSpan(numcols):createText("Suggested macros:", Helper.subHeaderTextProperties) -- TEMPTEXT Florian

  if UixMenu.macrosearch ~= "" then
    local n = C.GetNumMacrosStartingWith(UixMenu.macrosearch)
    if n > 0 then
      local buf = ffi.new("const char*[?]", n)
      n = C.GetMacrosStartingWith(buf, n, UixMenu.macrosearch)
      for i = 0, n - 1 do
        local macro = ffi.string(buf[i])

        local row = ftable:addRow(true, {})
        row[1]:setColSpan(numcols):createButton({}):setText((GetMacroData(macro, "name") or "") .. " (" .. macro .. ")")
        row[1].handlers.onClick = function()
          UixMenu.macrosearch = macro; UixMenu.showMacroSuggestions = false; UixMenu.refreshInfoFrame(); UixMenu
              .refreshInfoFrame2()
        end
      end
    end
  end
end

function UixMenu.closeContextMenu(dueToClose)
  if Helper.closeInteractMenu() then
    return true
  end
  if UixMenu.contextMenuMode then
    -- REMOVE this block once the mouse out/over event order is correct -> This should be unnessecary due to the global tablemouseout event reseting the picking
    if UixMenu.currentMouseOverTable and (
          (UixMenu.contextMenuMode == "boardingcontext")
          or (UixMenu.contextMenuMode == "dropwares")
        ) then
      UixMenu.picking = true
      UixMenu.currentMouseOverTable = nil
    end
    -- END
    UixMenu.contextFrame = nil
    Helper.clearFrame(UixMenu, EditorConfig.contextFrameLayer)
    UixMenu.contextMenuData = {}
    UixMenu.contextMenuMode = nil
    return true
  end
  return false
end

-- update
UixMenu.updateInterval = 0.01
function UixMenu.onUpdate()
  local curtime = getElapsedTime()
  if UixMenu.mainFrame then
    UixMenu.mainFrame:update()
  end
  if UixMenu.infoFrame then
    UixMenu.infoFrame:update()
  end
  if UixMenu.infoFrame2 then
    UixMenu.infoFrame2:update()
  end

  if UixMenu.map and UixMenu.holomap ~= 0 then
    local x, y = GetRenderTargetMousePosition(UixMenu.map)
    C.SetMapRelativeMousePosition(UixMenu.holomap, (x and y) ~= nil, x or 0, y or 0)
  end

  if UixMenu.activatemap then
    -- pass relative screenspace of the holomap rendertarget to the holomap (value range = -1 .. 1)
    local renderX0, renderX1, renderY0, renderY1 = Helper.getRelativeRenderTargetSize(UixMenu,
      EditorConfig.mainFrameLayer,
      UixMenu.map)
    local rendertargetTexture = GetRenderTargetTexture(UixMenu.map)
    if rendertargetTexture then
      local mapstate
      if UixMenu.holomap ~= 0 then
        mapstate = ffi.new("HoloMapState")
        C.GetMapState(UixMenu.holomap, mapstate)
      end

      UixMenu.holomap = C.AddHoloMap(rendertargetTexture, renderX0, renderX1, renderY0, renderY1,
        UixMenu.rendertargetWidth / UixMenu.rendertargetHeight, 1)
      if UixMenu.holomap ~= 0 then
        C.ClearSelectedMapComponents(UixMenu.holomap)
        C.ShowEditorMap(UixMenu.holomap, C.GetContextByClass(C.GetPlayerID(), "sector", false))

        if mapstate then
          C.SetMapState(UixMenu.holomap, mapstate)
        end
      end

      UixMenu.activatemap = false
    end
  end

  if not UixMenu.refreshed then
    if UixMenu.holomap and (UixMenu.holomap ~= 0) then
      if UixMenu.picking ~= UixMenu.pickstate then
        UixMenu.pickstate = UixMenu.picking
        C.SetMapPicking(UixMenu.holomap, UixMenu.pickstate)
      end
    end
  end
  UixMenu.refreshed = nil

  if UixMenu.panningmap and UixMenu.panningmap.isclick then
    local offset = table.pack(GetLocalMousePosition())
    if (UixMenu.leftdown.time + 0.5 < curtime) or Helper.comparePositions(UixMenu.leftdown.position, offset, 5) then
      UixMenu.panningmap.isclick = false
    end
  end

  if UixMenu.leftdown then
    if not UixMenu.leftdown.wasmoved then
      local offset = table.pack(GetLocalMousePosition())
      if Helper.comparePositions(UixMenu.leftdown.position, offset, 5) then
        UixMenu.leftdown.wasmoved = true
      end
    end
    if UixMenu.leftdown.wasmoved and UixMenu.leftdown.time + 0.1 < curtime and not C.IsComponentClass(C.GetPickedMapComponent(UixMenu.holomap), "object") then
      local currentmousepos = table.pack(GetLocalMousePosition())
      if UixMenu.panningmap then
        UixMenu.leftdown.dynpos = currentmousepos
      end
    end
  end

  if UixMenu.rightdown then
    if not UixMenu.rightdown.wasmoved then
      local offset = table.pack(GetLocalMousePosition())
      if Helper.comparePositions(UixMenu.rightdown.position, offset, 5) then
        UixMenu.rightdown.wasmoved = true
      end
    end
    if UixMenu.rightdown.wasmoved and UixMenu.rightdown.time + 0.1 < curtime and not C.IsComponentClass(C.GetPickedMapComponent(UixMenu.holomap), "object") then
      local currentmousepos = table.pack(GetLocalMousePosition())
      if UixMenu.rotatingmap then
        UixMenu.rightdown.dynpos = currentmousepos
      end
    end
  end

  if UixMenu.refreshIF and (UixMenu.refreshIF < curtime) then
    UixMenu.refreshInfoFrame()
    UixMenu.refreshIF = nil
  end
  if UixMenu.refreshIF2 and (UixMenu.refreshIF2 < curtime) then
    UixMenu.refreshInfoFrame2()
    UixMenu.refreshIF2 = nil
  end

  --[[ if menu.revealmap and (menu.revealmap < curtime) then
    C.RevealMap()
  end ]]
end

function UixMenu.viewCreated(layer, ...)
  if layer == EditorConfig.mainFrameLayer then
    UixMenu.map, UixMenu.sideBar = ...

    if UixMenu.activatemap == nil then
      UixMenu.activatemap = true
    end

    UixMenu.createMainFrameRunning = false
  elseif layer == EditorConfig.infoFrameLayer then
    UixMenu.createInfoFrameRunning = false
  elseif layer == EditorConfig.infoFrame2Layer then
    UixMenu.createInfoFrame2Running = false
  end
end

-- close menu handler
function UixMenu.onCloseElement(dueToClose, layer)
  if (layer == nil) or (layer == EditorConfig.mainFrameLayer) or (layer == EditorConfig.infoFrameLayer) or (layer == EditorConfig.infoFrame2Layer) then
    Helper.closeMenu(UixMenu, dueToClose)
    UixMenu.cleanup()
  elseif layer == EditorConfig.contextFrameLayer then
    Helper.clearFrame(UixMenu, layer)
  end
end

-- table mouse input helper
function UixMenu.onTableMouseOut(uitable, row)
  if UixMenu.currentMouseOverTable and (uitable == UixMenu.currentMouseOverTable) then
    UixMenu.currentMouseOverTable = nil
    if UixMenu.holomap ~= 0 then
      UixMenu.picking = true
    end
  end
end

function UixMenu.onTableMouseOver(uitable, row)
  UixMenu.currentMouseOverTable = uitable
  if UixMenu.holomap ~= 0 then
    UixMenu.picking = false
  end
end

-- rendertarget selections
function UixMenu.onRenderTargetSelect(modified)
  local offset = table.pack(GetLocalMousePosition())
  -- Check if the mouse button was down less than 0.5 seconds and the mouse was moved more than a distance of 5px
  if (not UixMenu.leftdown) or ((UixMenu.leftdown.time + 0.5 > getElapsedTime()) and not Helper.comparePositions(UixMenu.leftdown.position, offset, 5)) then
    local newselectedcomponent = 0

    local pickedcomponent = C.GetPickedMapComponent(UixMenu.holomap)
    local pickedcomponentclass = ffi.string(C.GetComponentClass(pickedcomponent))
    if pickedcomponent ~= 0 then
      newselectedcomponent = pickedcomponent
    end

    if newselectedcomponent ~= UixMenu.selectedcomponent then
      UixMenu.selectedcomponent = newselectedcomponent
      if UixMenu.selectedcomponent ~= 0 then
        if C.IsComponentClass(UixMenu.selectedcomponent, "object") then
          UixMenu.macrosearch = GetComponentData(ConvertStringToLuaID(tostring(UixMenu.selectedcomponent)), "macro")
        end
        C.SetSelectedMapComponent(UixMenu.holomap, newselectedcomponent)

        if UixMenu.gateconnection and UixMenu.gateconnection ~= UixMenu.selectedcomponent then
          if C.IsComponentClass(UixMenu.selectedcomponent, "gate") then
            C.AddGateConnection(UixMenu.gateconnection, UixMenu.selectedcomponent)
            UixMenu.gateconnection = nil
          end
        end
      else
        C.ClearSelectedMapComponents(UixMenu.holomap)
      end
      UixMenu.refreshInfoFrame()
    end
  end
  UixMenu.leftdown = nil
end

-- rendertarget doubleclick
function UixMenu.onRenderTargetDoubleClick(modified)
  local pickedcomponent = C.GetPickedMapComponent(UixMenu.holomap)
  if pickedcomponent ~= 0 then
    if C.IsComponentClass(pickedcomponent, "sector") then
      -- todo: find empty block?
    end
  end
end

-- rendertarget mouse input helper
function UixMenu.onRenderTargetMouseDown(modified)
  UixMenu.leftdown = {
    time = getElapsedTime(),
    position = table.pack(GetLocalMousePosition()),
    dynpos = table.pack(
      GetLocalMousePosition())
  }

  if modified == "shift" then
    C.StartMapBoxSelect(UixMenu.holomap, false)
  else
    C.StartPanMap(UixMenu.holomap)
    UixMenu.panningmap = { isclick = true }
    UixMenu.noupdate = true
  end
end

function UixMenu.onRenderTargetMouseUp(modified)
  if UixMenu.panningmap then
    C.StopPanMap(UixMenu.holomap)
    UixMenu.noupdate = false
    UixMenu.panningmap = nil
    UixMenu.refreshInfoFrame()
  else
    C.StopMapBoxSelect(UixMenu.holomap)
    local components = {}
    Helper.ffiVLA(components, "UniverseID", C.GetNumMapSelectedComponents, C.GetMapSelectedComponents, UixMenu.holomap)

    if #components > 0 then
      -- todo: find empty block?
    end
  end
end

function UixMenu.onRenderTargetRightMouseDown()
  UixMenu.closeContextMenu()
  UixMenu.rightdown = {
    time = getElapsedTime(),
    position = table.pack(GetLocalMousePosition()),
    dynpos = table.pack(
      GetLocalMousePosition())
  }

  C.StartRotateMap(UixMenu.holomap)
  UixMenu.rotatingmap = true
  UixMenu.noupdate = true
end

function UixMenu.onRenderTargetRightMouseUp(modified)
  local offset = table.pack(GetLocalMousePosition())

  -- Check if the mouse was moved more than a distance of 5px
  if UixMenu.rightdown and (not Helper.comparePositions(UixMenu.rightdown.position, offset, 5)) and (not UixMenu.rightdown.wasmoved) then
    local pickedcomponent = C.GetPickedMapComponent(UixMenu.holomap)

    local posrot = ffi.new("UIPosRot")
    local eclipticoffset = ffi.new("UIPosRot")
    local posrotcomponent = C.GetMapPositionOnEcliptic2(UixMenu.holomap, posrot, false, 0, eclipticoffset)

    if pickedcomponent ~= 0 then
      local convertedComponent = ConvertStringTo64Bit(tostring(pickedcomponent))
      if modified ~= "ctrl" then
        local missions = {}
        Helper.ffiVLA(missions, "MissionID", C.GetNumMapComponentMissions, C.GetMapComponentMissions, UixMenu.holomap,
          pickedcomponent)

        local playerships, otherobjects, playerdeployables = {}, {}, {}
        Helper.openInteractMenu(UixMenu,
          {
            component = pickedcomponent,
            offsetcomponent = posrotcomponent,
            offset = posrot,
            playerships = playerships,
            otherobjects =
                otherobjects,
            playerdeployables = playerdeployables,
            componentmissions = missions
          })
      else
        if UixMenu.spawnTableMode == "object" then
          if C.FindMacro(UixMenu.macrosearch) then
            if IsMacroClass(UixMenu.macrosearch, "object") then
              local object = C.SpawnObjectAtPos2(UixMenu.macrosearch, posrotcomponent, posrot, "player")
              if object ~= 0 then
                C.SetObjectForcedRadarVisible(object, true)
              end
            end
          end
        elseif UixMenu.spawnTableMode == "region" then
          if UixMenu.regiondefinition ~= "" then
            C.SpawnRegionAtPos(UixMenu.regiondefinition, posrotcomponent, posrot)
          end
        elseif UixMenu.spawnTableMode == "station" then
          if UixMenu.constructionplan ~= "" then
            local station = C.SpawnStationAtPos("station_gen_factory_base_01_macro", posrotcomponent, posrot,
              UixMenu.constructionplan, UixMenu.cpfaction)
            if station ~= 0 then
              C.SetObjectForcedRadarVisible(station, true)
              C.SetKnownTo(station, "player")
            end
          end
        elseif UixMenu.spawnTableMode == "highway" then
          C.SpawnLocalHighwayAtPos("editor_local_highway_macro", posrotcomponent, posrot)
        end
      end
    else
      if modified == "ctrl" then
        local offset = ffi.new("UIPosRot")
        -- Why is there a factor of 25???
        offset.x = posrot.x * 25
        offset.y = posrot.y * 25
        offset.z = posrot.z * 25
        -- snap to the hex grid
        local q, r = UixMenu.snapToClusterGrid(offset)
        offset.x, offset.z = UixMenu.convertClusterGridToCoord(q, r)
        C.AddCluster("editor_cluster_001_macro", offset)
        UixMenu.activatemap = true
        --todo: set cluster to known to player
        -- menu.revealmap = getElapsedTime()
        AddUITriggeredEvent("CheatMenu", "full_reveal")
      end
    end
  end
  UixMenu.rightdown = nil
  if UixMenu.rotatingmap then
    C.StopRotateMap(UixMenu.holomap)
    UixMenu.noupdate = false
    if UixMenu.sound_rotatemap and UixMenu.sound_rotatemap.sound then
      StopPlayingSound(UixMenu.sound_rotatemap.sound)
      UixMenu.sound_rotatemap = nil
    end
    UixMenu.rotatingmap = nil
    if UixMenu.infoTableMode == "objectlist" then
      UixMenu.refreshInfoFrame()
    end
  end
end

function UixMenu.snapToClusterGrid(offset)
  local l = EditorConfig.clusterGridEdgeLength

  -- convert to hex coordinates with r == y axis and q axis being 60° ccw from x axis
  local q = (2 * offset.x) / (3 * l)
  local r = (-offset.x + math.sqrt(3) * offset.z) / (3 * l)
  local s = -q - r

  -- snap to grid
  local roundQ = Helper.round(q)
  local roundR = Helper.round(r)
  local roundS = Helper.round(s)

  local q_diff = math.abs(roundQ - q)
  local r_diff = math.abs(roundR - r)
  local s_diff = math.abs(roundS - s)

  if q_diff > r_diff and q_diff > s_diff then
    roundQ = -roundR - roundS
  elseif r_diff > s_diff then
    roundR = -roundQ - roundS
  end

  -- Adjust to holomap hex display ( q axis == zig-zag x-axis)
  roundR = roundR + math.floor(roundQ / 2)

  return roundQ, roundR
end

function UixMenu.convertClusterGridToCoord(q, r)
  local l = EditorConfig.clusterGridEdgeLength

  local x = 3 * l * q / 2
  local y = math.sqrt(3) * l * (r + q / 2 - math.floor(Helper.round(q) / 2))

  return x, y
end

function UixMenu.onRenderTargetCombinedScrollDown(step)
  C.ZoomMap(UixMenu.holomap, step)
end

function UixMenu.onRenderTargetCombinedScrollUp(step)
  C.ZoomMap(UixMenu.holomap, -step)
end

function UixMenu.buttonToggleSpawnTable(spawntableparam)
  local oldidx, newidx
  local leftbar = EditorConfig.leftBar
  local count = 1
  for _, entry in ipairs(leftbar) do
    if (entry.condition == nil) or entry.condition() then
      if entry.mode then
        if type(entry.mode) == "table" then
          for _, mode in ipairs(entry) do
            if mode == UixMenu.spawnTableMode then
              oldidx = count
            end
            if mode == spawntableparam then
              newidx = count
            end
          end
        else
          if entry.mode == UixMenu.spawnTableMode then
            oldidx = count
          end
          if entry.mode == spawntableparam then
            newidx = count
          end
        end
      end
      count = count + 1
    end
    if oldidx and newidx then
      break
    end
  end

  local deactivate = UixMenu.spawnTableMode == spawntableparam

  if newidx then
    Helper.updateButtonColor(UixMenu.sideBar, newidx, 1, Color["row_background_blue"])
  end
  if oldidx then
    Helper.updateButtonColor(UixMenu.sideBar, oldidx, 1, Color["button_background_default"])
  end

  AddUITriggeredEvent(UixMenu.name, spawntableparam, UixMenu.spawnTableMode == spawntableparam and "off" or "on")
  if deactivate then
    PlaySound("ui_negative_back")
    UixMenu.spawnTableMode = nil
  else
    PlaySound("ui_positive_select")
    UixMenu.spawnTableMode = spawntableparam
  end

  UixMenu.refreshMainFrame()
  UixMenu.refreshInfoFrame()

  UixMenu.showMacroSuggestions = false;
  UixMenu.refreshInfoFrame2()
end

return ModLua.init()
