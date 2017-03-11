-- File: ShissuLib.lua
-- Zuletzt geändert: 15. August 2015

local ShissuGT_Lib = {}
ShissuGT_Lib.HexColor = nil

-- General
-- String leer?
function ShissuGT.Lib.IsStringEmpty(text)
  return text == nil or text == ''
end

function ShissuGT.Lib.TextToChat(text)
  if (not ShissuGT.Lib.IsStringEmpty(text)) then ZO_ChatWindowTextEntryEditBox:SetText(text) end
end

-- Contol SetColor Standard
function ShissuGT.Lib.SetStdColor(control)
  if control == nil then return end
  control:SetColor(0.2705882490, 0.5725490451, 1, 1) 
end

-- Blaue Schließen Button generieren
function ShissuGT.Lib.CreateCloseButton(name, parent, func)
  local control = WINDOW_MANAGER:CreateControl(name, parent, CT_TEXTURE)
  control:SetAnchor(TOPLEFT, parent, TOPRIGHT, -35, 2)
  control:SetDimensions(28, 28)
  control:SetTexture("ESOUI/art/buttons/decline_up.dds")
  control:SetMouseEnabled(true)
  control:SetHandler("OnMouseEnter", function(self) ShissuGT.Lib.SetStdColor(self) end)     
  control:SetHandler("OnMouseExit", function(self) self:SetColor(1,1,1,1) end)  
  control:SetHandler("OnMouseUp", func) 
  
  return control 
end

-- Blaue Trennlinie 
function ShissuGT.Lib.CreateBlueLine(name, parent, parent2, offsetX, offsetY)   
  if offsetY ~= nil then offsetY = 0 end
  
  local control = WINDOW_MANAGER:CreateControl(name, parent, CT_TEXTURE)
  control:SetAnchor(TOPLEFT, parent2, TOPRIGHT, offsetX, offsetY)
  control:SetAnchor(BOTTOMLEFT, parent, BOTTOMLEFT, offsetX, offsetY)
  control:SetWidth(3)
  control:SetTexture("EsoUI\\Art\\Miscellaneous\\window_edge.dds")
  ShissuGT.Lib.SetStdColor(control)
  
  return control
end

-- Version Info in den einzelnen Fenster
function ShissuGT.Lib.SetVersionUI(control)
  control:SetText(ShissuGT.ColoredName .. " " .. ShissuGT.Version)
end

function ShissuGT.Lib.SetSGTTitle(control, text)
  control:SetText(ShissuGT.Color[6] .. "SGT " .. ShissuGT.Color[5] .. text) 
end

-- Scrolllisten
function ShissuGT.Lib.CreateUIList(name, width, parent, parent2, offsetX, offsetY, offsetY2)
  local control = WINDOW_MANAGER:CreateControlFromVirtual(name, parent, "ZO_ScrollContainer")
  control:SetAnchor(TOPLEFT, parent2, BOTTOMLEFT, offsetX, offsetY)
  control:SetAnchor(BOTTOMLEFT, parent, BOTTOMLEFT, offsetX, offsetY2)
  control:SetWidth(width)
  control.scrollChild = control:GetNamedChild("ScrollChild")
  
  return control
end

-- ESO Language Strings abschneiden
function ShissuGT.Lib.CutStringAtLetter(text, letter)
  if not ShissuGT.Lib.IsStringEmpty(text) then
    local pos = string.find(text, letter, nil, true)
      
    if pos then text = string.sub (text, 1, pos-1) end
  end
  
  return text;
end

function ShissuGT.Lib.GetCharInfoIcon(charInfoVar, text, class)
  if charInfoVar then
    local icon = nil
    
    if class then icon = GetClassIcon(charInfoVar)
    else icon = GetAllianceBannerIcon(charInfoVar) end
    
    if icon then return "|t28:28:" .. icon .. "|t" .. text end
  end
  
  return text
end

function ShissuGT.Lib.GetCharLevel(charInfoVar)
  -- if charInfoVar.vet == 0 then 
    return ShissuGT.Color[5] .. " (".. ShissuGT.Color[6] .. "LvL " .. ShissuGT.Color[5] .. charInfoVar.lvl .. ")"
 -- end
  
  --return ShissuGT.Color[5] .. " (".. ShissuGT.Color[6] .. "VR " .. ShissuGT.Color[5] .. charInfoVar.vet .. ")"
end

-- COLORPICKER
ShissuGT.Lib.HexColor = nil
ShissuGT.Lib.ColorPickerActive = false

-- Modifizierte Bestätigungsfunktion
function ZO_ColorPicker:Confirm()
  ZO_Dialogs_ReleaseDialog("COLOR_PICKER")
  
  if ShissuGT.Lib.ColorPickerActive == true then
    ShissuGT.Lib.HexColor = ShissuGT_Lib.HexColor
    ShissuGT.Lib.ColorPickerActive = false
  end
end

-- Color-Auswahlfenster
function ShissuGT.Lib.ColorPicker()
 ShissuGT.Lib.ColorPickerActive = true
 
 COLOR_PICKER:Show(function(r,g,b) 
  ShissuGT_Lib.HexColor = ShissuGT.Lib.RGBtoHex(r,g,b)
 end) 
end

-- RGB Colors in einen HTML-String umwandeln
function ShissuGT.Lib.RGBtoHex(r,g,b)
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

function ShissuGT.Lib.GetTime()
  if ShissuGT.Settings.Color.Time then
    if ShissuGT.Settings.Color.Time[1] and ShissuGT.Settings.Color.Time[2] and ShissuGT.Settings.Color.Time[3] then
      return "|c" .. ShissuGT.Lib.RGBtoHex(ShissuGT.Settings.Color.Time[1], ShissuGT.Settings.Color.Time[2],ShissuGT.Settings.Color.Time[3]) .. "["..GetTimeString().."]|r "
    end
  end
  
  return "["..GetTimeString().."]"
end

function ShissuGT.Lib.SetUserColor(var)
  if ShissuGT.Settings.Color[var] then
    ShissuGT.userColor[var] = "|c" .. ShissuGT.Lib.RGBtoHex(ShissuGT.Settings.Color[var][1], ShissuGT.Settings.Color[var][2], ShissuGT.Settings.Color[var][3])
  end    
end

-- SGT_DIALOG
function ShissuGT.Lib.ShowDialog(dialogTitle, dialogText, callbackFunc, vars)
  ESO_Dialogs["SGT_DIALOG"].title = {text = dialogTitle,}
  ESO_Dialogs["SGT_DIALOG"].mainText = {text = dialogText,}
  ESO_Dialogs["SGT_DIALOG"].buttons[1].callback = callbackFunc

  ZO_Dialogs_ShowDialog("SGT_DIALOG", vars)
end

-- Sekunden in die Form: XXX Tage XX Stunden umrechnen
function ShissuGT.Lib.SecsToTime(time, complete)
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

-- Zahlen auf, und abrunden
function ShissuGT.Lib.Round(number)
  local dec = number - math.floor(number)

   if dec > 0.5 then return math.ceil(number) 
   else return math.floor(number) end
end

-- Sonderzeichen ersetzen
function ShissuGT.Lib.ReplaceCharacter(text)
  local specialCharacter = {
    ["à"] = "\195\160",  ["ò"] = "\195\178",  ["è"] = "\195\168",  ["ì"] = "\195\172",  ["ù"] = "\195\185",
    ["á"] = "\195\161",  ["ó"] = "\195\179",  ["é"] = "\195\169",  ["í"] = "\195\173",  ["ú"] = "\195\186",
    ["â"] = "\195\162",  ["ô"] = "\195\180",  ["ê"] = "\195\170",  ["î"] = "\195\174",  ["û"] = "\195\187",
    ["ã"] = "\195\163",  ["õ"] = "\195\181",  ["ë"] = "\195\171",  ["ï"] = "\195\175",  ["ü"] = "\195\188",
    ["ä"] = "\195\164",  ["ö"] = "\195\182",
    ["Ä"] = "\195\132",  ["Ö"] = "\195\150",                                            ["Ü"] = "\195\156",
    
    ["ß"] = "\195\159",
  }

  for char, newChar in pairs(specialCharacter) do 
    text = string.gsub(text, char, newChar) 
  end

  return text;
end

-- String an String teilen, und die einzelnen Teile wieder in ein Array packen
function ShissuGT.Lib.SplitToArray (search, text)
  if (text=='') then return false end
  
  local pos,arr = 0,{}
  
  for st,sp in function() return string.find(search,text,pos,true) end do
    table.insert(arr, string.sub(search,pos,st-1))
    pos = sp + 1
  end
  
  table.insert(arr,string.sub(search,pos))
  
  return arr
end

-- Verschobene ID's aufgrund von Gilden - Verlassen / Beitreten etc... korrekt wiedergeben
function ShissuGT.Lib.GuildID(guildId)
  local numGuilds = GetNumGuilds()
 
  for i = 1, numGuilds do
    local guildID = GetGuildId(i)
      
    if guildId == guildID then 
      return i
    end
    
  end
end

-- Settings
-- Einstellung aktiviert?
function ShissuGT.Lib.CheckSingleVar(guildId, VarName)
  if guildId > 5 then guildId = ShissuGT.Lib.GuildID(guildId) end
  if ShissuGT.Settings["Guild"..guildId][VarName] == true then return true end
  return false
end  

-- Einstellung bei irgendeiner Gilde aktiviert?
function ShissuGT.Lib.CheckVars(VarName) 
   for i = 1, GetNumGuilds() do
      if ShissuGT.Settings["Guild"..tostring(i)][VarName] == true then return true end
   end
   return false
end 

-- Einstellung aktiviert?
function ShissuGT.Lib.CheckVarsingle(VarsName1,VarsName2)   
   if ShissuGT.Settings[VarsName1][VarsName2] == true then return true end
   return false
end 

function ShissuGT.Lib.ReturnVarSingle(VarsName1,VarsName2) 
   return ShissuGT.Settings[VarsName1][VarsName2]
end 


-- Funktionen deaktivieren, falls in den Einstellung vollständig ausgeschaltet
function ShissuGT.Lib.TurnOffUnnecessaryEvents()
   if ShissuGT.Lib.CheckVars("MemberStatus") == false then EVENT_MANAGER:UnregisterForEvent(ShissuGT.Name, EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED) end   
   if ShissuGT.Lib.CheckVars("GuildMotD") == false then EVENT_MANAGER:UnregisterForEvent(ShissuGT.Name, EVENT_GUILD_MOTD_CHANGED) end   
   if ShissuGT.Lib.CheckVars("MemberInSight") == false then EVENT_MANAGER:UnregisterForEvent(ShissuGT.Name, EVENT_RETICLE_TARGET_CHANGED) end  
   if ShissuGT.Lib.CheckVars("AddStatus") == false then EVENT_MANAGER:UnregisterForEvent(ShissuGT.Name, EVENT_GUILD_MEMBER_ADDED) end   
   if ShissuGT.Lib.CheckVars("RemoveStatus") == false then EVENT_MANAGER:UnregisterForEvent(ShissuGT.Name, EVENT_GUILD_MEMBER_REMOVED) end 
end

-- Tools
-- Uhrzeit wiedergeben, falls Setting aktiv
function ShissuGT.Lib.TimeInChat()
   if ShissuGT.Settings.TimeInChat == true then return ShissuGT.Lib.GetTime() end
   return ("")  
end

-- CHAT FUNCTIONS                  
function ShissuGT.Lib.ChatText(guildId, AccName, Text)
   return ShissuGT.Lib.TimeInChat().. ShissuGT.Color[6] ..GetGuildName(guildId)..": " .. ShissuGT.Color[5] ..AccName.." - |r"..Text
end

-- UI
-- Fensterpositionen je nach Settings setzen
function ShissuGT.Lib.SetWindowPos(control, settingVar)
  local save = ShissuGT.Settings[settingVar]

  if control == nil and save == nil then return false end

  if ShissuGT.Settings[settingVar].Enabled or ShissuGT.Lib.CheckVars(settingVar) then
    control:ClearAnchors()
    control:SetAnchor(save.point, GuiRoot, save.relativePoint, save.offsetX, save.offsetY)    
  end
end

function ShissuGT.Lib.SetWindowPosDouble(control, settingVar, settingVar2)
  local save = ShissuGT.Settings[settingVar][settingVar2]

  if control == nil and save == nil then return false end

  if ShissuGT.Settings[settingVar].Enabled or ShissuGT.Lib.CheckVars(settingVar) then
    control:ClearAnchors()
    control:SetAnchor(save.point, GuiRoot, save.relativePoint, save.offsetX, save.offsetY)    
  end
end

function ShissuGT.Lib.SetWindowPos_NotebookSplash()
  if ShissuGT.Settings.Notebook.Enabled and  ShissuGT.Settings.Notebook.EMail then
    local offsetX = ShissuGT.Settings.Notebook.Splash.offsetX
    local offsetY = ShissuGT.Settings.Notebook.Splash.offsetY  
    
    ShissuGT_Notebook_Splash:ClearAnchors()
    ShissuGT_Notebook_Splash:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, offsetX, offsetY)    
  end
end

-- CheckBoxen aktivieren + entsprechende ICON's zuweisen
function ShissuGT.Lib.CheckBox(control, var)
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
  ZO_CheckButton_SetLabelText(control, zo_iconFormat(ESOIcons[var],24, 24))
end

-- ToolTip anzeigen
function ShissuGT.Lib.ToolTip(control, text)
  if not ShissuGT.Lib.IsStringEmpty(text) then
    ZO_Tooltips_ShowTextTooltip(control, TOPRIGHT, ShissuGT.Color[5] .. ShissuGT.Lib.ReplaceCharacter(text))
  end
end

-- ToolTip zuordnen
function ShissuGT.Lib.SetToolTip(control, var1, var2)
  control:SetHandler("OnMouseEnter", function(self)
    ShissuGT.Lib.ToolTip(self, ShissuGT.i18n[var1][var2])
  end)
end

-- ToolTip verschwinden lassen
function ShissuGT.Lib.HideToolTip(control)
  control:SetHandler("OnMouseExit", function(self)
    ZO_Tooltips_HideTextTooltip()
  end)
end
--/script ZO_GuildRosterHeadersZone:SetAnchor(TOPLEFT, ZO_GuildRosterHeadersDisplayName, TOPRIGHT,60)
-- ZO UI Button
function ShissuGT.Lib.CreateZOButton(name, text, width, offsetX, offsetY, anchor)
  local button = CreateControlFromVirtual(name, anchor, "ZO_DefaultTextButton")
  button:SetText(ShissuGT.Color[6].. text)
  button:SetAnchor(TOPLEFT, anchor, TOPLEFT, offsetX, offsetY)
  button:SetWidth(width)
   
  return button
end

function ShissuGT.Lib.CreateLabel(name, anchor, text, dimension, offset, hidden, pos, font)
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
  control:SetText(ShissuGT.Color[6] .. text)
  control:SetVerticalAlignment(LEFT)
  control:SetHidden(hidden)

  return control
end

