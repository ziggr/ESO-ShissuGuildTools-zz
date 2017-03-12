-- Shissu GuildTools Module File
--------------------------------
-- File: marker.lua
-- Version: v1.0.8
-- Last Update: 10.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!

local _globals = Shissu_SuiteManager._globals
local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]
local red = _globals["color"]["red"]

local _lib = Shissu_SuiteManager._lib
local _SGT = Shissu_SuiteManager._lib["SGT"]
local getWindowPosition = _SGT.getWindowPosition
local saveWindowPosition = _SGT.saveWindowPosition
local _i18nC = _SGT.i18nC
local _setPanel = _lib.setPanel
local getString = _SGT.getString
local setDefaultColor = _SGT.setDefaultColor
local createScrollContainer = _SGT.createScrollContainer
 
local _addon = {}
_addon.Name	= "ShissuMarks"
_addon.Version = "1.0.3"
_addon.core = {}
_addon.fN = _SGT["title"](getString(ShissuMarks))

_addon.settings = {
  ["Heal"] = { "Heal", "Heiler", "Pfleger" },
  ["Misc"] = {},
  ["Observe"] = {},
  ["Kick"] = {},
  
  ["guildObserve"] = {}, 
  ["position"] = {},
  ["autoKick"] = {},
}
_addon.ui = {}
_addon.panel = _setPanel(getString(ShissuMarks), _addon.fN, _addon.Version)
_addon.controls = {}

_addon.core["MiscIndexPool"] = nil
_addon.core["ObserveIndexPool"] = nil
_addon.core["KickIndexPool"] = nil
_addon.core["HealIndexPool"] = nil
_addon.core["AllIndexPool"] = nil

_addon.core["MiscScrollItem"] = 1
_addon.core["ObserveScrollItem"] = 1
_addon.core["KickScrollItem"] = 1
_addon.core["HealScrollItem"] = 1
_addon.core["AllScrollItem"] = 1

_addon.core.allSelected = nil
_addon.core.unitSelected = nil
_addon.core.unitSelectedId = nil
_addon.core.unitInSight = nil

_addon.core.listAll = {}

_addon.core.unit = {}
_addon.core.prefixUnit = {}

ESO_Dialogs["SHISSU_DIALOG"] = {
  title = { text = "TITEL", },
  mainText = { text = "TEXT", },
  buttons = {
    [1] = {
      text = SI_DIALOG_REMOVE,
      callback = function(dialog) end, },
    [2] = { text = SI_DIALOG_CANCEL, }
  }                                       
}

ESO_Dialogs["SHISSU_DIALOG_ADD"] = {
  title = { text = "TITEL", },
  mainText = {  text = "TEXT", },
  editBox = { text = "", },
  buttons = {
    [1] = {
      text = SI_DIALOG_REMOVE,
      callback = function(dialog) end, },
    [2] = { text = SI_DIALOG_CANCEL, }
  }                                       
}

function _addon.core.createSettingMenu()
  local controls = Shissu_SuiteManager._settings[_addon.Name].controls

  local numGuild = GetNumGuilds()
  
  -- Beobachten
  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuMarks_observe),  
  }
    
  controls[#controls+1] = {
    type = "description",
    text = blue .. getString(ShissuMarks_observeInfo) .. white .. "\n" ..
      getString(ShissuMarks_observeInfo2) .. "\n" ..
      getString(ShissuMarks_observeInfo3) .. "\n" ..
      getString(ShissuMarks_observeInfo4),  
  }
  
  for guildId = 1, numGuild do
    local name = GetGuildName(guildId)           

    controls[#controls+1] = {
      type = "checkbox",
      name = name,
      getFunc = _addon.settings["guildObserve"][name] or true,
      setFunc = function(_, value)
        _addon.settings["guildObserve"][name] = value
      end,
    }
  end
  
  -- Automatisches Kicken
  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuMarks_autoKick),  
  }
    
  controls[#controls+1] = {
    type = "description",
    text = blue .. getString(ShissuMarks_autoKickInfo) .. white .. "\n" ..
      getString(ShissuMarks_autoKickInfo2) .. "\n" ..
      getString(ShissuMarks_autoKickInfo3),
  }
  
  for guildId = 1, numGuild do
    local name = GetGuildName(guildId)           

    controls[#controls+1] = {
      type = "checkbox",
      name = name,
      getFunc = _addon.settings["autoKick"][name],
      setFunc = function(_, value)
        _addon.settings["autoKick"][name] = value
      end,
    }
  end
    
end


function _addon.core.showSymbol(groupName)
  local symbol = {
    ["Misc"] = "ESOUI\\art\\progression\\progression_indexicon_world_down.dds",
    ["Heal"] = "ESOUI\\art\\lfg\\lfg_healer_down_64.dds",
    ["Kick"] = "ESOUI\\art\\emotes\\emotes_indexicon_fidget_down.dds",
    ["Observe"] = "ESOUI\\art\\emotes\\emotes_indexicon_personality_down.dds",
  }
  
  if (groupName == "All") then return end
          
  local offsetX, offsetY = GetUIMousePosition()
    
  SMM_Symbol:ClearAnchors()
  SMM_Symbol:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, offsetX, offsetY)
  SMM_Symbol_Image:SetTexture(symbol[groupName])
  SMM_Symbol:SetHidden(false)
  
  return true
end

function _addon.core.getList(listName)
  if (listName == "All") then
      return _addon.core.listAll
  end
  
  return _addon.settings[listName]
end

function _addon.core.filterScrollList(listName)
  local list = _addon.core.getList(listName)
  
  local sortedTitle = {}
  local sortedData = {}
     
  local numPages = #list
  
  for i = 1, numPages do
    table.insert(sortedTitle, i, list[i] .. "**shissu" .. i)
  end
  
  table.sort(sortedTitle)
                                                   
  for i = 1, numPages do
    local length = string.len(sortedTitle[i])
    local number = string.sub(sortedTitle[i], string.find(sortedTitle[i], "**shissu"), length)

    number = string.gsub(number, "**shissu", "")
    number = string.gsub(number, " ", "")
    number = tonumber(number)

    sortedData[i] = list[number]
  end

  for i = 1, numPages do
    local control = _addon.core[listName .. "IndexPool"]:AcquireObject(i)
    control.unit = sortedData[i]
    control.id = i
    control:SetText(white.. sortedData[i])
    control:SetHidden(false)
    
    _addon.core.unit[sortedData[i]] = listName
    
    if string.find(sortedData[i], "*") then
      local newString = string.gsub(sortedData[i], "*" , "")
      _addon.core.prefixUnit[newString] = listName
    end
  end     
   
  local activePages = _addon.core[listName .. "IndexPool"]:GetActiveObjectCount()
  if activePages > numPages then
    for i = numPages+1, activePages do _addon.core[listName .. "IndexPool"]:ReleaseObject(i) end
  end
end

function _addon.core.removeInAll(unitName)
  local numPages = #_addon.core.listAll
  
  for i=1, numPages do
    if _addon.core.listAll[i] == unitName then
      table.remove(_addon.core.listAll, i)
      break
    end
  end
  
  _addon.core.filterScrollList("All") 
end

function _addon.core.showPrefixSymbol(unitName)
  for unitPrefix, groupName in pairs(_addon.core.prefixUnit) do
    if string.find(string.lower(unitName), string.lower(unitPrefix)) then
      _addon.core.showSymbol(groupName)
      return true
    end
  end
    
  return false
end

function _addon.core.setHandlerTransferButton(control, listName)
  control:SetHandler("OnClicked", function()
    if _addon.core.unitSelected == nil then return end
    
    if _addon.core.unit[_addon.core.unitSelected] == "All" then
                                                         
      _addon.core.removeInAll(unitSelected)
      table.insert(_addon.core.getList(listName), _addon.core.unitSelected)
       
      _addon.core.filterScrollList(listName)
    end  
  end)
end

function _addon.core.createScrollControls(var, offsetX)
  _addon.core[var .. "IndexPool"] = ZO_ObjectPool:New(_addon.core.createIndexButton, _addon.core.removeIndexButton)
  
  SM[var] = WINDOW_MANAGER:CreateControlFromVirtual("SM_" .. var .. "List", SGT_Marks, "ZO_ScrollContainer")
  SM[var]:SetAnchor(TOPLEFT, SGT_Marks_Line2, BOTTOMLEFT, offsetX, 10)
  SM[var]:SetAnchor(BOTTOMLEFT, SGT_Marks, BOTTOMLEFT, offsetX, -10)
  SM[var]:SetWidth(150)
  SM[var].scrollChild = SM[var]:GetNamedChild("ScrollChild") 
end

function _addon.core.showDialog(dialogTitle, dialogText, callbackFunc, vars)
  ESO_Dialogs["SHISSU_DIALOG"].title = {text = dialogTitle,}
  ESO_Dialogs["SHISSU_DIALOG"].mainText = {text = dialogText,}
  ESO_Dialogs["SHISSU_DIALOG"].buttons[1].callback = callbackFunc

  ZO_Dialogs_ShowDialog("SHISSU_DIALOG", vars)
end

function _addon.core.listButton(self, button)
  local var
  
  if self == SGT_Marks_MiscButton then var = "Misc" end
  if self == SGT_Marks_KickButton then var = "Kick" end
  if self == SGT_Marks_HealButton then var = "Heal" end
  if self == SGT_Marks_ObserveButton then var = "Observe" end
  if self == SGT_Marks_AllButton then var = "All" end
    
  if button == 1 then
    ESO_Dialogs["SHISSU_DIALOG_ADD"].title = {text = getString(ShissuMarks_add),}
    ESO_Dialogs["SHISSU_DIALOG_ADD"].mainText = {text = getString(ShissuMarks_add2),}
    ESO_Dialogs["SHISSU_DIALOG_ADD"].buttons[1].callback = function(dialog)    
      local unitName = ZO_Dialogs_GetEditBoxText(dialog)
  
      if unitName and unitName ~= "" then
        _addon.core.unitInSight  = unitName
        _addon.core.addToGroup(var)
      end
    end

    ZO_Dialogs_ShowDialog("SHISSU_DIALOG_ADD")    
  end
  
  -- Listen komplett löschen
  if button == 2 then
      _addon.core.showDialog(getString(ShissuMarks_confirmDel), getString(ShissuMarks_confirmDel2), function()
  
      if (var == "All") then
        _addon.core.listAll = {}
      else
        _addon.settings[var] = {}
      end
           
      _addon.core.filterScrollList(var)
        
      for unitName, groupName in pairs(_addon.core.unit) do
        if groupName == var then _addon.core.unit[unitName] = nil end
      end  
    end, nil)
  end
  
  if button == 3 then
    if (var == "Kick") then
      checkObserver(1)  
    elseif (var == "Observe") then
      checkObserver()
    end    
  end
end

function _addon.core.addToGroup(listName)
  if listName == nil then return false end
  
  if _addon.core.unitInSight == nil then
    return false
  end
  
  if _addon.core.unit[_addon.core.unitInSight ] and _addon.core.unit[_addon.core.unitInSight ] ~= "All" then
    d(white .. getString(ShissuMarks_add5) .. ": " .. blue .. _addon.core.unit[_addon.core.unitInSight ] .. "." )
    return false
  else
    table.insert(_addon.core.getList(listName), _addon.core.unitInSight )
    _addon.core.filterScrollList(listName)
    --_addon.core.removeInAll(unitName)
    --d(white .. getString(ShissuMarks_add3) .. ": " .. blue .. listName .. white .. " " .. getString(ShissuMarks_add4) .. "." )
    _addon.core.unitInSight = nil
  end
end
                                             
function _addon.core.createDivider(anchor, count)
  local control = WINDOW_MANAGER:CreateControl("SM_Divider" .. count, SGT_Marks, CT_TEXTURE)
  control:SetAnchor(TOPLEFT, anchor, TOPRIGHT, -10, 0)
  control:SetAnchor(BOTTOMLEFT, anchor, BOTTOMRIGHT, -10, -20)
  control:SetWidth(1)
  control:SetTexture("ShissuGuildTools/textures/vertikal.dds")
  control:SetColor(0.49019607901573, 0.74117648601532, 1, 1)  
  
  return control
end
          
function _addon.core.RETICLE_TARGET_CHANGED (_, Name)
  local unitName = GetUnitName('reticleover')
  _addon.core.unitInSight = unitName
  
  if not SMM_Symbol:IsHidden() then
    SMM_Symbol:SetHidden(true)
  end

  if unitName == nil or unitName == "" then return end
     
  if _addon.core.unit[unitName] == nil then                  
    table.insert(_addon.core.listAll, unitName)
    _addon.core.filterScrollList("All")
    return
  end
  
  if _addon.core.unit[unitName] ~= nil or _addon.core.unit[unitName] ~= "All" then
    if _addon.core.showSymbol(_addon.core.unit[unitName]) then return end
  end 
  
  if _addon.core.showPrefixSymbol(unitName) then return end
end                               

-- Einzelne Listen Einträge erstellen
function _addon.core.createIndexButton(indexPool)
  local listName
  dddd = 0
  if indexPool == _addon.core["MiscIndexPool"] then listName = "Misc" end
  if indexPool == _addon.core["KickIndexPool"] then listName = "Kick" end
  if indexPool == _addon.core["ObserveIndexPool"] then listName = "Observe" end
  if indexPool == _addon.core["HealIndexPool"] then listName = "Heal" end
  if indexPool == _addon.core["AllIndexPool"] then listName = "All" end
  
  local control = ZO_ObjectPool_CreateControl("SM_" .. listName .. "Index", indexPool, _addon.ui[listName].scrollChild)
  local anchorBtn = _addon.core[listName .. "ScrollItem"] == 1 and _addon.ui[listName].scrollChild or indexPool:AcquireObject( _addon.core[listName.."ScrollItem"]-1 )
  
  control:SetAnchor(TOPLEFT, anchorBtn, _addon.core[listName.."ScrollItem"] == 1 and TOPLEFT or BOTTOMLEFT)
  control:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  control:SetWidth(140)
  
  control:SetHandler("OnMouseUp", function(self, button)   
    _addon.core.unitSelected = self.unit
    _addon.core.unitSelectedId = self.id
    
    _addon.ui.allSelected:SetHidden(false)
    _addon.ui.allSelected:ClearAnchors()
    _addon.ui.allSelected:SetAnchorFill(self)
    
    -- Entfernen
    if button == 2 then
      local list = _addon.core.getList(listName)
      local numPages = #list
      local monsterId = -1
      
      for i=1, numPages do
        if ( list[i] == self.unit ) then
          monsterId = i
          break
        end
      end
      
      if ( monsterId == -1 ) then
        return
      end
      
      table.remove(_addon.core.getList(listName), monsterId)
      _addon.core.unit[self.unit] = nil
      _addon.core.filterScrollList(listName)
    end
  end)
  
  _addon.core[listName .. "ScrollItem"] = _addon.core[listName .. "ScrollItem"] + 1

  return control
end

-- Einzelne Listen Eintrag entfernen (verstecken)
function _addon.core.removeIndexButton(control)
  control:SetHidden(true)
  control = nil
end 

function _addon.core.UI()
  _SGT.createFlatWindow(
    "SGT_Marks",
    SGT_Marks,  
    {850, 400}, 
    function() SGT_Marks:SetHidden(true) end,
    getString(ShissuMarks_title)
  ) 

  SGT_Marks_Version:SetText(_addon.fN .. " " .. _addon.Version)

  setDefaultColor(SGT_Marks_Line2)
  
  SGT_Marks_Misc:SetText(getString(ShissuMarks_misc))
  SGT_Marks_Observe:SetText(getString(ShissuMarks_observe))
  SGT_Marks_Kick:SetText(getString(ShissuMarks_kick))
  SGT_Marks_Heal:SetText(getString(ShissuMarks_heal))
  SGT_Marks_All:SetText(getString(ShissuMarks_all))
    
  SGT_Marks_Info_Label:SetText("|c779cff<---|r")

  SGT_Marks_KickInfo:SetText(red .. getString(ShissuMarks_rightItem) .. white .. " = " .. getString(ShissuMarks_rightItem2))
  
  _addon.ui["Heal"] = createScrollContainer("SM_HealList", 150, SGT_Marks, SGT_Marks_Line2, 10, 10, -10)
  _addon.core["HealIndexPool"] = ZO_ObjectPool:New(_addon.core.createIndexButton, _addon.core.removeIndexButton)  
  _addon.ui.divider4 = _addon.core.createDivider(SM_HealList, "2")
 
  _addon.ui["Misc"] = createScrollContainer("SM_MiscList", 150, SGT_Marks, SGT_Marks_Line2, 170, 10, -10)
  _addon.core["MiscIndexPool"] = ZO_ObjectPool:New(_addon.core.createIndexButton, _addon.core.removeIndexButton)  
  _addon.ui.divider1 = _addon.core.createDivider(SM_MiscList, "F")
  
  _addon.ui["Observe"] = createScrollContainer("SM_ObserveList", 150, SGT_Marks, SGT_Marks_Line2, 170+160, 10, -10)
  _addon.core["ObserveIndexPool"] = ZO_ObjectPool:New(_addon.core.createIndexButton, _addon.core.removeIndexButton)
  _addon.ui.divider2 = _addon.core.createDivider(SM_ObserveList, "H")

  _addon.ui["Kick"] = createScrollContainer("SM_KickList", 150, SGT_Marks, SGT_Marks_Line2, 170+160+160, 10, -10)
  _addon.core["KickIndexPool"] = ZO_ObjectPool:New(_addon.core.createIndexButton, _addon.core.removeIndexButton) 
  _addon.ui.divider3 = _addon.core.createDivider(SM_KickList, "1")

  _addon.ui["All"] = createScrollContainer("SM_AllList", 150, SGT_Marks, SGT_Marks_Line2, 170+160+160+200, 10, -10)  
  _addon.core["AllIndexPool"] = ZO_ObjectPool:New(_addon.core.createIndexButton, _addon.core.removeIndexButton)

  _addon.ui.allSelected = WINDOW_MANAGER:CreateControl(nil, _addon.ui["All"].scrollChild, CT_TEXTURE)
  _addon.ui.allSelected:SetTexture("EsoUI\\Art\\Buttons\\generic_highlight.dds")
  _addon.ui.allSelected:SetHidden(true)
  setDefaultColor(_addon.ui.allSelected)
    
  _addon.core.setHandlerTransferButton(SGT_Marks_ButtonHeal, "Heal")
  _addon.core.setHandlerTransferButton(SGT_Marks_ButtonMisc, "Misc")
  
  SGT_Marks_HealButton:SetHandler("OnMouseUp", _addon.core.listButton)
  SGT_Marks_MiscButton:SetHandler("OnMouseUp", _addon.core.listButton)
  SGT_Marks_ObserveButton:SetHandler("OnMouseUp", _addon.core.listButton)
  SGT_Marks_KickButton:SetHandler("OnMouseUp", _addon.core.listButton)
  SGT_Marks_AllButton:SetHandler("OnMouseUp", _addon.core.listButton)
  
  local stdTool = blue .. getString(ShissuModule_leftMouse) .. white .. " - " .. getString(ShissuMarks_leftMouse) .. "\n" .. blue .. getString(ShissuModule_rightMouse) .. white .." - " .. getString(ShissuMarks_rightMouse)
  local stdTool2 = blue .. getString(ShissuModule_leftMouse) .. white .. " - " .. getString(ShissuMarks_leftMouse) .. "\n" .. blue .. getString(ShissuModule_middleMouse) .. white .. " - " .. getString(ShissuMarks_middleMouse) .. "\n" .. blue .. getString(ShissuModule_rightMouse) .. white .." - " .. getString(ShissuMarks_rightMouse)
   
  _addon.core.tooltip(SGT_Marks_HealButton, stdTool)
  _addon.core.tooltip(SGT_Marks_MiscButton, stdTool)  
  _addon.core.tooltip(SGT_Marks_ObserveButton, stdTool2)
  _addon.core.tooltip(SGT_Marks_KickButton, stdTool2)  
  _addon.core.tooltip(SGT_Marks_AllButton, blue.. getString(ShissuModule_rightMouse) .. white .. " - " .. getString(ShissuMarks_rightMouse))
  _addon.core.tooltip(SGT_Marks_ButtonHeal, blue .. getString(ShissuMarks_leftMouse) .. white .. ": " .. getString(ShissuMarks_heal))
  _addon.core.tooltip(SGT_Marks_ButtonMisc, blue .. getString(ShissuMarks_leftMouse) .. white .. ": " .. getString(ShissuMarks_misc))
  
  if (_addon.settings["position"] == nil) then
    _addon.settings["position"] = {}
  end
  
  saveWindowPosition(SGT_Marks, _addon.settings["position"])
  getWindowPosition(SGT_Marks, _addon.settings["position"])
  
  -- Gespeicherten Listen auslesen!
  _addon.core.filterScrollList("Heal")
  _addon.core.filterScrollList("Misc")
  _addon.core.filterScrollList("Kick")
  _addon.core.filterScrollList("Observe")

  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_RETICLE_TARGET_CHANGED, _addon.core.RETICLE_TARGET_CHANGED)        
end

function _addon.core.tooltip(control, text)
  control:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, text) end)
  control:SetHandler("OnMouseExit", function(self) ZO_Tooltips_HideTextTooltip() end)  
end
 
function checkObserver(kick)
  local list = _addon.settings["Observe"]
  
  if (kick) then
    list = _addon.settings["Kick"]
  end
  
  local numPages = #list
  
  local observeAllow = false
  local kickAllow = false
    
  for i=1, numPages do 
    local accName = list[i]
    local data = _SGTaccountList[accName]
    local found = 0
    local foundFirst = 0 
    local foundGuilds = ""  
    local kickGuild = {}
    
    if (data ~= nil) then      
      local numEntrys = #data["guilds"]
      data2 = data["guilds"]
      
      for y=1, numEntrys do
        local accGuildId = data2[y][2]
        local accGuildName = data2[y][1]

        if (_addon.settings["autoKick"][accGuildName]) then
          table.insert(kickGuild, { data.id, data2[y][2]} )   
        end
        
        if (_addon.settings["guildObserve"][accGuildName]) then
          observeAllow = true
        end     
        
        if ( foundFirst == 0 ) then
          foundFirst = 1
          foundGuilds = foundGuilds .. data2[y][1]
        else
          foundGuilds = foundGuilds .. ", " .. data2[y][1]
        end
          
        found = 1
      end

      -- Array > 0 = Gefunden
      if ( found == 1) then
        if (kick) then
          foundGuilds = foundGuilds .. " " .. getString(ShissuMarks_found2)
        end
      
        if (observeAllow) then
          d(_addon.fN .. ": " .. red .. accName .. white .. " " .. getString(ShissuMarks_found) .. ": " .. foundGuilds)
        end
        
        if (kick) then
          for y=1, #kickGuild do        
            accGuildId = kickGuild[y][2]   
            accGuildName = GetGuildName(accGuildId)   

            if (_addon.settings["guildObserve"][accGuildName]) then
              GuildRemove(accGuildId, accName)
              
              if (observeAllow or kickAllow) then
                d(_addon.fN .. ": " .. red .. accName .. white .. " " .. getString(ShissuMarks_found) .. ": " .. foundGuilds)
              end
            end
          end
        end
      end
    
    end
  end
end
 
_addon.core.firstLoad = 1 
 
function _addon.core.startCheck(eventCode)
  if (_addon.core.firstLoad == 1) then
    _addon.core.firstLoad = 0 
    
    zo_callLater(function() 
      checkObserver()
      checkObserver(1)    
    end, 5000)
  else
    checkObserver()
    checkObserver(1)
  end
end
 
-- * Initialisierung
function _addon.core.initialized()
  shissuGT = shissuGT or {}
  shissuGT[_addon.Name] = shissuGT[_addon.Name] or _addon.settings
  _addon.settings = shissuGT[_addon.Name]
   
     -- Hat jemand die neue SaveVar schon?  
  if (_addon.settings["guildObserve"] == nil) then _addon.settings["guildObserve"] = {} end
  if (_addon.settings["autoKick"] == nil) then _addon.settings["autoKick"] = {} end

  for guildId=1, GetNumGuilds() do
    local guildName = GetGuildName(guildId)  
    if (_addon.settings["guildObserve"][guildName] == nil) then _addon.settings["guildObserve"][guildName] = true end
    if (_addon.settings["autoKick"][guildName] == nil) then _addon.settings["autoKick"][guildName] = false end
  end
                     
  _addon.core.createSettingMenu()  
  _addon.core.UI()
 
  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_GUILD_MEMBER_ADDED, _addon.core.startCheck)
  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_GUILD_MEMBER_REMOVED, _addon.core.startCheck)
  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_PLAYER_ACTIVATED, _addon.core.startCheck)
  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED, _addon.core.startCheck)
end                               

Shissu_SuiteManager._settings[_addon.Name] = {}
Shissu_SuiteManager._settings[_addon.Name].panel = _addon.panel                                       
Shissu_SuiteManager._settings[_addon.Name].controls = _addon.controls                 
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized 