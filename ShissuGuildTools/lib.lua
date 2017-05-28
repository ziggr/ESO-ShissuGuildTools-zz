-- Shissu GuildTools Misc Functions
-----------------------------------
-- File: lib.lua
-- Version: v2.3.0
-- Last Update: 10.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!

local _globals = Shissu_SuiteManager._globals
local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]

local _lib2 = Shissu_SuiteManager._lib
local replaceCharacter = _lib2.ReplaceCharacter

local _lib = {}
_lib.name = "SGT"
_lib.hexColor = nil
_lib.colorPickerEnabled = false

-- General
function _lib.currentTime()
  local correction = GetSecondsSinceMidnight() - (GetTimeStamp() % 86400)
  if correction < -12*60*60 then correction = correction + 86400 end

  return GetTimeStamp() + correction
end

function _lib.getKioskTime(which, additional, day)     
  local hourSeconds = 60 * 60
  local daySeconds = 60 * 60 *24
  local weekSeconds = 7 * daySeconds
  local additional = additional or 0
  
  -- Erste Woche 1970 beginnt Donnerstag -> Verschiebung auf Gebotsende
  local firstWeek = 1 + (3 * daySeconds) + (20 * hourSeconds)

  local currentTime = _lib.currentTime()                                

  -- Anzahl der Wochen seit 01.01.1970
  local week = math.floor(currentTime / weekSeconds) + additional
  local beginnKiosk = firstWeek + (weekSeconds * week) + 60 * 60
  
  -- Gebots Ende 
  if (which == 1) then
    beginnKiosk = beginnKiosk - 300
  -- Ersatzhändler
  elseif (which == 2) then
    beginnKiosk = beginnKiosk + 300                                                     
  end
  
  -- Restliche Zeit in der Woche
  local restWeekTime = beginnKiosk - currentTime                            
  
  if (day) then
    restWeekTime = beginnKiosk
  end
  
  if restWeekTime < 0 then
    restWeekTime = restWeekTime + weekSeconds
  end

  return restWeekTime
end

function _lib.toChat(text)
  if text == nil then return end
  CHAT_SYSTEM:AddMessage(text)
end

function _lib.title(modulename)
  return blue .. "Shissu's|r" .. white .. " " .. modulename
end

function _lib.isStringEmpty(text)
  return text == nil or text == ''
end

function _lib.i18nC(_i18n)
  local _i18n = _i18n

  for k,v in pairs(_i18n) do
    _i18n[k] = _lib2.ReplaceCharacter(_i18n[k])
  end
  
  return _i18n
end

function _lib.getString(var)
  return replaceCharacter(GetString(var))
end

function _lib.getString2(addonName, var)
  return zo_strformat(GetString(addonName .. "_" .. var))
end

-- Mathematics
function _lib.round(number)
  local dec = number - math.floor(number)

   if dec > 0.5 then return math.ceil(number) 
   else return math.floor(number) end
end

function _lib.RGBtoHex(r,g,b)
  local rgb = {r*255, g*255, b*255}
  local hexstring = ""

  for key, value in pairs(rgb) do
    local hex = ""

    while (value > 0)do
      local index = math.fmod(value, 16) + 1
      value = math.floor(value / 16)
      hex = string.sub("0123456789ABCDEF", index, index) .. hex     
    end

    if(string.len(hex) == 0) then
      hex = "00"
    elseif(string.len(hex) == 1) then
      hex = "0" .. hex
    end

    hexstring = hexstring .. hex
  end

  return hexstring
end

-- Dialogboxes
function _lib.showDialog(dialogTitle, dialogText, callbackFunc, vars)
  ESO_Dialogs["SGT_DIALOG"].title = {text = dialogTitle,}
  ESO_Dialogs["SGT_DIALOG"].mainText = {text = dialogText,}
  ESO_Dialogs["SGT_DIALOG"].buttons[1].callback = callbackFunc

  ZO_Dialogs_ShowDialog("SGT_DIALOG", vars)
end

-- UI
function _lib.setDefaultColor(control) 
  if (control == nil) then return end
  control:SetColor(0.2705882490, 0.5725490451, 1, 1)  
end

function _lib.createZOButton(name, text, width, offsetX, offsetY, anchor)
  local button = CreateControlFromVirtual(name, anchor, "ZO_DefaultTextButton")
  button:SetText(text)
  button:SetAnchor(TOPLEFT, anchor, TOPLEFT, offsetX, offsetY)
  button:SetWidth(width)
   
  return button
end

function _lib.checkBoxLabel(control, var)
  local ESOIcons = {
    Online = GetPlayerStatusIcon(PLAYER_STATUS_ONLINE),
    Offline = GetPlayerStatusIcon(PLAYER_STATUS_OFFLINE),
    Aldmeri = GetAllianceSymbolIcon(ALLIANCE_ALDMERI_DOMINION),
    Ebonheart = GetAllianceSymbolIcon(ALLIANCE_EBONHEART_PACT),
    Daggerfall = GetAllianceSymbolIcon(ALLIANCE_DAGGERFALL_COVENANT),    
    Gold = "/esoui/art/guild/guild_tradinghouseaccess.dds",
    Item = "/esoui/art/guild/guild_bankaccess.dds",
  }
  
  ZO_CheckButton_SetChecked(control)
  ZO_CheckButton_SetLabelText(control, zo_iconFormat(ESOIcons[var], 24, 24))
end


function _lib.createLabel(name, anchor, text, dimension, offset, hidden, pos, font)
  if(not text) then text = "" end
  if(not dimension) or dimension == 0 then dimension = {100, 30} end
  if(not offset) then offset = {0, 0} end
  if (hidden == nil) then hidden = true end
  if(not pos) then pos = RIGHT end
  if(not font) then font = "ZoFontGame" end
  
  local control = WINDOW_MANAGER:CreateControl(name, anchor, CT_LABEL)
  
  control:SetFont(font)
  control:SetDimensions(dimension[1], dimension[2])
  control:SetAnchor(LEFT, anchor, pos, offset[1], offset[2])
  control:SetText(blue .. text)
  control:SetVerticalAlignment(LEFT)
  control:SetHidden(hidden)

  return control
end

function _lib.toolTip(control, text)
  if not _lib.isStringEmpty(text) then
    ZO_Tooltips_ShowTextTooltip(control, TOPRIGHT, white .. " " .. text)
  end
end

function _lib.createBlueLine(name, parent, parent2, offsetX, offsetY)   
  if offsetY ~= nil then offsetY = 0 end
  
  local control = WINDOW_MANAGER:CreateControl(name, parent, CT_TEXTURE)
  control:SetAnchor(TOPLEFT, parent2, TOPRIGHT, offsetX, offsetY)
  control:SetAnchor(BOTTOMLEFT, parent, BOTTOMLEFT, offsetX, offsetY)
  control:SetWidth(3)
  control:SetTexture("EsoUI\\Art\\Miscellaneous\\window_edge.dds")
  _lib.setDefaultColor(control)
  
  return control
end

function _lib.createScrollContainer(name, width, parent, parent2, offsetX, offsetY, offsetY2)
  local control = WINDOW_MANAGER:CreateControlFromVirtual(name, parent, "ZO_ScrollContainer")
  control:SetAnchor(TOPLEFT, parent2, BOTTOMLEFT, offsetX, offsetY)
  control:SetAnchor(BOTTOMLEFT, parent, BOTTOMLEFT, offsetX, offsetY2)
  control:SetWidth(width)
  control.scrollChild = control:GetNamedChild("ScrollChild")
  
  return control
end

function _lib.createCloseButton(name, parent, func)
  local control = WINDOW_MANAGER:CreateControl(name, parent, CT_TEXTURE)
  control:SetAnchor(TOPLEFT, parent, TOPRIGHT, -35, 2)
  control:SetDimensions(28, 28)
  control:SetTexture("ESOUI/art/buttons/decline_up.dds")
  control:SetMouseEnabled(true)
  control:SetHandler("OnMouseEnter", function(self) _lib.setDefaultColor(self) end)     
  control:SetHandler("OnMouseExit", function(self) self:SetColor(1,1,1,1) end)  
  control:SetHandler("OnMouseUp", func) 
  
  return control 
end

function _lib.saveWindowPosition(control, settings)
  control:SetHandler("OnReceiveDrag", function(self) self:StartMoving() end)
  control:SetHandler("OnMouseUp", function(self)
    self:StopMovingOrResizing()
    local _, point, _, relativePoint, offsetX, offsetY = self:GetAnchor()
    
    if settings == nil then settings = {} end

    settings.offsetX = offsetX
    settings.offsetY = offsetY
    settings.point = point
    settings.relativePoint = relativePoint
  end)
end

function _lib.getWindowPosition(control, settings)
  if settings == nil then return end

  control:ClearAnchors()
  control:SetAnchor(settings.point, parent, settings.relativePoint, settings.offsetX, settings.offsetY)
end

-- NEUES FENSTER DESIGN: FLAT
function _lib.createLine(name, dimensions, mainParent, mainParent2, anchorPos, anchorX, anchorY, anchor2, color, vert)
  local control = CreateControl(mainParent .. "_" .. name, mainParent2, CT_TEXTURE) 
  control:SetTexture("ShissuGuildTools/textures/horizontal.dds")
  control:SetAnchor(anchorPos, mainParent2, anchorPos, anchorX, anchorY)
  control:SetHidden(false) 
  
  if (anchor2 == nil) then
    control:SetDimensions(dimensions[1], dimensions[2])
  end
  
  if (anchor2) then
    control:SetAnchor(anchor2[1], mainParent2, anchor2[1], anchor2[2], anchor2[3])
    control:SetWidth(dimensions[2])
  end
  
  if (vert) then
    control:SetTexture("ShissuGuildTools/textures/vertikal.dds")
  end
  
  if (color) then
    control:SetColor(color[1], color[2], color[3], 1) 
  end
                                                                    
  return control
end

function _lib.createFlatWindow(mainParent, mainParent2, dimensions, closeFunc, title)
  dimensions[1] = dimensions[1] + 10
  
 	local background = CreateControl(mainParent .. "_Background", mainParent2, CT_TEXTURE)
	background:SetTexture("ShissuGuildTools/textures/background.dds")
	background:SetDimensions(dimensions[1], dimensions[2] + 10)  
	background:SetAnchor(TOPLEFT, nil, TOPLEFT, -10, -10)
	background:SetDrawLayer(DL_BACKGROUND)
	background:SetExcludeFromResizeToFitExtents(true)                  
  
  local blueTitle = CreateControl(mainParent .. "_TopLine", mainParent2, CT_TEXTURE)
	blueTitle:SetTexture("ShissuGuildTools/textures/blue.dds")
	blueTitle:SetDimensions(dimensions[1], 5)
	blueTitle:SetAnchor(TOPLEFT, nil, TOPLEFT, -10, -10)
	blueTitle:SetDrawLayer(DL_BACKGROUND)
	blueTitle:SetExcludeFromResizeToFitExtents(true)      

  if (closeFunc) then
    local closeButton = WINDOW_MANAGER:CreateControl(mainParent .. "_Close", mainParent2, CT_TEXTURE)
    closeButton:SetAnchor(TOPLEFT, background, TOPRIGHT, -45, 10)
    closeButton:SetDimensions(28, 28)
    closeButton:SetTexture("ShissuGuildTools/textures/close.dds")
    closeButton:SetMouseEnabled(true)
    closeButton:SetHandler("OnMouseEnter", function(self) 
      self:SetTexture("ShissuGuildTools/textures/close2.dds")
    end)     
    closeButton:SetHandler("OnMouseExit", function(self) 
      self:SetTexture("ShissuGuildTools/textures/close.dds")
    end)  
    
    closeButton:SetHandler("OnMouseUp", closeFunc)  
  end
  
  -- Rahmen
  local topLine = _lib.createLine("TopBorder", {dimensions[1], 1}, mainParent, mainParent2, TOPLEFT, -10, -10)
  local bottomLine = _lib.createLine("BottomBorder", {dimensions[1], 1}, mainParent, mainParent2, BOTTOMLEFT, -10, 0)
  local leftLine = _lib.createLine("LeftBorder", {dimensions[2], 1}, mainParent, mainParent2, TOPLEFT, -10, -10, {BOTTOMLEFT, -10, 0}, nil, true)
  local rightLine = _lib.createLine("RightBottom", {dimensions[2], 1}, mainParent, mainParent2, TOPRIGHT, -10, -10, {BOTTOMRIGHT, 0, 0}, nil, true)
  
  -- Titel
  local titleLine = _lib.createLine("TitleLine", {dimensions[1] - 40, 1}, mainParent, mainParent2, TOPLEFT, 8, 35, nil, {0.49019607901573, 0.74117648601532, 1})
  
  local titleLabel = WINDOW_MANAGER:CreateControl(mainParent .. "_Title", mainParent2, CT_LABEL)
  titleLabel:SetAnchor(TOPLEFT, mainParent2, TOPLEFT, 5, 0)
  titleLabel:SetDimensions(dimensions[1] - 40, 32)
  titleLabel:SetHidden(false)
  titleLabel:SetFont('SGT_LINEFONT')
  titleLabel:SetHorizontalAlignment(TEXT_ALIGN_LEFT) 
  titleLabel:SetText(title)
end

function _lib.createFlatButton(name, parent, parentPos, dimensions, text, parentAnchor, color)
  if parentAnchor == nil then parentAnchor = BOTTOMLEFT end 
  if color == nil then color = {0.49019607901573, 0.74117648601532, 1, 1} end
  
  local control = WINDOW_MANAGER:CreateControl(name, parent, CT_TEXTURE)
  control:SetAnchor(parentAnchor, parent, parentAnchor, parentPos[1], parentPos[2])
  control:SetDimensions(dimensions[1], dimensions[2])
  control:SetTexture("ShissuGuildTools/textures/button.dds")
  control:SetHidden(false)
  control:SetMouseEnabled(true)
  control:SetDrawLayer(1)
  
  control:SetHandler("OnMouseEnter", function(self) 
    self:SetColor(color[1], color[2], color[3], color[4] or 1)   
  end) 
  
  control:SetHandler("OnMouseExit", function(self) 
    self:SetColor(1, 1, 1, 1)   
  end) 
  
  control.label = WINDOW_MANAGER:CreateControl(name .. "_LABEL", parent, CT_LABEL)
  local label = control.label
  label:SetAnchor(parentAnchor, parent, parentAnchor, parentPos[1], parentPos[2]+4)
  label:SetDimensions(dimensions[1], dimensions[2])
  label:SetHidden(false)
  label:SetFont('SGT_BUTTONFONT')
  label:SetHorizontalAlignment(TEXT_ALIGN_CENTER) 
  label:SetText(text)
  label:SetColor(color[1], color[2], color[3], 1) 
  
  return control 
end

function _lib.createBackdropBackground(mainParent, mainParent2, dimensions, tex)
  if (tex == nil) then tex = "" end
  
  local control = CreateControl(mainParent .. "_BG", mainParent2, CT_TEXTURE)
	control:SetTexture("ShissuGuildTools/textures/backdrop" .. tex .. ".dds")
	control:SetDimensions(dimensions[1], dimensions[2])  
	control:SetAnchor(TOPLEFT, mainParent2, TOPLEFT, 0, 0)
	control:SetDrawLayer(1)
	--control:SetExcludeFromResizeToFitExtents(true)        
end

Shissu_SuiteManager._lib[_lib.name] = _lib