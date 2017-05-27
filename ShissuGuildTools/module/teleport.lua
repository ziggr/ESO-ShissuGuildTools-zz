-- Shissu GuildTools Module File                   
--------------------------------
-- File: teleport.lua
-- Version: v1.3.13
-- Last Update: 20.05.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!

local _lib = Shissu_SuiteManager._lib
local _SGT = Shissu_SuiteManager._lib["SGT"]
local cutStringAtLetter = _lib.cutStringAtLetter
local getWindowPosition = _SGT.getWindowPosition
local saveWindowPosition = _SGT.saveWindowPosition
local setDefaultColor = _SGT.setDefaultColor
local getString = _SGT.getString
 
local createScrollContainer = _SGT.createScrollContainer

local _globals = Shissu_SuiteManager._globals
local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]
local red = _globals["color"]["red"]
local yellow = _globals["color"]["yellow"]

local _addon = {}
_addon.Name	= "ShissuTeleporter"
_addon.Version = "1.3.13"
_addon.core = {}
_addon.fN = _SGT["title"]("Teleporter")

_addon.cache = {
  ["ImperialCity"] = nil,                                                                                                                        
  ["Cyrodiil"] = nil,                                                                                                                                                                                               
  ["ColdHarbour"] = nil,
  ["Craglore"] = nil,
}

_addon.settings = {
  ["position"] = {}
} 

local _list = {}
local _globalList = {}

_list.scrollItem = 1
_list.indexPool = nil
_list.list = nil

_list.playerSelected = nil
_list.zoneSelected = nil
_list.idSelected = nil
_list.gidSelected = nil
_list.what = nil

-- TELEPORTER CORE FUNCTIONS
function _addon.core.getGuildsZones()
  local playerZone = cutStringAtLetter(GetPlayerLocationName() , "^") 
  local searchTerm = SGT_Teleport_FilterText:GetText()  or ""
  local availableZones = {}
  
  --for mapId = 1, GetNumMaps(), 1 do
  --  local zoneName = GetMapInfo(mapId)
  --  d(mapId .. " ---- " .. zoneName)
  --end
  
  -- Gilde
  local ownName = GetDisplayName()   
  
  for guildId = 1, GetNumGuilds() do
    if #availableZones == GetNumMaps() - 2 then break end
    
    for memberId = 1, GetNumGuildMembers(guildId) do
      local _, _, memberZone, _, memberAlliance = GetGuildMemberCharacterInfo(guildId, memberId)
      local memberName, _, _ , memberStatus = GetGuildMemberInfo(guildId, memberId)
    
      if memberStatus ~= PLAYER_STATUS_OFFLINE then
        for mapId = 1, GetNumMaps(), 1 do
          local zoneName = GetMapInfo(mapId)
          local zoneExist = 0
          local zoneInsert = 0
          local playerInZone = 0
          
          zoneName = cutStringAtLetter(zoneName, "^")
          memberZone = cutStringAtLetter(memberZone, "^")
          
          if playerZone == zoneName then playerInZone = 1 end
          if ownName == memberName then playerInZone = 1 end
           
          -- Auch entfernen, da man nicht hin joinen kann per Teleport
          if zoneName == _addon.cache["ImperialCity"] then playerInZone = 1 end
          if zoneName == _addon.cache["Cyrodiil"] then playerInZone = 1 end
          
          -- Spieler in der Zone, dann ignorieren
          if playerInZone ~= 1 then
            -- Zonen die schon existieren ignorieren 
            for i = 1, #availableZones do
              if availableZones[i].zoneName == zoneName then
                zoneExist = 1
                break
              end
            end      
          end

          -- Zone erfüllt alle Bedingungen
          if zoneName == memberZone and zoneExist ~= 1 and playerInZone ~= 1 and (searchTerm == "" or string.find(zoneName, searchTerm) or string.find(memberName, searchTerm)) then
            table.insert(availableZones, {
              ["zoneName"] = cutStringAtLetter(zoneName, "^"),
              ["displayName"] = memberName,
              ["what"] = "guild",
            })
            break
          end
        end            
      end 
    end
  end 
  
  return availableZones
end

-- FREUNDE
function _addon.core.getFriendsZones()
  local searchTerm = SGT_Teleport_FilterText:GetText()  or ""
  local numFriends = GetNumFriends()
  local availableZones = {}
  
  for friendId = 1, numFriends do
    local _, _, zoneName = GetFriendCharacterInfo(friendId)
    local displayName, _, playerStatus = GetFriendInfo(friendId)
    
    if (playerStatus == 1 or playerStatus == 2 or playerStatus == 3) then
      if (searchTerm == "" or string.find(zoneName, searchTerm) or string.find(displayName, searchTerm)) then
        table.insert(availableZones, {
          ["zoneName"] = cutStringAtLetter(zoneName, "^"),
          ["displayName"] = displayName,
          ["what"] = "friend",
        })
      end
    end 
  end
   
  return availableZones
end

-- GRUPPE
function _addon.core.getGroupZones()
  local searchTerm = SGT_Teleport_FilterText:GetText()  or ""
  local availableZones = {}
  local availableCount = 1
  
  local numGroup = GetGroupSize()
  local ownName = string.lower(GetUnitName("player"))
  
  for i = 1, numGroup do
    local unitTag = GetGroupUnitTagByIndex(i)
    local unitName = GetUnitName(unitTag)
    
    if unitTag ~= nil and IsUnitOnline(unitTag) and string.lower(unitName) ~= ownName then
      local zoneName = GetUnitZone(unitTag)
      local displayName = GetUnitDisplayName(unitTag)   
         
      if (searchTerm == "" or string.find(zoneName, searchTerm) or string.find(displayName, searchTerm)) then        
        table.insert(availableZones, {
          ["zoneName"] = cutStringAtLetter(zoneName, "^"),
          ["displayName"] = displayName,
          ["what"] = "group",
        })         
      end
    end
  end
   
  return availableZones
end

function _addon.core.sortTable(list)
  if (list == nil) then return false end
  
  local list = list
  local numEntrys = #list
  local sortedTitle = {}
  local sortedData = {}

  for i = 1, numEntrys do
    table.insert(sortedTitle, i, list[i].zoneName .. "**shissu" .. i)
  end
  
  table.sort(sortedTitle)
  
  for i = 1, numEntrys do
    local length = string.len(sortedTitle[i])
    local number = string.sub(sortedTitle[i], string.find(sortedTitle[i], "**shissu"), length)
    
    number = string.gsub(number, "**shissu", "")
    number = string.gsub(number, " ", "")
    number = tonumber(number)
    
    sortedData[i] = {}
    sortedData[i].displayName = list[number].displayName
    sortedData[i].zoneName = list[number].zoneName
    sortedData[i].what = list[number].what
  end  

  return sortedData
end


-- Zufallsteleport zu irgendeinen Gildenmitglied
function _addon.core.rndTeleport()
  local data = _addon.core.getGuildsZones()
  local count = #data
  local rnd = math.random(0, count)  

  JumpToGuildMember(data[rnd].displayName) 
end


-- Einzelne Listen Einträge erstellen
function _list.createIndexButton(indexPool)
  local control = ZO_ObjectPool_CreateControl("SGT_Teleport_Index", indexPool, _list.list.scrollChild)
  local anchorBtn = _list.scrollItem == 1 and _list.list.scrollChild or indexPool:AcquireObject(_list.scrollItem-1)
  
  control:SetAnchor(TOPLEFT, anchorBtn, _list.scrollItem == 1 and TOPLEFT or BOTTOMLEFT)
  control:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  control:SetWidth(130)
  control:SetHandler("OnClicked", function(self)
    _list.playerSelected = self.displayName
    _list.zoneSelected = self.zone
    _list.idSelected = self.id
    _list.what = self.what
    _list.selected:SetHidden(false)
    _list.selected:ClearAnchors()
    _list.selected:SetAnchorFill(self)                         
  end)
  
  control:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, white .. self.displayName .. " (" .. blue .. self.zone .. white.. ")") end)
  control:SetHandler("OnMouseExit", function(self) ZO_Tooltips_HideTextTooltip() end)  

  _list.scrollItem = _list.scrollItem  + 1
  
  return control
end

-- Einzelne Listen Eintrag entfernen (verstecken)
function _list.removeIndexButton(control)
  control:SetHidden(true)
  control = nil
end

-- Liste füllen
function _list.FillScrollList()
  local allEntrys = 0 
  
  -- Gruppe
  local groupList = _addon.core.getGroupZones()
  local sortedData = _addon.core.sortTable(groupList) 
  local oldEntrys = 0
  
  if (sortedData ~= false) then
    local numEntrys = #sortedData
    allEntrys = numEntrys
    
    for i = 1, numEntrys do
      local control = _list.indexPool:AcquireObject(i)
      
      control.what = sortedData[i].what
      control.displayName = sortedData[i].displayName
      control.zone = sortedData[i].zoneName
      control:SetText(red .. sortedData[i].displayName)
      
      control:SetHidden(false)
    end  
  end 
  
  -- Gilde
  local guildList = _addon.core.getGuildsZones()
  sortedData = _addon.core.sortTable(guildList)
  
  if (sortedData ~= false) then
    oldEntrys = numEntrys or 0 
    numEntrys = #sortedData
    allEntrys = allEntrys + numEntrys
  
    for i = oldEntrys + 1, oldEntrys + numEntrys do
      local control = _list.indexPool:AcquireObject(i)
      
      control.displayName = sortedData[i - oldEntrys].displayName
      control.zone = sortedData[i - oldEntrys].zoneName
      control.what = sortedData[i - oldEntrys].what
      control:SetText(white .. sortedData[i - oldEntrys].zoneName)
      
      control:SetHidden(false)
    end
  end
  
  -- Freunde
  local friendList = _addon.core.getFriendsZones()
  sortedData = _addon.core.sortTable(friendList)
  
  if (sortedData ~= false) then
    oldEntrys = numEntrys or 0 
    numEntrys = #sortedData
    allEntrys = allEntrys + numEntrys
    
    for i = oldEntrys + 1, oldEntrys + numEntrys do
      local control = _list.indexPool:AcquireObject(i)
      
      control.displayName = sortedData[i - oldEntrys].displayName
      control.zone = sortedData[i - oldEntrys].zoneName
      control.what = sortedData[i - oldEntrys].what
      control:SetText(yellow .. sortedData[i - oldEntrys].displayName)
      
      control:SetHidden(false)
    end  
  end
  
  local activePages = _list.indexPool:GetActiveObjectCount()
  if activePages > allEntrys then
    for i = allEntrys + 1, activePages do _list.indexPool:ReleaseObject(i) end
  end  
end        

function _addon.core.toPlayer()
  local what = _list.what
  local player = _list.playerSelected
  local zone = _list.zoneSelected
  
  _list.FillScrollList()
  
  if what ~= nil then
    if what == "friend" or what == "group" then
      JumpToGuildMember(player)  
    else
      local list = _addon.core.getGuildsZones()
      
      for i=1, #list do
        local data = list[i]
        
        if zone == data.zoneName then
          JumpToGuildMember(data.displayName)
          break 
        end
      end
    end
  end
    
end

-- * Initialisierung
function _addon.core.initialized()
  shissuGT = shissuGT or {}

  shissuGT[_addon.Name] = shissuGT[_addon.Name] or _addon.settings
  _addon.settings = shissuGT[_addon.Name]
  
  Shissu_SuiteManager._commands[_addon.Name] = {} 
  table.insert(Shissu_SuiteManager._commands[_addon.Name], { "rndteleport" , _addon.core.rndTeleport })
  table.insert(Shissu_SuiteManager._commands[_addon.Name], { "teleport" , function() SGT_Teleport:SetHidden(false) end })
  
  _addon.cache.ImperialCity = cutStringAtLetter(GetMapInfo(26), "^")
  _addon.cache.Cyrodiil = cutStringAtLetter(GetMapInfo(14), "^")
  _addon.cache.ColdHarbour = cutStringAtLetter(GetMapInfo(23), "^")
  _addon.cache.Craglore = cutStringAtLetter(GetMapInfo(25), "^")

  SGT_Teleport_Version:SetText(_addon.fN .. " " .. _addon.Version)

  SGT_Teleport_ButtonTeleport = _SGT.createFlatButton("SGT_Teleport_ButtonTeleport", SGT_Teleport, {160, 60}, {160, 30}, white .. getString(ShissuTeleporter_tele), TOPLEFT)   
  SGT_Teleport_ButtonRandom = _SGT.createFlatButton("SGT_Teleport_ButtonRandom", SGT_Teleport_ButtonTeleport, {0, 40}, {160, 30}, white .. getString(ShissuTeleporter_rnd))    
  SGT_Teleport_ButtonGrp = _SGT.createFlatButton("SGT_Teleport_ButtonGrp", SGT_Teleport_ButtonRandom, {0, 50}, {160, 30}, getString(ShissuTeleporter_grp), nil, {1, 0.48627451062202, 0.56078433990479})    
  SGT_Teleport_ButtonHouse = _SGT.createFlatButton("SGT_Teleport_ButtonHouse", SGT_Teleport_ButtonGrp, {0, 50}, {160, 30}, getString(ShissuTeleporter_house), nil, {1, 0.96078431606293, 0.50196081399918})     
  SGT_Teleport_ButtonRefresh = _SGT.createFlatButton("SGT_Teleport_ButtonRefresh", SGT_Teleport_ButtonHouse, {0, 50}, {160, 30}, getString(ShissuTeleporter_refresh))    

  SGT_Teleport_Legends:ClearAnchors()
  SGT_Teleport_Legends:SetAnchor(BOTTOMLEFT, SGT_Teleport, BOTTOMLEFT, 170, -100)

  -- Scrollcontainer + UI
  _list.indexPool = ZO_ObjectPool:New(_list.createIndexButton, _list.removeIndexButton)  
  _list.list = createScrollContainer("SGT_Teleport_List", 140, SGT_Teleport, SGT_Teleport_Filter, 10, 10, -10)
  
  _list.selected = WINDOW_MANAGER:CreateControl(nil, _list.list.scrollChild, CT_TEXTURE)
  _list.selected:SetTexture("EsoUI\\Art\\Buttons\\generic_highlight.dds")
  _list.selected:SetHidden(true)

  SGT_Teleport_FilterText:SetHandler("OnTextChanged", function()  _list.FillScrollList() end) 
  SGT_Teleport_FilterText:SetDrawLayer(1)
  
  _SGT.createFlatWindow(
    "SGT_Teleport",
    SGT_Teleport,  
    {330, 500}, 
    function() SGT_Teleport:SetHidden(true) end,
    "Teleporter"
  ) 
  
  SGT_Teleport_Position:ClearAnchors()
  SGT_Teleport_Position:SetAnchor(TOPLEFT, SGT_Teleport_TitleLine, TOPLEFT, 2, 5)
  SGT_Teleport_FilterText:SetDrawLayer(1)

  SGT_Teleport_Legends:SetText(
    white .. getString(ShissuTeleporter_legends1) .. "\n" ..
    "- " .. yellow .. getString(ShissuTeleporter_legends2) .. white .. "\n" ..
    "- " .. red .. getString(ShissuTeleporter_legends3)
  )
  
	EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_PLAYER_ACTIVATED, function() 
    local zoneName = GetUnitZone('player')
      
    if (zoneName ~= nil) then
      zoneName = cutStringAtLetter(zoneName, "^")
      SGT_Teleport_Position:SetText(blue .. zoneName)
    end
  end) 
      
  local zoneName = GetUnitZone('player')
    
  if (zoneName ~= nil) then
    zoneName = cutStringAtLetter(zoneName, "^")                                                     
    SGT_Teleport_Position:SetText(blue .. zoneName)
  end
  
  saveWindowPosition(SGT_Teleport, _addon.settings["position"])
  getWindowPosition(SGT_Teleport, _addon.settings["position"])

  SGT_Teleport_ButtonRefresh:SetHandler("OnMouseUp", function() _list.FillScrollList() end)
  SGT_Teleport_ButtonTeleport:SetHandler("OnMouseUp", _addon.core.toPlayer)
  SGT_Teleport_ButtonRandom:SetHandler("OnMouseUp", function(self) _addon.core.rndTeleport() end) 
  SGT_Teleport_ButtonGrp:SetHandler("OnMouseUp", function(self) JumpToGroupLeader() end) 
  SGT_Teleport_ButtonHouse:SetHandler("OnMouseUp", function(self) 
    local houseId = GetHousingPrimaryHouse()
    
    if (houseId == nil) then return end
		  RequestJumpToHouse(houseId)
    end)  
   
  _list.FillScrollList()
end                               

Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized   