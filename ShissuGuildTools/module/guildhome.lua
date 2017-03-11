-- Shissu GuildTools Module File
--------------------------------
-- File: guildhome.lua
-- Version: v1.1.6
-- Last Update: 06.03.2017
-- Written by Christian Flory (@Shissu, EU Server) - esoui@flory.one
-- Distribution without license is prohibited!


local _globals = Shissu_SuiteManager._globals

local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]
local red = _globals["color"]["red"]

local _lib = Shissu_SuiteManager._lib

local _SGT = Shissu_SuiteManager._lib["SGT"]
local setDefaultColor = _SGT.setDefaultColor
local getString = _SGT.getString
local createZOButton = _SGT.createZOButton
local RGBtoHex = _SGT.RGBtoHex
local createLabel = _SGT.createLabel

local _globals = Shissu_SuiteManager._globals
local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]
local correctness = 0
local frameClose = 0

local _addon = {}
_addon.Name	= "ShissuGuildHome"
_addon.Version = "1.1.6"
_addon.core = {}

_addon.kioskTimer = 0
_addon.buttons = {}
_addon.hexColorPicker = nil

_addon.core.userColor1 = nil
_addon.core.userColor2 = nil
_addon.core.userColor3 = nil
_addon.core.userColor4 = nil
_addon.core.userColor5 = nil
_addon.core.userColorW = white

_addon.fN = _SGT["title"](getString(ShissuGuildHome))

_addon.settings = {
  ["kiosk"] = true,
  ["textures"] = true,

  ["color"] = true,
  ["c1"] = {1, 1, 1, 1},
  ["c2"] = {1, 1, 1, 1},
  ["c3"] = {1, 1, 1, 1},
  ["c4"] = {1, 1, 1, 1},
  ["c5"] = {1, 1, 1, 1},
}

_addon.panel = _lib.setPanel(getString(ShissuGuildHome), _addon.fN, _addon.Version)
_addon.controls = {}

function _addon.core.createSettingMenu()
  local controls = Shissu_SuiteManager._settings[_addon.Name].controls

  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuGuildHome_kiosk),
    getFunc = _addon.settings["kiosk"],
    setFunc = function(_, value)
      _addon.core.setSetting("kiosk", value)

      if (value == true) then _addon.core.initKioskTimer() end
    end,
  }

 -- controls[#controls+1] = {
 --   type = "checkbox",
 --   name = getString(ShissuGuildHome_textures),
 --   getFunc = _addon.settings["textures"],
 --   setFunc = function(_, value)
 --     _addon.core.setSetting("textures", value)
 --   end,
 -- }

 -- controls[#controls+1] = {
 --   type = "title",
 --   name = getString(ShissuGuildHome_color),
-- }

 -- -- Nur wenn das Modul: ShissuColor aktiv ist
 -- if (shissuGT["ShissuColor"] ~= nil) then
 --   for i = 1, 5 do
 --     controls[#controls+1] = {
 --       type = "colorpicker",
 --       name = getString(ShissuColor_std) .. " " .. i,
 --      getFunc = _addon.settings["c" .. i],
 --       setFunc = function (r, g, b, a)
 --         _addon.settings["c" .. i] = {r, g, b, a}
 --         shissuGT[_addon.Name]["c" .. i] = {r, g, b, a}
 --       end,
 --     }
 --   end
 -- end
end

function _addon.core.setSetting(setVar, value)
  _addon.settings[setVar] = value
end


function _addon.core.setColor(number)
  _addon.core["userColor" .. number] = "|c" .. RGBtoHex(_addon.settings["c" .. number][1], _addon.settings["c" .. number][2], _addon.settings["c" .. number][3])
end

function _addon.core.getColor()
  if (shissuGT["ShissuColor"] ~= nil) then
    for i = 1, 5 do
      if (shissuGT["ShissuColor"]["c" .. i] ~= nil) then
        _addon.settings["c" .. i] = shissuGT["ShissuColor"]["c" .. i]
      end

      _addon.core.setColor(i)
    end
  end
end

-- * Anzeige der Standardfarben
function _addon.core.showColors()
  local CL = _addon.core.createZOButton

  for i=1, 5 do
    _addon.core.setColor(i)
  end

  -- Erstellen der neuen UI-Elemente
  _addon.buttons.DescriptionStandard1 = CL("SGT_GuildColor_Description1", white .. "[ " .. _addon.core.userColor1 .. "1" .. white .. " ]", 50, 100, -35, ZO_GuildHomeInfoDescriptionSavingEdit, 0)
  _addon.buttons.DescriptionStandard2 = CL("SGT_GuildColor_Description2", white .. "[ " .. _addon.core.userColor2 .. "2" .. white .. " ]", 50, 40, 0, SGT_GuildColor_Description1, 0)
  _addon.buttons.DescriptionStandard3 = CL("SGT_GuildColor_Description3", white .. "[ " .. _addon.core.userColor3 .. "3" .. white .. " ]", 50, 40, 0, SGT_GuildColor_Description2, 0)
  _addon.buttons.DescriptionStandard4 = CL("SGT_GuildColor_Description4", white .. "[ " .. _addon.core.userColor4 .. "4" .. white .. " ]", 50, 40, 0, SGT_GuildColor_Description3, 0)
  _addon.buttons.DescriptionStandard5 = CL("SGT_GuildColor_Description5", white .. "[ " .. _addon.core.userColor5 .. "5" .. white .. " ]", 50, 40, 0, SGT_GuildColor_Description4, 0)
  _addon.buttons.DescriptionStandardW = CL("SGT_GuildColor_DescriptionW", white .. "[ " .. white .. "W ]", 50, 40, 0, SGT_GuildColor_Description5, 0)
  _addon.buttons.DescriptionANY = CL("SGT_GuildColor_DescriptionANY", white .. "[ ANY ]", 80, 40, 0, SGT_GuildColor_DescriptionW, 0)

  _addon.descriptionLeft = createLabel("SGT_DescriptionLeftLabel", ZO_GuildHomeInfoDescriptionSavingEdit, blue .. "100/252", nil, {-55, -51}, false, TOPRIGHT)

  local orgZO_GuildHomeInfoDescriptionSavingEdit = ZO_GuildHomeInfoDescriptionSavingEdit:GetHandler("OnTextChanged")
  local orgZO_GuildHomeInfoDescriptionModify = ZO_GuildHomeInfoDescriptionModify:GetHandler("OnClicked")

  ZO_GuildHomeInfoDescriptionModify:SetHandler("OnClicked", function()
    _addon.core.getColor()

    SGT_GuildColor_Description1:SetText(white .. "[ " .. _addon.core.userColor1 .. "1" .. white .. " ]")
    SGT_GuildColor_Description2:SetText(white .. "[ " .. _addon.core.userColor2 .. "2" .. white .. " ]")
    SGT_GuildColor_Description3:SetText(white .. "[ " .. _addon.core.userColor3 .. "3" .. white .. " ]")
    SGT_GuildColor_Description4:SetText(white .. "[ " .. _addon.core.userColor4 .. "4" .. white .. " ]")
    SGT_GuildColor_Description5:SetText(white .. "[ " .. _addon.core.userColor5 .. "5" .. white .. " ]")

    orgZO_GuildHomeInfoDescriptionModify()
  end)

  ZO_GuildHomeInfoDescriptionSavingEdit:SetHandler("OnTextChanged", function()
    orgZO_GuildHomeInfoDescriptionSavingEdit()
    local control = ZO_GuildHomeInfoDescriptionSavingEdit
    local length = string.len(control:GetText())
    local color = white

    if length > 250 then
      color = red
    end

    SGT_DescriptionLeftLabel:SetText(color .. length .. blue .. "/" .. white .. "256")
  end)

  _addon.buttons.MotDStandard1 = CL("SGT_GuildColor_MotD1", white .. "[ " .. _addon.core.userColor1 .. "1" .. white .. " ]", 50, 200, -35, ZO_GuildHomeInfoMotDSavingEdit, 1)
  _addon.buttons.MotDStandard2 = CL("SGT_GuildColor_MotD2", white .. "[ " .. _addon.core.userColor2 .. "2" .. white .. " ]", 50, 40, 0, SGT_GuildColor_MotD1, 1)
  _addon.buttons.MotDStandard3 = CL("SGT_GuildColor_MotD3", white .. "[ " .. _addon.core.userColor3 .. "3" .. white .. " ]", 50, 40, 0, SGT_GuildColor_MotD2, 1)
  _addon.buttons.MotDStandard4 = CL("SGT_GuildColor_MotD4", white .. "[ " .. _addon.core.userColor4 .. "4" .. white .. " ]", 50, 40, 0, SGT_GuildColor_MotD3, 1)
  _addon.buttons.MotDStandard5 = CL("SGT_GuildColor_MotD5", white .. "[ " .. _addon.core.userColor5 .. "5" .. white .. " ]", 50, 40, 0, SGT_GuildColor_MotD4, 1)
  _addon.buttons.MotDStandardW = CL("SGT_GuildColor_MotDW", white .. "[ " .. white .. "W ]", 50, 40, 0, SGT_GuildColor_MotD5, 1)
  _addon.buttons.MotDANY = CL("SGT_GuildColor_MotDANY", white .. "[ ANY ]", 80, 40, 0, SGT_GuildColor_MotDW, 1)

  _addon.MotDLeft = createLabel("SGT_MotDLeftLabel", ZO_GuildHomeInfoMotDSavingEdit, blue .. "100/1000", nil, {-55, -51}, false, TOPRIGHT)

  local orgZO_GuildHomeInfoMotDSavingEdit = ZO_GuildHomeInfoMotDSavingEdit:GetHandler("OnTextChanged")
  local orgZO_GuildHomeInfoMotDModify = ZO_GuildHomeInfoMotDModify:GetHandler("OnClicked")

  ZO_GuildHomeInfoMotDModify :SetHandler("OnClicked", function()
    _addon.core.getColor()

    SGT_GuildColor_MotD1:SetText(white .. "[ " .. _addon.core.userColor1 .. "1" .. white .. " ]")
    SGT_GuildColor_MotD2:SetText(white .. "[ " .. _addon.core.userColor2 .. "2" .. white .. " ]")
    SGT_GuildColor_MotD3:SetText(white .. "[ " .. _addon.core.userColor3 .. "3" .. white .. " ]")
    SGT_GuildColor_MotD4:SetText(white .. "[ " .. _addon.core.userColor4 .. "4" .. white .. " ]")
    SGT_GuildColor_MotD5:SetText(white .. "[ " .. _addon.core.userColor5 .. "5" .. white .. " ]")

    orgZO_GuildHomeInfoMotDModify()
  end)

  ZO_GuildHomeInfoMotDSavingEdit:SetHandler("OnTextChanged", function()
    orgZO_GuildHomeInfoMotDSavingEdit()
    local control = ZO_GuildHomeInfoMotDSavingEdit
    local length = string.len(control:GetText())
    local color = white

    if length > 990 then
      color = red
    end

    _addon.MotDLeft:SetText(color .. length .. blue .. "/" .. white .. "1024")
  end)
end

function _addon.core.createZOButton(name, text, width, offsetX, offsetY, anchor, control)
  local button = CreateControlFromVirtual(name, anchor, "ZO_DefaultTextButton")
  local editbox
  local buttonlabel = "SGT_GuildColor_Note"

  button:SetText(text)
  button:SetAnchor(TOPLEFT, anchor, TOPLEFT, offsetX, offsetY)
  button:SetWidth(width)

  if control == 0 then
    editbox = ZO_GuildHomeInfoDescriptionSavingEdit
    buttonlabel = "SGT_GuildColor_Description"
  elseif control == 1 then
    editbox = ZO_GuildHomeInfoMotDSavingEdit
    buttonlabel = "SGT_GuildColor_MotD"
  end

  button:SetHandler("OnMouseExit", function() ZO_Tooltips_HideTextTooltip() end)
  button:SetHandler("OnMouseEnter", function()
    local colorString =  string.gsub(button:GetName(), buttonlabel, "")

    if not colorString == "ANY" then
      ZO_Tooltips_ShowTextTooltip(button, TOPRIGHT,  _addon.core["userColor" .. colorString] .. getString(Shissu_yourText) .. "|r")
    end
  end)

  local htmlString

  local function ColorPickerCallback(r, g, b, a)
    htmlString = RGBtoHex(r,g,b)
  end

  local ZOS_BUTTON = ESO_Dialogs.COLOR_PICKER["buttons"][1].callback

  button:SetHandler("OnClicked", function()
    local colorString =  string.gsub(button:GetName(), buttonlabel, "")
    local cache = editbox:GetText()

    if colorString == "ANY" then
      ESO_Dialogs.COLOR_PICKER["buttons"][1].callback = function()
        editbox:SetText(cache .. "|c" .. htmlString .. getString(Shissu_yourText) .. "|r")
        ESO_Dialogs.COLOR_PICKER["buttons"][1].callback = ZOS_BUTTON
      end

      COLOR_PICKER:Show(ColorPickerCallback, r, g, b, a, getString(ShissuGuildHome_color))
    else
      editbox:SetText(cache .. _addon.core["userColor" .. colorString] .. getString(Shissu_yourText) .. "|r")
    end
  end)

  return button
end

-- Sekunden in die Form: XXX Tage XX Stunden umrechnen
function _addon.core.secsToTime(time, complete)
  local day = math.floor(time / 86400)
  local hours = math.floor(time / 3600) - (day * 24)
  local minutes = math.floor(time / 60) - (day * 1440) - (hours * 60)
  local seconds = time % 60

  if complete then return ("%dd %dh %dmin %ds"):format(day, hours, minutes, seconds) end

  -- mehr als 1 Tag
  if(day >= 1) then return ("%dd %dh"):format(day, hours) end

  -- Spieler sind weniger als 1d Offline
  if(hours >= 1) then return ("%dh %dmin"):format(hours, minutes) end

  -- Spieler sind weniger als 1h Offline
  if(minutes >= 1) then return ("%dmin %ds"):format(minutes, seconds) end

  -- Spieler sind weniger als 1m Offline
  return ("%ds"):format(seconds)
end

function _addon.core.getKioskTime(which)
  local hourSeconds = 60 * 60
  local daySeconds = 60 * 60 *24
  local weekSeconds = 7 * daySeconds

  -- Erste Woche 1970 beginnt Donnerstag -> Verschiebung auf Gebotsende
  local firstWeek = 1 + (3 * daySeconds) + (20 * hourSeconds)

  local currentTime = _addon.core.currentTime()

  -- Anzahl der Wochen seit 01.01.1970
  local week = math.floor(currentTime / weekSeconds)
  local beginnKiosk = firstWeek + (weekSeconds * week)

  -- Gebots Ende
  if (which == 1) then
    beginnKiosk = beginnKiosk - 300
  -- Ersatzhändler
  elseif (which == 2) then
    beginnKiosk = beginnKiosk + 300
  end

  -- Restliche Zeit in der Woche
  local restWeekTime = beginnKiosk - currentTime

  if restWeekTime < 0 then
    restWeekTime = restWeekTime + weekSeconds
  end

  return restWeekTime
end

function _addon.core.initKioskTimer()
  if _addon.kioskTimer == 1 then return false end
  _addon.kioskTimer = 1

  -- Fensterelement
  _addon.core.time = CreateControlFromVirtual("SGT_HomeTimer", ZO_GuildHome, "ZO_DefaultTextButton")
  _addon.core.time:SetAnchor(TOPLEFT, ZO_GuildHome, TOPLEFT, 32, 480)
  _addon.core.time:SetWidth(180)
  _addon.core.time:SetHeight(100)
  _addon.core.time:SetHidden(false)
  _addon.core.time:SetHandler("OnMouseEnter", function(self)
    ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, white.. _addon.core.secsToTime(_addon.core.getKioskTime(), true))
  end)
  _addon.core.time:SetHandler("OnMouseExit", function(self)
    ZO_Tooltips_HideTextTooltip()
  end)

  _addon.core.time:SetHandler("OnMouseUp", function(self) SGT_KioskTime:SetHidden(false) end)

  _addon.core.kioskTimeUpdate(1000)
end

function _addon.core.currentTime()
  local correction = GetSecondsSinceMidnight() - (GetTimeStamp() % 86400)
  if correction < -12*60*60 then correction = correction + 86400 end

  return GetTimeStamp() + correction
end

-- Gildenfenster, UPDATE EVENT
function _addon.core.kioskTimeUpdate(time)
  EVENT_MANAGER:UnregisterForUpdate("ShissuGT_KioskTimer")

  EVENT_MANAGER:RegisterForUpdate("ShissuGT_KioskTimer", time, function()
    local leftTime  = ZO_FormatTimeLargestTwo(_SGT.getKioskTime(), TIME_FORMAT_STYLE_DESCRIPTIVE)
    _addon.core.time:SetText("|t36:36:EsoUI/Art/Guild/ownership_icon_guildtrader.dds|t" .."\n|c779cff" .. getString(ShissuGuildHome_leftTime) .. "\n" .. white .. leftTime)

    if (frameClose == 0 and _addon.core.currentTime() > _addon.core.currentTime() + _addon.core.getKioskTime() - 900 ) then
      SGT_KioskTime:SetHidden(false)
    end

    if (SGT_KioskTime:IsHidden() == false) then
      SGT_KioskTime_NextKioskCount:SetText(_addon.core.secsToTime(_SGT.getKioskTime(), true))
      SGT_KioskTime_LastBidCount:SetText(red .. _addon.core.secsToTime(_SGT.getKioskTime(1), true))
      SGT_KioskTime_ReplacementBidCount:SetText(blue .. _addon.core.secsToTime(_SGT.getKioskTime(2), true))
    end

     _addon.core.kioskTimeUpdate(1000)
  end)
end

-- * Initialisierung
function _addon.core.initialized()
  shissuGT = shissuGT or {}

  shissuGT[_addon.Name] = shissuGT[_addon.Name] or _addon.settings
  _addon.settings = shissuGT[_addon.Name]

  if (shissuGT["ShissuColor"] ~= nil) then
    for i = 1, 5 do
      if (shissuGT["ShissuColor"]["c" .. i] ~= nil) then
        _addon.settings["c" .. i] = shissuGT["ShissuColor"]["c" .. i]
      end
    end

    _addon.core.showColors()
  end

  _addon.core.createSettingMenu()

  -- Mausclicks in den EditBoxen (MotD, Rest Standard) erlauben
  GUILD_HOME.motd.editBackdrop:SetDrawLayer(1)

  SGT_KioskTime_Version:SetText(_addon.fN .. " " .. _addon.Version)
  setDefaultColor(SGT_KioskTime_Line)

  local closeTeleportButton = WINDOW_MANAGER:CreateControl(SGT_KioskTime_Close, SGT_KioskTime, CT_TEXTURE)
  closeTeleportButton:SetAnchor(TOPLEFT, parent, TOPRIGHT, -35, 2)
  closeTeleportButton:SetDimensions(28, 28)
  closeTeleportButton:SetTexture("ESOUI/art/buttons/decline_up.dds")
  closeTeleportButton:SetMouseEnabled(true)
  closeTeleportButton:SetHandler("OnMouseEnter", function(self) self:SetColor(0.2705882490, 0.5725490451, 1, 1) end)
  closeTeleportButton:SetHandler("OnMouseExit", function(self) self:SetColor(1,1,1,1) end)
  closeTeleportButton:SetHandler("OnMouseUp", function(self)
    SGT_KioskTime:SetHidden(true)
    frameClose = 1
  end)

  if _addon.settings["kiosk"] then _addon.core.initKioskTimer() end
end

Shissu_SuiteManager._settings[_addon.Name] = {}
Shissu_SuiteManager._settings[_addon.Name].panel = _addon.panel
Shissu_SuiteManager._settings[_addon.Name].controls = _addon.controls
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized
