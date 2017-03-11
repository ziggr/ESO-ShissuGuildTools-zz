-- Shissu GuildTools Module File
--------------------------------
-- File: roster.lua
-- Version: v1.3.13
-- Last Update: 09.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!

local _globals = Shissu_SuiteManager._globals
local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]
local green = _globals["color"]["green"]
local red = _globals["color"]["red"]

local zos = _globals["ZOS"]

local _lib = Shissu_SuiteManager._lib
local _SGT = Shissu_SuiteManager._lib["SGT"]
local RGBtoHex = _SGT.RGBtoHex
local _setPanel = _lib.setPanel
local getString = _SGT.getString
local createZOButton = _SGT.createZOButton
local checkBoxLabel = _SGT.checkBoxLabel
local round = _SGT.round

local _addon = {}
_addon.Name	= "ShissuRoster"
_addon.Version = "1.3.13"
_addon.core = {}
_addon.fN = _SGT["title"](getString(ShissuRoster))

_addon.buttons = {}

_addon.core.userColor1 = white
_addon.core.userColor2 = white
_addon.core.userColor3 = white
_addon.core.userColor4 = white
_addon.core.userColor5 = white
_addon.core.userColorW = white

_addon.panel = _setPanel(getString(ShissuRoster), _addon.fN, _addon.Version)
_addon.controls = {}

local _roster = {}
local _memberChars = {}
local _personalNote = {}
local _history = {}

local _filter = {
  gold = 0,
  goldDir = 1;
  Daggerfall = true,
  Ebonheart = true,
  Aldmeri = true,
  offlineSince = 0;
  Offline = true;
  Online = true;
  rang = "";
}

_addon.settings = {
  ["gold"] = getString(ShissuRoster_total),
  ["colGold"] = true,
  ["colChar"] = true,
  ["colNote"] = true,
}

local org_ZO_KeyboardGuildRosterRowDisplayName_OnMouseEnter = ZO_KeyboardGuildRosterRowDisplayName_OnMouseEnter
local org_ZO_KeyboardGuildRosterRowDisplayName_OnMouseExit = ZO_KeyboardGuildRosterRowDisplayName_OnMouseExit
 
function _addon.core.createSettingMenu()
  local controls = Shissu_SuiteManager._settings[_addon.Name].controls

  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuRoster_colAdd),
  }
  
  controls[#controls+1] = {
    type = "description",
    name = getString(ShissuRoster_colAdd2) .. blue .. "\n\reloadui",
  }  
                                          
  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuRoster_colChar),
    getFunc = _addon.settings["colChar"],
    setFunc = function(_, value)
      _addon.settings["colChar"] = value
      Shissu_SuiteManager._bindings.reload()
    end,
  } 
  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuRoster_colGold),
    getFunc = _addon.settings["colGold"],
    setFunc = function(_, value)
      _addon.settings["colGold"] = value
      Shissu_SuiteManager._bindings.reload()
    end,
  } 
  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuRoster_colNote),
    getFunc = _addon.settings["colNote"],
    setFunc = function(_, value)
      _addon.settings["colNote"] = value
      Shissu_SuiteManager._bindings.reload()
    end,
  } 
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

function _addon.core.createButton(name, var, offsetX, offsetY, parent) 
  local button = CreateControlFromVirtual(name, ZO_GuildRoster, "ZO_CheckButton")
  button:SetAnchor(TOPLEFT, parent, TOPLEFT, offsetX, offsetY)
  
  checkBoxLabel(button, var)
  
  ZO_CheckButton_SetToggleFunction(button, function(control, checked)
    _filter[var] = checked
    
    _roster.refreshFilters()
  end)
  
  --ShissuGT.Lib.SetToolTip(button, "Roster", var)
  ZO_Tooltips_HideTextTooltip()
   
  return button
end

function _addon.core.anchorSet(R_offsetY, S_offsetX, S_offsetY)
  ZO_GuildRoster:SetAnchor(8,GUIROOT,8,0, R_offsetY)   
  ZO_GuildRosterSearch:SetAnchor(TOPRIGHT,ZO_GuildRoster,TOPRIGHT, S_offsetX, S_offsetY)   
end

function _addon.core.createLabel(name, anchor, text, dimension, offset, hidden, pos, font)
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
          
function _addon.core.goldFilter()
  ESO_Dialogs["SGT_EDIT"].title = {text = "Gold?",}
  ESO_Dialogs["SGT_EDIT"].mainText = {text = "Gold ?",}  
  ESO_Dialogs["SGT_EDIT"].buttons[1] = {text = "OK",}     
  ESO_Dialogs["SGT_EDIT"].buttons[1].callback = function(dialog) 
    local gold = dialog:GetNamedChild("EditBox"):GetText()
    gold = tonumber(gold)
    local direct = ">"
          
    if (gold ~= nil) then
      if (type(gold) == "number") then
        if (_filter.goldDir == 0) then
          direct = "<"
        end

        SGT_Roster_GoldDeposit:SetText(white .. "Gold eingezahlt " .. direct .. blue .. " " .. gold)
        _filter.gold = gold
        _roster.refreshFilters()
      end
    end
  end

  ZO_Dialogs_ShowDialog("SGT_EDIT")
end

function _addon.core.offlineFilter()
  ESO_Dialogs["SGT_EDIT"].title = {text = getString(ShissuNotebookMail_offlineSince),}
  ESO_Dialogs["SGT_EDIT"].mainText = {text = getString(ShissuNotebookMail_days) .. "?",}  
  ESO_Dialogs["SGT_EDIT"].buttons[1] = {text = "OK",}     
  ESO_Dialogs["SGT_EDIT"].buttons[1].callback = function(dialog) 
    local days = dialog:GetNamedChild("EditBox"):GetText()
    days = tonumber(days)
      
    if (days ~= nil) then
      if (type(days) == "number") then
        SGT_Roster_OfflineSince:SetText(blue .. "Offline" .. white .. ": " .. days .. " " .. getString(ShissuNotebookMail_days))
        _filter.offlineSince = days
        _roster.refreshFilters()
      end
    end
  end

  ZO_Dialogs_ShowDialog("SGT_EDIT")
end

function _roster.filterScrollList(self)
  local searchTerm = self.searchBox:GetText()
  local scrollData = ZO_ScrollList_GetDataList(self.list)
  local masterList = GUILD_ROSTER_MANAGER:GetMasterList()

  local GuildInfo = { 
    Max = 0,
    Choice = 0,
    Aldmeri = 0,
    Daggerfall = 0,
    Ebonheart = 0,                                                         
  }

  ZO_ClearNumericallyIndexedTable(scrollData)

  for i = 1, #masterList do
    local data = masterList[i]  
    local goldDeposit = 0
             
    -- Alle vorhandenen Characternamen, die man gesehen hat hinzufügen + 
    _memberChars[data.displayName] = _memberChars[data.displayName] or {}
    local memberChars = _memberChars[data.displayName]
    
    -- Charaktername weis färben, falls noch nicht geschehen
    if (string.find( data.characterName , "|c" )) == nil then
      data.characterName = white .. data.characterName
    end
    
    -- Nur Charaktername hinzufügen falls noch nicht vorhanden, oder bei einer Änderug
    local saveName = data.characterName
     
    if (string.find( saveName, "|ceeeeee" )) then
      saveName = string.gsub(saveName, "|ceeeeee", "")
    end
    
    if memberChars[saveName] ~= nil then
      if memberChars[saveName]["lvl"] ~= data.level or
        memberChars[saveName]["vet"] ~= data.veteranRank or
        memberChars[saveName]["class"] ~= data.class or
        memberChars[saveName]["alliance"] ~= data.alliance then
        memberChars[saveName] = { ["lvl"] = data.level, ["vet"] = data.veteranRank, ["class"] = data.class, ["alliance"] = data.alliance }  
      end  
    else
      memberChars[saveName] = { ["lvl"] = data.level, ["vet"] = data.veteranRank, ["class"] = data.class, ["alliance"] = data.alliance }  
    end

    -- Filtern der Daten
    local PlayerTime = math.floor(data.secsSinceLogoff / 86400)                                                    
       
    GuildInfo.Max = GuildInfo.Max + 1
      
    if data.alliance == 1 then GuildInfo.Aldmeri = GuildInfo.Aldmeri + 1
    elseif data.alliance == 2 then GuildInfo.Ebonheart = GuildInfo.Ebonheart + 1
    elseif data.alliance == 3 then GuildInfo.Daggerfall = GuildInfo.Daggerfall + 1 end

    if(searchTerm == "" 
      or string.find(string.lower(data.formattedZone), string.lower(searchTerm), 1) 
      or string.find(string.lower(data.note), string.lower(searchTerm), 1) 
      or string.find(string.lower(data.AllianceName), string.lower(searchTerm), 1) 
      or string.find(data.level, searchTerm) 
      or GUILD_ROSTER_MANAGER:IsMatch(searchTerm, data)) then
      
      local guildId = GUILD_SELECTOR.guildId
      local guildName = GetGuildName(guildId)
      
      if _history[guildName] ~= nil then
        if _history[guildName][data.displayName] ~= nil then
          if _history[guildName][data.displayName][zos["GoldAdded"]] ~= nil then
            goldDeposit = _history[guildName][data.displayName][zos["GoldAdded"]].total                                
          end
        end
      end 
      
      if goldDeposit >= _filter.gold then
        if _filter.rang == "" or _filter.rang == getString(ShissuNotebookMail_all)
        or _filter.rang == GetFinalGuildRankName(guildId, data.rankIndex) then 
          if (_filter.Aldmeri == true and data.alliance == 1) or (_filter.Ebonheart == true and data.alliance == 2) or (_filter.Daggerfall == true and data.alliance == 3)then                                               
            if _filter.Online and (data.status ==1 or data.status ==2 or data.status ==3) then
              GuildInfo.Choice = GuildInfo.Choice +1
              table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
            elseif _filter.Offline and PlayerTime >= _filter.offlineSince then 
              table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
              GuildInfo.Choice = GuildInfo.Choice +1
            end
          end
        end      
      end   
    end
  end
  _roster.setRank(_roster.rank)
  -- Anzeige der prozentuallen Verteilungen
  local Proc = {
    Aldmeri = round (GuildInfo.Aldmeri / GuildInfo.Max *100),
    Ebonheart = round(GuildInfo.Ebonheart / GuildInfo.Max *100),
    Daggerfall = round (GuildInfo.Daggerfall / GuildInfo.Max *100),
    Choice = round (GuildInfo.Choice / GuildInfo.Max *100),
  }
  
  SGT_Roster_AldmeriInGuild:SetText( white .. Proc.Aldmeri .. blue .. "%" )
  SGT_Roster_EbonheartInGuild:SetText(white .. Proc.Ebonheart .. blue .. "%"  )
  SGT_Roster_DaggerfallInGuild:SetText( white .. Proc.Daggerfall .. blue .. "%"  )
  SGT_Roster_Choice:SetText (white .. getString(ShissuNotebookMail_choice) .. ": " .. blue .. GuildInfo.Choice .. "/" .. white .. GuildInfo.Max .. white .. " (" .. blue .. Proc.Choice .. white .. "%)")
end
   
function _roster.setRank(control)
  local guildId = GUILD_SELECTOR.guildId
  
  if control ~= nil then 
    control:ClearItems()
    control:AddItem(_roster.rank:CreateItemEntry(blue .. "-- " .. white .. getString(ShissuNotebookMail_all2), _roster.selectRank))
    
    for rankIndex = 1, GetNumGuildRanks(guildId) do
      control:AddItem(control:CreateItemEntry(GetFinalGuildRankName(guildId, rankIndex), _roster.selectRank))
    end
    
    control:SetSelectedItem(_filter.rang)
    
    if (_filter.rang == "") then
      control:SetSelectedItem(blue .. "-- " .. white .. getString(ShissuNotebookMail_all2))
    end
  end
end

function _roster.selectRank(_, statusText)
  _filter.rang = statusText
  
  if (statusText == (blue .. "-- " .. white .. getString(ShissuNotebookMail_all2))) then
    _filter.rang = ""
  end
  
  _roster.refreshFilters()
end
   
function _roster.selectGold(_, statusText)
  _addon.settings["gold"] = statusText
  _roster.refreshFilters()
  _roster.GoldDeposit:SetText(white .. getString(ShissuRoster_sum) .. ": " .. blue .. _roster.getTotalGold())
end
                           
function _addon.core.buildTooltip(guildName, displayName, tooltip, saveVar, titleText)
  local gold = "|t24:24:EsoUI/Art/Guild/guild_tradinghouseaccess.dds|t"
  local timeStamp = GetTimeStamp()
  
  if saveVar == zos["ItemAdded"] or saveVar == zos["ItemRemoved"] then gold = "" end
  
  if _history[guildName] ~= nil then
    if _history[guildName][displayName] ~= nil then
  
      if _history[guildName][displayName][saveVar].last ~= 0 or
        _history[guildName][displayName][saveVar].currentNPC ~= 0 or
        _history[guildName][displayName][saveVar].previousNPC ~= 0 or
        _history[guildName][displayName][saveVar].total ~= 0 then
        
        if (tooltip ~= blue .. displayName .. white .. "\n") then
          tooltip = tooltip .. "\n\n" .. titleText .. "\n" .. white
        else
          tooltip = tooltip .. titleText .. "\n" .. white
        end
      end  
    
      if _history[guildName][displayName][saveVar].currentNPC ~= 0 then  
        tooltip = tooltip .. getString(ShissuRoster_thisWeek) .. ": " .. _history[guildName][displayName][saveVar].currentNPC .. gold
        .. "\n"  
      end
            
      if _history[guildName][displayName][saveVar].previousNPC ~= 0 then  
        tooltip = tooltip .. getString(ShissuRoster_lastWeek) .. ": " .. _history[guildName][displayName][saveVar].previousNPC .. gold 
        .. "\n"  
      end
             
      if _history[guildName][displayName][saveVar].last ~= 0 then  
        timeData = _history[guildName][displayName][saveVar].timeLast
        
        tooltip = tooltip .. getString(ShissuRoster_last) .. ": " .. _history[guildName][displayName][saveVar].last .. gold
        .. " (" .. getString(ShissuRoster_before) .. " " .. _addon.core.secsToTime(timeStamp - timeData) .. ")" .. "[" .. GetDateStringFromTimestamp(timeData) .. "]"
        .. "\n"  
      end
            
      if _history[guildName][displayName][saveVar].total ~= 0 then    
        tooltip = tooltip .. getString(ShissuRoster_total) .. ": " .. _history[guildName][displayName][saveVar].total .. gold
        .. " (in " .. _addon.core.secsToTime(timeStamp - _history[guildName]["oldestEvent"][zos["Bank"]]) .. ")"    
      end
    end
  end
    
  return tooltip
end                       

function _addon.core.currentTime()
  local correction = GetSecondsSinceMidnight() - (GetTimeStamp() % 86400)
  if correction < -12*60*60 then correction = correction + 86400 end

  return GetTimeStamp() + correction
end

function _addon.core.getDay()
  local hourSeconds = 60 * 60
  local daySeconds = 60 * 60 *24
  
  -- Erste Woche 1970 beginnt Donnerstag -> Verschiebung auf Gebotsende
  local firstWeek = 1 + (3 * daySeconds) + (20 * hourSeconds)

  local currentTime = _addon.core.currentTime()                                     

  -- Anzahl der Tage seit 01.01.1970
  local day = math.floor(currentTime / daySeconds)
                                 
  -- Beginn des Tages
  local restWeekTime = day * daySeconds

  return restWeekTime
end
        
    
function _roster.getTotalGold()
  local guildId = GUILD_SELECTOR.guildId
  if guildId == nil then return "" end
  
  local guildName = GetGuildName(guildId)

  local numMember = GetNumGuildMembers(guildId)
  local goldDeposit = 0
    
  for memberId = 1, numMember, 1 do
    local memberData = { GetGuildMemberInfo(guildId, memberId) }
    local displayName = memberData[1]            

    if _history[guildName] ~= nil then
      if _history[guildName][displayName] ~= nil then
      
        -- Heute
        if (_addon.settings["gold"] == getString(ShissuRoster_today)) then  
          if ( _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].timeLast > _addon.core.getDay()) then
            goldDeposit = goldDeposit + _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].last
          end
        -- Gestern
        elseif (_addon.settings["gold"] == getString(ShissuRoster_yesterday)) then
          if ( _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].timeLast > (_addon.core.getDay() - 86400) and 
               _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].timeLast < _addon.core.getDay()) then
            goldDeposit = goldDeposit + _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].last
          end
        -- Zuletzt            
        elseif (_addon.settings["gold"] == getString(ShissuRoster_last)) then
          goldDeposit = goldDeposit + _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].last
        -- seit Gildenhändler
        elseif (_addon.settings["gold"] == getString(ShissuRoster_sinceKiosk)) then     
          goldDeposit = goldDeposit + _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].currentNPC       
        -- Letzte Woche
        elseif (_addon.settings["gold"] == getString(ShissuRoster_lastWeek)) then
          goldDeposit = goldDeposit + _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].previousNPC  
        -- Gesamt     
        else
          goldDeposit = goldDeposit + _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].total      
        end
      end
    end
  end
  
  
  goldDeposit = ZO_LocalizeDecimalNumber(goldDeposit or 0)
  
  return goldDeposit
end
                   
function _addon.core.getCharInfoIcon(charInfoVar, text, class)
  if charInfoVar then
    local icon = nil
    
    if class then icon = GetClassIcon(charInfoVar)
    else icon = GetAllianceBannerIcon(charInfoVar) end
    
    if icon then return "|t28:28:" .. icon .. "|t" .. text end
  end
  
  return text
end    
    
function _addon.core.newCharName(charName, charInfo)
  charName = charName .. white .. " (".. blue .. "LvL " .. white .. charInfo.lvl .. ")"
  charName = _addon.core.getCharInfoIcon(charInfo.class, charName, true)
  charName = _addon.core.getCharInfoIcon(charInfo.alliance, charName)
 
  return charName 
end

function _addon.core.createZOButton(name, text, width, offsetX, offsetY, anchor, control)
  local button = CreateControlFromVirtual(name, anchor, "ZO_DefaultTextButton")
  local editbox = ZO_EditNoteDialogNoteEdit
  local buttonlabel = "SGT_GuildColor_Note"

  button:SetText(text)
  button:SetAnchor(TOPLEFT, anchor, TOPLEFT, offsetX, offsetY)
  button:SetWidth(width)
  
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
  
    editbox:SetText(cache .. _addon.core["userColor" .. colorString] .. getString(Shissu_yourText) .. "|r") 
  end)
   
  return button
end

function _addon.core.rosterUI()
  -- SaveVariables
  shissuGT.MemberChars = shissuGT.MemberChars or {}
  _memberChars = shissuGT.MemberChars
                          
  shissuGT.PersonalNote = shissuGT.PersonalNote or {}
  _personalNote = shissuGT.PersonalNote
  
  shissuGT.History = shissuGT.History or {}
  _history = shissuGT.History
  
  -- Fenster formatieren & Objekte erstellen
  local SearchLabel = blue .. ZO_GuildRosterSearchLabel:GetText()  
  ZO_GuildRosterSearchLabel:SetText(SearchLabel)  
  ZO_GuildRosterSearch:SetWidth(200)  
  
  _addon.core.anchorSet(55,-320,7)

  GUILD_ROSTER_KEYBOARD.FilterScrollList = _roster.filterScrollList

  -- Allianzen
  _roster.AllianceLabel = createZOButton("SGT_Roster_AllianceLabel", blue .. getString(Shissu_alliance), 150, 180, -2 , ZO_GuildRosterSearchLabel)                                                                          
  _roster.Aldmeri = _addon.core.createButton("SGT_Roster_Aldmeri","Aldmeri", 50, 30, SGT_Roster_AllianceLabel)  
  _roster.AldmeriInGuild = createZOButton("SGT_Roster_AldmeriInGuild", "", 50, 35, -5, SGT_Roster_Aldmeri)  
  
  _roster.Ebonheart = _addon.core.createButton("SGT_Roster_Ebonheart","Ebonheart", 90, 0, SGT_Roster_Aldmeri)
  _roster.EbonheartInGuild = createZOButton("SGT_Roster_EbonheartInGuild", "", 50, 35, -5, SGT_Roster_Ebonheart)
  _roster.Daggerfall = _addon.core.createButton("SGT_Roster_Daggerfall","Daggerfall", 90, 0, SGT_Roster_Ebonheart)  
  _roster.DaggerfallInGuild = createZOButton("SGT_Roster_DaggerfallInGuild", "", 50, 35, -5, SGT_Roster_Daggerfall)

  -- Info Status Label  
  _roster.StatusLabel = createZOButton("SGT_Roster_StatusLabel","Status:", 100, -380 , 50, ZO_GuildRosterSearchLabel)
  _roster.Online = _addon.core.createButton("SGT_Roster_Online","Online", 100, 5, SGT_Roster_StatusLabel)                        
  _roster.Offline = _addon.core.createButton("SGT_Roster_Offline","Offline", 50, 0, SGT_Roster_Online) 
  
  -- Button Offline seit...
  _roster.OfflineSince = createZOButton("SGT_Roster_OfflineSince", blue .. getString(ShissuNotebookMail_offlineSince) .. ": ".. white .. "0 " .. getString(ShissuNotebookMail_days), 200, 20, -5, SGT_Roster_Offline)
  _roster.OfflineSince:SetHandler("OnMouseUp", function(self, button) 
    _addon.core.offlineFilter()
  end)

  _roster.Choice = createZOButton("SGT_Roster_Choice","", 200, 290, 50, ZO_GuildRosterSearchLabel)
  
  -- Rang
  _roster.RankLabel = _addon.core.createLabel("SGT_Roster_RankLabel", ZO_GuildRoster, getString(Shissu_rank) .. ":", {50,30},  {50, -5}, false, BOTTOMLEFT)
  _roster.Rank = WINDOW_MANAGER:CreateControlFromVirtual("SGT_Roster_Rank", SGT_Roster_RankLabel, "ZO_ComboBox")
  _roster.Rank:SetAnchor(RIGHT, SGT_Roster_RankLabel, RIGHT, 150, -5)
  _roster.Rank:SetHidden(false)
  _roster.Rank:SetWidth(140) 
  _roster.Rank.dropdown = ZO_ComboBox_ObjectFromContainer(_roster.Rank)

  _roster.rank = _roster.Rank.dropdown
  _roster.rank:SetSortsItems(false) 
  _roster.setRank(_roster.rank)

  _roster.rank:SetSelectedItem(blue .. "-- " .. white .. getString(ShissuNotebookMail_all2))

  -- Zenimax Offline Filter ausblenden
  ZO_GuildRosterHideOffline:SetHidden(true)

  -- Einzahlungen
  _roster.goldLabel = _addon.core.createLabel("SGT_Roster_GoldLabel", SGT_Roster_RankLabel, getString(ShissuRoster_goldDeposit2) .. ":", {110, 30},  {-67, 15}, false, BOTTOMLEFT)

  _roster.Gold = WINDOW_MANAGER:CreateControlFromVirtual("SGT_Roster_Gold", SGT_Roster_GoldLabel, "ZO_ComboBox")
  _roster.Gold:SetAnchor(RIGHT, SGT_Roster_GoldLabel, RIGHT, 158, 0)
  _roster.Gold:SetHidden(false)
  _roster.Gold:SetWidth(140)  
  _roster.Gold.dropdown = ZO_ComboBox_ObjectFromContainer(_roster.Gold)
  
  _roster.gold = _roster.Gold.dropdown
  _roster.gold:SetSortsItems(false) 

  _roster.gold:AddItem(_roster.gold:CreateItemEntry(getString(ShissuRoster_last), _roster.selectGold))
  _roster.gold:AddItem(_roster.gold:CreateItemEntry(getString(ShissuRoster_today), _roster.selectGold))
  _roster.gold:AddItem(_roster.gold:CreateItemEntry(getString(ShissuRoster_yesterday), _roster.selectGold))
  _roster.gold:AddItem(_roster.gold:CreateItemEntry(getString(ShissuRoster_sinceKiosk), _roster.selectGold)) 
  _roster.gold:AddItem(_roster.gold:CreateItemEntry(getString(ShissuRoster_lastWeek), _roster.selectGold)) 
  _roster.gold:AddItem(_roster.gold:CreateItemEntry(getString(ShissuRoster_total), _roster.selectGold))
    
  _roster.gold:SetSelectedItem(_addon.settings["gold"])
  
  -- Gold Deposit
  _roster.GoldDeposit = CreateControlFromVirtual("SGT_Roster_GoldDeposit", SGT_Roster_Rank, "ZO_DefaultTextButton")
  _roster.GoldDeposit:SetText(white .. getString(ShissuRoster_goldDeposit3) .. " >" .. blue .. " 0")
  _roster.GoldDeposit:SetAnchor(LEFT, SGT_Roster_Rank, LEFT, 150, 0)
  _roster.GoldDeposit:SetWidth(200) 
  
  _roster.GoldDeposit:SetHandler("OnMouseUp", function(self, button) 
    if button == 1 then
      _addon.core.goldFilter()
    else                                                    
      if _filter.goldDir == 0 then 
        _filter.goldDir = 1
        self:SetText(white .. getString(ShissuRoster_goldDeposit3) .. " >" .. blue .. " 0")
      else 
        _filter.goldDir = 0 
        self:SetText(white .. getString(ShissuRoster_goldDeposit3) .. " <" .. blue .. " 0")
      end
      _roster.refreshFilters() 
    end
  end)
  
  _roster.GoldDeposit = CreateControlFromVirtual("SGT_Roster_GoldTotal", SGT_Roster_Gold, "ZO_DefaultTextButton")
  _roster.GoldDeposit:SetText(white .. getString(ShissuRoster_sum) .. ": " .. blue .. "0")
  _roster.GoldDeposit:SetAnchor(LEFT, SGT_Roster_Gold, LEFT, 150, 0)
  _roster.GoldDeposit:SetWidth(200)
  _roster.GoldDeposit:SetText(white .. getString(ShissuRoster_sum) .. ": " .. blue .. _roster.getTotalGold())

  local CL = _addon.core.createZOButton
  ZO_EditNoteDialogNote:SetAnchor (3, ZO_EditNoteDialogDisplayName, 3, 0, 60)
  _addon.buttons.NoteStandard1 = CL("SGT_GuildColor_Note1", white .. "[ " .. _addon.core.userColor1 .. "1" .. white .. " ]", 50, 60, 30, ZO_EditNoteDialogDisplayName, 1)
  _addon.buttons.NoteStandard2 = CL("SGT_GuildColor_Note2", white .. "[ " .. _addon.core.userColor2 .. "2" .. white .. " ]", 50, 40, 0, SGT_GuildColor_Note1, 1)
  _addon.buttons.NoteStandard3 = CL("SGT_GuildColor_Note3", white .. "[ " .. _addon.core.userColor3 .. "3" .. white .. " ]", 50, 40, 0, SGT_GuildColor_Note2, 1)
  _addon.buttons.NoteStandard4 = CL("SGT_GuildColor_Note4", white .. "[ " .. _addon.core.userColor4 .. "4" .. white .. " ]", 50, 40, 0, SGT_GuildColor_Note3, 1)
  _addon.buttons.NoteStandard5 = CL("SGT_GuildColor_Note5", white .. "[ " .. _addon.core.userColor5 .. "5" .. white .. " ]", 50, 40, 0, SGT_GuildColor_Note4, 1) 
  _addon.buttons.NoteStandardW = CL("SGT_GuildColor_NoteW", white .. "[ " .. white .. "W" .. white .. " ]", 50, 40, 0, SGT_GuildColor_Note5, 1) 
end
            
function _roster.refreshFilters()
  GUILD_ROSTER_MANAGER:RefreshData()
end

function ZO_KeyboardGuildRosterRowDisplayName_OnMouseEnter(control)
  org_ZO_KeyboardGuildRosterRowDisplayName_OnMouseEnter(control)

  local parent = control:GetParent()
  local data = ZO_ScrollList_GetData(parent)
  local guildName = GetGuildName(GUILD_SELECTOR.guildId)
  local displayName = data.displayName
  local timeStamp = GetTimeStamp()

  local tooltip = data.characterName
  
  -- Mitglied seit?
  if (_history[guildName] ~= nil) then
    -- Account taucht nicht in der Gildenaufzeichnung auf
    tooltip = tooltip .. "\n\n"
    tooltip = tooltip .. getString(ShissuRoster_member)
          
    if (_history[guildName][displayName] == nil) then
      tooltip = tooltip .. " > " .. blue .. _addon.core.secsToTime(timeStamp - _history[guildName]["oldestEvent"][zos["History"]])
    else
      if (_history[guildName][displayName].timeJoined ~= nil) then
        local timeData = _history[guildName][displayName].timeJoined
        
        tooltip = tooltip .. " " .. blue .. _addon.core.secsToTime(timeStamp - timeData) .. white .. " (" .. GetDateStringFromTimestamp(timeData) .. ")"
      else
        tooltip = tooltip .. " > " .. blue .. _addon.core.secsToTime(timeStamp - _history[guildName]["oldestEvent"][zos["History"]])
      end
    end
  end
      
  InitializeTooltip(InformationTooltip, control, BOTTOM, 0, 0, TOPCENTER)
  SetTooltipText(InformationTooltip, tooltip)
end

function ZO_KeyboardGuildRosterRowDisplayName_OnMouseExit(control)
  ClearTooltip(InformationTooltip)
  org_ZO_KeyboardGuildRosterRowDisplayName_OnMouseExit(control)
end
 
-- NEW ROSTER
function _addon.core:InitRosterChanges()   
  GUILD_ROSTER_ENTRY_SORT_KEYS["character"] = { tiebreaker = 'displayName' }
  GUILD_ROSTER_ENTRY_SORT_KEYS["goldDeposit"] = { tiebreaker = 'displayName' }

  local additionalWidth = 0

  _addon.core.originalRosterBuildMasterList = GUILD_ROSTER_MANAGER.BuildMasterList
  GUILD_ROSTER_MANAGER.BuildMasterList = SGT_GuildRosterManager.BuildMasterList
  
  local headers = ZO_GuildRosterHeaders
  local zoneHeader = headers:GetNamedChild('Zone')
  
  if (_addon.settings["colGold"] or _addon.settings["colChar"] ) then                                 
    
    local headerDisplayName = headers:GetNamedChild('DisplayName') 
    zoneHeader:SetDimensions(220, 32)
    
    -- Spalte Charakter
    if _addon.settings["colChar"] then
      additionalWidth = additionalWidth + 100
      
      local control = headers:GetName() .. getString(ShissuRoster_char)
      local characterHeader = CreateControlFromVirtual(control, headers, 'ZO_SortHeader')
      ZO_SortHeader_Initialize(characterHeader, getString(ShissuRoster_char), 'character', ZO_SORT_ORDER_DOWN, TEXT_ALIGN_LEFT, 'ZoFontGameLargeBold')
                
      characterHeader:SetAnchor(TOPLEFT, headerDisplayName, TOPRIGHT, 0, 0)   
      characterHeader:SetDimensions(200,32)
      characterHeader:SetHidden(false)
      
      GUILD_ROSTER_KEYBOARD.sortHeaderGroup:AddHeader(characterHeader)
      
      -- Spalte Zone                                                                                                                                             
      zoneHeader:ClearAnchors()
      zoneHeader:SetAnchor(TOPLEFT, characterHeader, TOPRIGHT, 0, 0)  
    end

    -- Spalte Einzahlungen
    if _addon.settings["colGold"] then  
      additionalWidth = additionalWidth + 10
      
      if _addon.settings["colChar"] then
        additionalWidth = additionalWidth + 80
      end
      
      controlName = headers:GetName() .. getString(ShissuRoster_goldDeposit)
      local goldDepositHeader = CreateControlFromVirtual(controlName, headers, 'ZO_SortHeader')
      ZO_SortHeader_Initialize(goldDepositHeader, getString(ShissuRoster_goldDeposit) .. " ", 'goldDeposit', ZO_SORT_ORDER_DOWN, TEXT_ALIGN_CENTER, 'ZoFontGameLargeBold')     

      goldDepositHeader:SetAnchor(TOPLEFT, zoneHeader, TOPRIGHT, 0, 0)
      goldDepositHeader:SetDimensions(115, 32)
      goldDepositHeader:SetHidden(false)  
      
      GUILD_ROSTER_KEYBOARD.sortHeaderGroup:AddHeader(goldDepositHeader)
    
      -- Spalte Klasse
      controlName = headers:GetNamedChild('Class')
      controlName:ClearAnchors()
      controlName:SetAnchor(TOPLEFT, goldDepositHeader, TOPRIGHT, 0, 0)
    end
    
    local origWidth = ZO_GuildRoster:GetWidth()
    ZO_GuildRoster:SetWidth(origWidth + additionalWidth)   
  else
    zoneHeader:SetDimensions(300, 32)
  end  
     
  -- Aktualisieren
  GUILD_ROSTER_MANAGER:RefreshData()  
end                                                     
                                                      

local GUILD_ROSTER_MANAGER_SetupEntry = GUILD_ROSTER_MANAGER.SetupEntry

function GUILD_ROSTER_MANAGER:SetupEntry(control, data, selected)
  GUILD_ROSTER_MANAGER_SetupEntry(self, control, data, selected)
 
  local rowZone = control:GetNamedChild('Zone')
  local rowDisplayName = control:GetNamedChild("DisplayName")
  local class = control:GetNamedChild('ClassIcon')   
  
  -- Spalte Einzahlung
  if _addon.settings["colGold"] then
    local goldDeposit = control:GetNamedChild(getString(ShissuRoster_goldDeposit))
    if(not goldDeposit) then
      controlName = control:GetName() .. getString(ShissuRoster_goldDeposit)
      goldDeposit = control:CreateControl(controlName, CT_LABEL)
      goldDeposit:SetAnchor(LEFT, rowZone, RIGHT, 10, 0)
      goldDeposit:SetFont('ZoFontGame')
      goldDeposit:SetWidth(100)
      goldDeposit:SetHidden(false)    
      goldDeposit:SetHorizontalAlignment(TEXT_ALIGN_RIGHT)    
    end  
       
    goldDeposit:SetText(ZO_LocalizeDecimalNumber(data.goldDeposit or 0) .. " |t16:16:/esoui/art/guild/guild_tradinghouseaccess.dds|t")
                                                      
    if (data.goldDepositTT) then
      goldDeposit:SetMouseEnabled(true);
      goldDeposit:SetHandler("OnMouseEnter", function (self) ZO_Tooltips_ShowTextTooltip(self, TOP, data.goldDepositTT) end)
    end         

    class:ClearAnchors() 
    class:SetAnchor(TOPLEFT, goldDeposit, TOPRIGHT, 8)   
  else
    local goldDeposit = control:GetNamedChild(getString(ShissuRoster_goldDeposit))
    if (goldDeposit) then
      goldDeposit:SetHidden(true)
      class:ClearAnchors() 
      class:SetAnchor(TOPLEFT, rowZone, TOPRIGHT, 8)   
    end  
  end

  if (_addon.settings["colChar"]) then
    local character = control:GetNamedChild(getString(ShissuRoster_char))
    if(not character) then
      local controlName = control:GetName() .. getString(ShissuRoster_char)
    	character = control:CreateControl(controlName, CT_LABEL)
    	character:SetAnchor(LEFT, rowDisplayName, RIGHT, 0, 0)
    	character:SetFont('ZoFontGame')
      character:SetWidth(195)
      character:SetHidden(false)    
    end  

    local characterName = data.characterName
      
    if string.len(data.characterName) > 28 then
      characterName = string.sub(data.characterName, 0, 28) .. "..." 
    end 

    if (data.online) then
      character:SetText(characterName)
    else
      characterName = string.gsub(characterName, "|ceeeeee", "")
      character:SetText("|cadadad" .. characterName) 
    end
          
    if data.characterNameTT then 
      character:SetMouseEnabled(true);
      character:SetHandler("OnMouseEnter", function (self) ZO_Tooltips_ShowTextTooltip(self, TOP, data.characterNameTT) end)
      character:SetHandler("OnMouseExit", function (self) ZO_Tooltips_HideTextTooltip() end)
    end
      
    -- Spalte Zone
    rowZone:ClearAnchors() 
    rowZone:SetAnchor(TOPLEFT, character, TOPRIGHT, 8)   
  else
    local character = control:GetNamedChild(getString(ShissuRoster_char))
    if (character) then
      character:SetHidden(true)
      rowZone:ClearAnchors() 
      rowZone:SetAnchor(TOPLEFT, rowDisplayName, TOPRIGHT, 8)   
    end
  end
  
  if _addon.settings["colGold"] or _addon.settings["colChar"] then
    rowZone:SetWidth(210)
  else
    rowZone:SetWidth(320)
  end

  -- Spalte Persönliche Notizen  
  if _addon.settings["colNote"] then                                                                      
    local rowNote = control:GetNamedChild('Note')
    local persNote = control:GetNamedChild('[N]')
      
    if(not persNote) then
      controlName = control:GetName() .. '[N]'
    	persNote = control:CreateControl(controlName, CT_LABEL)
    	persNote:SetAnchor(LEFT, rowNote, LEFT, -15, 0)
      persNote:SetFont('ZoFontGame')
      persNote:SetWidth(40)
      persNote:SetHorizontalAlignment(TEXT_ALIGN_LEFT)    
     end   
      
    if data.sgtNote then 
      persNote:SetMouseEnabled(true);
      persNote:SetHandler("OnMouseEnter", function (self) ZO_Tooltips_ShowTextTooltip(self, TOP, data.sgtNote) end)
      persNote:SetHandler("OnMouseExit", function (self) ZO_Tooltips_HideTextTooltip() end) --org_ZO_KeyboardGuildRosterRowDisplayName_OnMouseExit(self) end) 
      persNote:SetText("|t32:32:/ShissuGuildTools/textures/notes.dds|t")
      persNote:SetHidden(false)   
    else
      persNote:SetHidden(true)    
    end
  end
end                 

SGT_GuildRosterManager = {} 

function SGT_GuildRosterManager:BuildMasterList()      
  _addon.core.originalRosterBuildMasterList(self)
  
  local guildId = GUILD_ROSTER_MANAGER.guildId
    
  for i = 1, #self.masterList do
    local data = self.masterList[i]
    local displayName = data.displayName
    local memberChars = _memberChars[displayName]
      
    local characterName = data.characterName 
    local characterName2 = string.gsub(characterName, "|ceeeeee", "")

    -- Charaktername Tooltip  
    if _addon.settings["colChar"] then
      if memberChars then
        local firstChar = 1
        local newCharacterNameTT = ""
        
        for charName, charInfo in pairs(memberChars) do       
          if (characterName2) then 
            if ( characterName2 == charName ) then
              charName = green .. charName
            end
          end
        
          if firstChar == 1 then
            newCharacterNameTT = _addon.core.newCharName(charName, charInfo)
            firstChar = 0
          else
            if (not string.find(newCharacterNameTT, _addon.core.newCharName(charName, charInfo))) then  
              newCharacterNameTT = newCharacterNameTT .. "\n" .. _addon.core.newCharName(charName, charInfo)
            end  
          end                      
                                                
        end
        
        data.characterNameTT = blue .. displayName .. white .. "\n\n" .. newCharacterNameTT
      end  
    end
    
    -- Spalte: Gold Einzahlung
    local guildName = GetGuildName(guildId)
    local goldDeposit = 0
    local goldTooltip = ""

    if _addon.settings["colGold"] then
      if (_history) then
        if (_history[guildName]) then 
          if (_history[guildName][displayName]) then
            -- Heute
            if (_addon.settings["gold"] == getString(ShissuRoster_today)) then  
              if ( _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].timeLast > _addon.core.getDay()) then
                goldDeposit = _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].last
              end
            -- Gestern
            elseif (_addon.settings["gold"] == getString(ShissuRoster_yesterday)) then
              if ( _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].timeLast > (_addon.core.getDay() - 86400) and 
                   _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].timeLast < _addon.core.getDay()) then
                goldDeposit = _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].last
              end
            
            -- Zuletzt            
            elseif (_addon.settings["gold"] == getString(ShissuRoster_last)) then
              goldDeposit = _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].last
            
            -- seit Gildenhändler
            elseif (_addon.settings["gold"] == getString(ShissuRoster_sinceKiosk)) then     
              goldDeposit = _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].currentNPC       

            -- Letzte Woche
            elseif (_addon.settings["gold"] == getString(ShissuRoster_lastWeek)) then
              goldDeposit = _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].previousNPC  
            
            -- Gesamt     
            else
              goldDeposit = _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].total      
            end
            
            goldTooltip = blue .. displayName .. white .. "\n"      
            goldTooltip = _addon.core.buildTooltip(guildName, displayName, goldTooltip, zos["GoldAdded"], green .. "Gold " .. getString(ShissuHistory_goldAdded))
            goldTooltip = _addon.core.buildTooltip(guildName, displayName, goldTooltip, zos["GoldRemoved"], red .. "Gold " .. getString(ShissuHistory_goldRemoved))
            goldTooltip = _addon.core.buildTooltip(guildName, displayName, goldTooltip, zos["ItemAdded"], green .. "Item " .. getString(ShissuHistory_itemAdded))
            goldTooltip = _addon.core.buildTooltip(guildName, displayName, goldTooltip, zos["ItemRemoved"], red .. "Item " .. getString(ShissuHistory_itemRemoved))
  
            if(goldTooltip == blue .. displayName .. white .. "\n") then
              goldTooltip = blue .. displayName .. "\n" .. white .. getString(ShissuRoster_noData)  
            end

            data.goldDeposit = goldDeposit
            data.goldDepositTT = goldTooltip
          end                                                                      
        end
      end     
    end
    
    -- Spalte: Persönliche Notizen  
    if (_addon.settings["colNote"]) then  
      if _personalNote then
        if _personalNote[guildId] then
          if _personalNote[guildId][displayName] then       
            if (string.len(_personalNote[guildId][displayName])) > 1 then
              data.sgtNote = _personalNote[guildId][displayName]
            else
              _personalNote[guildId][displayName] = nil
            end
          end
        end
      end  
    end  
    
    -- Spalte: Zone -> Offline seit?
    if data.status == 4 then 
      data.formattedZone = _addon.core.secsToTime(data.secsSinceLogoff) .. "\n\n" .. data.formattedZone
    end
      
  end 
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
    
    for number=1, 5 do
      _addon.core["userColor" .. number] = "|c" .. RGBtoHex(_addon.settings["c" .. number][1], _addon.settings["c" .. number][2], _addon.settings["c" .. number][3])
      d(_addon.core["userColor" .. number])
    end
  end
  
  if (_addon.settings["colGold"] == nil) then _addon.settings["colGold"] = true end
  if (_addon.settings["colChar"] == nil) then _addon.settings["colChar"] = true end
  if (_addon.settings["colNote"] == nil) then _addon.settings["colNote"] = true end

  _addon.core.rosterUI()
  _addon.core:InitRosterChanges() 
  _addon.core.createSettingMenu()
end                               

Shissu_SuiteManager._settings[_addon.Name] = {}
Shissu_SuiteManager._settings[_addon.Name].panel = _addon.panel                                       
Shissu_SuiteManager._settings[_addon.Name].controls = _addon.controls                 
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized    