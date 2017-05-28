-- Shissu GuildTools Module File
--------------------------------
-- File: marker.lua
-- Version: v1.2.0
-- Last Update: 20.05.2017
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
_addon.Version = "1.1.0"
_addon.core = {}
_addon.fN = _SGT["title"](getString(ShissuMarks))

_addon.settings = {
  ["heal"] = { "Heal", "Heiler", "Pfleger"},  
  ["color1"] = {0.50196081399918, 0.80000001192093, 1, 1},
  ["color2"] = {0.8901960849762, 0.93333333730698, 1, 1},  
  ["position"] = {},
}
_addon.ui = {}
_addon.panel = _setPanel(getString(ShissuMarks), _addon.fN, _addon.Version)
_addon.controls = {}

_addon.core["misc1IndexPool"] = nil
_addon.core["misc2IndexPool"] = nil
_addon.core["HealIndexPool"] = nil

_addon.core["misc1ScrollItem"] = 1
_addon.core["misc2ScrollItem"] = 1
_addon.core["HealScrollItem"] = 1

_addon.core.unitSelected = nil
_addon.core.unitSelectedId = nil
_addon.core.unitInSight = nil

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
    name = getString(ShissuMarks_misc2),  
  }
    
  controls[#controls+1] = {
    type = "colorpicker", 
    name = getString(ShissuChat_warningColor),
    tooltip = getString(ShissuChat_warningColorTT),
    getFunc = _addon.settings["color1"], 
    setFunc = function (r, g, b, a)                                                                                                                                                           
      _addon.settings["color1"] = {r, g, b, a}
    end,
  }    

  controls[#controls+1] = {
    type = "colorpicker", 
    name = getString(ShissuChat_warningColor),
    tooltip = getString(ShissuChat_warningColorTT),
    getFunc = _addon.settings["color2"], 
    setFunc = function (r, g, b, a)                                                                                                                                                           
      _addon.settings["color2"] = {r, g, b, a}
    end,
  }             
end


function _addon.core.showSymbol(groupName)
  local symbol = {
    ["misc1"] = "ESOUI\\art\\progression\\progression_indexicon_world_down.dds",
    ["Heal"] = "ESOUI\\art\\lfg\\lfg_healer_down_64.dds",
    ["misc2"] = "ESOUI\\art\\emotes\\emotes_indexicon_personality_down.dds",
  }
  
  local offsetX, offsetY = GetUIMousePosition()
    
  SMM_Symbol:ClearAnchors()
  SMM_Symbol:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, offsetX, offsetY)
  SMM_Symbol_Image:SetTexture(symbol[groupName])
  SMM_Symbol:SetHidden(false)
  
  return true
end

function _addon.core.getList(listName)
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


function _addon.core.showPrefixSymbol(unitName)
  for unitPrefix, groupName in pairs(_addon.core.prefixUnit) do
    if string.find(string.lower(unitName), string.lower(unitPrefix)) then
      _addon.core.showSymbol(groupName)
      return true
    end
  end
    
  return false
end

function _addon.core.createScrollControls(var, offsetX)
  _addon.core[var .. "IndexPool"] = ZO_ObjectPool:New(_addon.core.createIndexButton, _addon.core.removeIndexButton)
  
  SM[var] = WINDOW_MANAGER:CreateControlFromVirtual("SM_" .. var .. "List", SGT_Marks, "ZO_ScrollContainer")
  SM[var]:SetAnchor(TOPLEFT, SGT_Marks_Line2, BOTTOMLEFT, offsetX, 10)
  SM[var]:SetAnchor(BOTTOMLEFT, SGT_Marks, BOTTOMLEFT, offsetX, -10)
  SM[var]:SetWidth(150)
  SM[var].scrollChild = SM[var]:GetNam1edChild("ScrollChild") 
end

function _addon.core.showDialog(dialogTitle, dialogText, callbackFunc, vars)
  ESO_Dialogs["SHISSU_DIALOG"].title = {text = dialogTitle,}
  ESO_Dialogs["SHISSU_DIALOG"].mainText = {text = dialogText,}
  ESO_Dialogs["SHISSU_DIALOG"].buttons[1].callback = callbackFunc

  ZO_Dialogs_ShowDialog("SHISSU_DIALOG", vars)
end

function _addon.core.listButton(self, button)
  local var
  
  if self == SGT_Marks_misc1Button then var = "misc1" end
  if self == SGT_Marks_HealButton then var = "Heal" end
  if self == SGT_Marks_misc2Button then var = "misc2" end
    
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
  
        _addon.settings[var] = {}
           
      _addon.core.filterScrollList(var)
        
      for unitName, groupName in pairs(_addon.core.unit) do
        if groupName == var then _addon.core.unit[unitName] = nil end
      end  
    end, nil)
  end
  
  if button == 3 then
      checkmisc2r()
  end
end

function _addon.core.addToGroup(listName)
  if listName == nil then return false end
  
  if _addon.core.unitInSight == nil then
    return false
  end
  
  table.insert(_addon.core.getList(listName), _addon.core.unitInSight )
  _addon.core.filterScrollList(listName)
  _addon.core.unitInSight = nil
end
                                             
function _addon.core.createDivider(anchor, count)
  local control = WINDOW_MANAGER:CreateControl("SM_Divider" .. count, SGT_Marks, CT_TEXTURE)
  control:SetAnchor(TOPLEFT, anchor, TOPRIGHT, -10, 0)
  control:SetAnchor(BOTTOMLEFT, anchor, BOTTOMRIGHT, -10, -20)
  control:SetWidth(1)
  control:SetHidden(false)
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
       
  if _addon.core.unit[unitName] ~= nil then
    if _addon.core.showSymbol(_addon.core.unit[unitName]) then return end
  end 
  
  if _addon.core.showPrefixSymbol(unitName) then return end
end                               

-- Einzelne Listen Einträge erstellen
function _addon.core.createIndexButton(indexPool)
  local listName

  if indexPool == _addon.core["misc1IndexPool"] then listName = "misc1" end
  if indexPool == _addon.core["misc2IndexPool"] then listName = "misc2" end
  if indexPool == _addon.core["HealIndexPool"] then listName = "Heal" end
  local control = ZO_ObjectPool_CreateControl("SM_" .. listName .. "Index", indexPool, _addon.ui[listName].scrollChild)
  local anchorBtn = _addon.core[listName .. "ScrollItem"] == 1 and _addon.ui[listName].scrollChild or indexPool:AcquireObject( _addon.core[listName.."ScrollItem"]-1 )
  
  control:SetAnchor(TOPLEFT, anchorBtn, _addon.core[listName.."ScrollItem"] == 1 and TOPLEFT or BOTTOMLEFT)
  control:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  control:SetWidth(140)
  
  control:SetHandler("OnMouseUp", function(self, button)   
    _addon.core.unitSelected = self.unit
    _addon.core.unitSelectedId = self.id
    
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
  _addon.ui["Heal"] = createScrollContainer("SM_HealList", 150, SGT_Marks, SGT_Marks_Line2, 10, 10, -10)
  _addon.core["HealIndexPool"] = ZO_ObjectPool:New(_addon.core.createIndexButton, _addon.core.removeIndexButton)  
  _addon.ui.divider4 = _addon.core.createDivider(SM_HealList, "2")
  
  _addon.ui["misc1"] = createScrollContainer("SM_misc1List", 150, SGT_Marks, SGT_Marks_Line2, 170, 10, -10)
  _addon.core["misc1IndexPool"] = ZO_ObjectPool:New(_addon.core.createIndexButton, _addon.core.removeIndexButton)  
  _addon.ui.divider1 = _addon.core.createDivider(SM_misc1List, "F")
  
  _addon.ui["misc2"] = createScrollContainer("SM_misc2List", 150, SGT_Marks, SGT_Marks_Line2, 170+160, 10, -10)
  _addon.core["misc2IndexPool"] = ZO_ObjectPool:New(_addon.core.createIndexButton, _addon.core.removeIndexButton)
  _addon.ui.divider2 = _addon.core.createDivider(SM_misc2List, "H")

  --SGT_Marks_HealButton:SetHandler("OnMouseUp", _addon.core.listButton)
--  SGT_Marks_misc1Button:SetHandler("OnMouseUp", _addon.core.listButton)
 -- SGT_Marks_misc2Button:SetHandler("OnMouseUp", _addon.core.listButton)
  
  if (_addon.settings["position"] == nil) then
    _addon.settings["position"] = {}
  end
  
  saveWindowPosition(SGT_Marks, _addon.settings["position"])
  getWindowPosition(SGT_Marks, _addon.settings["position"])
  
  -- Gespeicherten Listen auslesen!
 -- _addon.core.filterScrollList("Heal")
 -- _addon.core.filterScrollList("misc1")
 -- _addon.core.filterScrollList("misc2")



  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_RETICLE_TARGET_CHANGED, _addon.core.RETICLE_TARGET_CHANGED)        
end

function _addon.core.setMiscTitle(control, i18n, colorVar)
  control:SetText(getString(i18n))
  
  local c = _addon.settings[colorVar]
  control:SetColor(c[1], c[2], c[3], c[4])  
end

function _addon.core.tooltip(control)
  local stdTool = blue .. getString(ShissuModule_leftMouse) .. white .. " - " .. getString(ShissuMarks_leftMouse) .. "\n" .. blue .. getString(ShissuModule_rightMouse) .. white .." - " .. getString(ShissuMarks_rightMouse)

  control:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, text) end)
  control:SetHandler("OnMouseExit", function(self) ZO_Tooltips_HideTextTooltip() end)  
end
 
function _addon.core.UI2()
  _SGT.createFlatWindow(
    "SGT_Marks",
    SGT_Marks,  
    {550, 400}, 
    function() SGT_Marks:SetHidden(true) end,
    getString(ShissuMarks_title)
  )
  
  SGT_Marks_Version:SetText(_addon.fN .. " " .. _addon.Version)

  -- Buttons / Überschriften
  SGT_Marks_Heal:SetText(getString(ShissuMarks_heal))
  _addon.core.tooltip(SGT_Marks_HealButton)
  
  _addon.core.setMiscTitle(SGT_Marks_Misc1, ShissuMarks_misc1, color1) 
  _addon.core.tooltip(SGT_Marks_Misc1Button)  
  
  _addon.core.setMiscTitle(SGT_Marks_Misc2, ShissuMarks_misc2, color2)  
  _addon.core.tooltip(SGT_Marks_Misc2Button)  
end

function _addon.core.createNewVar(saveVar, value)
  if _addon.settings[saveVar] == nil then _addon.settings[saveVar] = value end
end
 
-- * Initialisierung
function _addon.core.initialized()
  shissuGT = shissuGT or {}
  shissuGT[_addon.Name] = shissuGT[_addon.Name] or _addon.settings
  _addon.settings = shissuGT[_addon.Name]
 
 _addon.core.createNewVar("color1", {0.50196081399918, 0.80000001192093, 1, 1})
 _addon.core.createNewVar("color2", {0.8901960849762, 0.93333333730698, 1, 1})
                       
  _addon.core.createSettingMenu()  
  _addon.core.UI2()
end                               

Shissu_SuiteManager._settings[_addon.Name] = {}
Shissu_SuiteManager._settings[_addon.Name].panel = _addon.panel                                       
Shissu_SuiteManager._settings[_addon.Name].controls = _addon.controls                 
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized 