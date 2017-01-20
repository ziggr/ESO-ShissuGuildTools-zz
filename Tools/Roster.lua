-- File: Roster.lua
-- Zuletzt geändert: 20. Januar 2016

-- LOCALS
local SGT_Roster = {}

SGT_Roster.UI = {}
SGT_Roster.MemberChars = {}
SGT_Roster.Player = {
  Online = true,
  Offline = true,
  OfflineSince = 0,
  Aldmeri = true,
  Ebonheart = true,
  Daggerfall = true,   
  GoldDeposit = 0,
} 

SGT_Roster.CurrentRank = ""
SGT_Roster.Rank = nil
SGT_Roster.Level = nil
SGT_Roster.currentGuild = nil
SGT_Roster.oldGuild = nil
SGT_Roster.History = nil

local org_ZO_KeyboardGuildRosterRowDisplayName_OnMouseEnter = ZO_KeyboardGuildRosterRowDisplayName_OnMouseEnter
local org_ZO_KeyboardGuildRosterRowDisplayName_OnMouseExit = ZO_KeyboardGuildRosterRowDisplayName_OnMouseExit
              
-- FUNCTIONS
function ShissuGT.Roster.Toogle() 
  SGT_Roster.Player = {
    Online = true,
    Offline = true,
    OfflineSince = 0,
    Aldmeri = true,
    Ebonheart = true,
    Daggerfall = true,   
  }   
  
  ShissuGT.Roster.RefreshFilters()
  
  if ShissuGT.Settings.Roster == true then SGT_Roster.Toogle(false) SGT_Roster.AnchorSet(55,-320,7)   
  else SGT_Roster.Toogle(true) SGT_Roster.AnchorSet(25,-40,35)  end    
end
 
function SGT_Roster.AnchorSet(R_offsetY, S_offsetX, S_offsetY)
  ZO_GuildRoster:SetAnchor(8,GUIROOT,8,0, R_offsetY)   
  ZO_GuildRosterSearch:SetAnchor(TOPRIGHT,ZO_GuildRoster,TOPRIGHT, S_offsetX, S_offsetY)   
end
         
function SGT_Roster.Toogle(bool)
  local SGT = SGT_Roster.UI
  
  SGT.AllianceLabel:SetHidden(bool)                                                                         
  SGT.Aldmeri:SetHidden(bool)    
  SGT.AldmeriInGuild:SetHidden(bool)    
  SGT.Ebonheart:SetHidden(bool)    
  SGT.EbonheartInGuild:SetHidden(bool)  
  SGT.Daggerfall:SetHidden(bool)    
  SGT.DaggerfallInGuild:SetHidden(bool)  
  SGT.StatusLabel:SetHidden(bool)  
  SGT.Online:SetHidden(bool)                        
  SGT.Offline:SetHidden(bool)   
  SGT.OfflineSince:SetHidden(bool)  
  SGT.Choice:SetHidden(bool) 
end

function SGT_Roster.NewCharName(charName, charInfo)
  charName = charName .. ShissuGT.Lib.GetCharLevel(charInfo)
  charName = ShissuGT.Lib.GetCharInfoIcon(charInfo.class, charName, true)
  charName = ShissuGT.Lib.GetCharInfoIcon(charInfo.alliance, charName)
 
  return charName 
end

function ShissuGT.Roster.RefreshFilters()
  GUILD_ROSTER_MANAGER:RefreshData()
end

local ZOS_GUILD_ROSTER_MANAGER_BuildMasterList = GUILD_ROSTER_KEYBOARD.BuildMasterList

-- Original Function: ZO_GuildRosterManager:BuildMasterList()
-- \esoui\ingame\guild\guildroster_shared.lua
function SGT_Roster.BuildMasterList()
  ZOS_GUILD_ROSTER_MANAGER_BuildMasterList()

  local masterList = GUILD_ROSTER_MANAGER:GetMasterList()
  local guildId = GUILD_ROSTER_MANAGER.guildId
  local numGuildMembers = GetNumGuildMembers(guildId)
  
  -- Neue Gilde? Neue Rankliste
  SGT_Roster.currentGuild = guildId
  
  if SGT_Roster.oldGuild ~= SGT_Roster.currentGuild then
    SGT_Roster.oldGuild = guildId
    SGT_Roster.SetRank(SGT_Roster.Rank)
  end
  
  for guildMemberIndex=1, numGuildMembers, 1 do
    local firstChar = 1
    local charakterToolTip = ""
    local displayName = masterList[guildMemberIndex].displayName
    local memberChars = SGT_Roster.MemberChars[displayName]
    
    -- Spalte: Charakter: Inject    
    if memberChars then
      for charName, charInfo in pairs(memberChars) do
        if firstChar == 1 then
          masterList[guildMemberIndex].characterNameTT = SGT_Roster.NewCharName(charName, charInfo)
          firstChar = 0
        else
          if (not string.find(masterList[guildMemberIndex].characterNameTT, SGT_Roster.NewCharName(charName, charInfo))) then  
            masterList[guildMemberIndex].characterNameTT =  masterList[guildMemberIndex].characterNameTT .. "\n" .. SGT_Roster.NewCharName(charName, charInfo)
          end  
        end                                                            
      end
    end 
  
    -- Spalte: Zone: Time Inject  
    if masterList[guildMemberIndex].status == 4 then 
      masterList[guildMemberIndex].formattedZone = ShissuGT.Lib.SecsToTime(masterList[guildMemberIndex].secsSinceLogoff) 
    end
    
    -- Spalte: Persönliche Notizen: Inject
    if ShissuGT.Settings.RosterNoteAll == true then  
      for i=1, GetNumGuilds() do
        if SGT_Roster.PersonalNote[i] ~= nil then
          if not ShissuGT.Lib.IsStringEmpty(SGT_Roster.PersonalNote[i][masterList[guildMemberIndex].displayName]) then 
            masterList[guildMemberIndex].persNote = SGT_Roster.PersonalNote[i][masterList[guildMemberIndex].displayName]
            break
          end      
        end
      end
    else
      if SGT_Roster.PersonalNote[guildId] ~= nil then
        if not ShissuGT.Lib.IsStringEmpty(SGT_Roster.PersonalNote[guildId][masterList[guildMemberIndex].displayName]) then 
          masterList[guildMemberIndex].persNote = SGT_Roster.PersonalNote[guildId][masterList[guildMemberIndex].displayName]
        end      
      end
    end

  end
end

function SGT_Roster.FilterScrollList(self)
  local SGT = ShissuGT.Roster
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
    SGT_Roster.MemberChars[data.displayName] = SGT_Roster.MemberChars[data.displayName] or {}
    local MemberChars = SGT_Roster.MemberChars[data.displayName]
    
    -- Charaktername weis färben, falls noch nicht geschehen
    if (string.find( data.characterName , "|c" )) == nil then
      data.characterName = ShissuGT.Color[5] .. data.characterName
    end
    
    -- Nur Charaktername hinzufügen falls noch nicht vorhanden, oder bei einer Änderung
    if MemberChars[data.characterName] ~= nil then
      if MemberChars[data.characterName]["lvl"] ~= data.level or
        MemberChars[data.characterName]["vet"] ~= data.veteranRank then
        MemberChars[data.characterName] = { ["lvl"] = data.level, ["vet"] = data.veteranRank, ["class"] = data.class, ["alliance"] = data.alliance }  
      end  
    else
      MemberChars[data.characterName] = { ["lvl"] = data.level, ["vet"] = data.veteranRank, ["class"] = data.class, ["alliance"] = data.alliance }  
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
      
      if shissuGT.History[guildName] ~= nil then
        if shissuGT.History[guildName][data.displayName] ~= nil then
          if shissuGT.History[guildName][data.displayName][ShissuGT.ZOS.GoldAdded] ~= nil then
            --d(data.displayName)
            --d(shissuGT.History[guildName][data.displayName][ShissuGT.ZOS.GoldAdded].total)   
            goldDeposit = shissuGT.History[guildName][data.displayName][ShissuGT.ZOS.GoldAdded].total                                
          end
        end
      end 
      
      if goldDeposit >= SGT_Roster.Player.GoldDeposit then
        if SGT_Roster.CurrentRank == "" or SGT_Roster.CurrentRank == ShissuGT.i18n.Notebook.All 
        or SGT_Roster.CurrentRank == GetFinalGuildRankName(guildId, data.rankIndex) then 
          if (SGT_Roster.Player .Aldmeri == true and data.alliance == 1) or (SGT_Roster.Player .Ebonheart == true and data.alliance == 2) or (SGT_Roster.Player .Daggerfall == true and data.alliance == 3)then                                               
            if SGT_Roster.Player .Online and (data.status ==1 or data.status ==2 or data.status ==3) then
              GuildInfo.Choice = GuildInfo.Choice +1
              table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
            elseif SGT_Roster.Player .Offline and PlayerTime >= SGT_Roster.Player .OfflineSince then 
              table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, data))
              GuildInfo.Choice = GuildInfo.Choice +1
            end
          end
        end      
      end   
    end
  end

  -- Anzeige der prozentuallen Verteilungen
  local Proc = {
    Aldmeri = ShissuGT.Lib.Round (GuildInfo.Aldmeri / GuildInfo.Max *100),
    Ebonheart = ShissuGT.Lib.Round(GuildInfo.Ebonheart / GuildInfo.Max *100),
    Daggerfall = ShissuGT.Lib.Round (GuildInfo.Daggerfall / GuildInfo.Max *100),
    Choice = ShissuGT.Lib.Round (GuildInfo.Choice / GuildInfo.Max *100),
  }
  
  SGT_Roster.UI.AldmeriInGuild:SetText( ShissuGT.Color[5] .. Proc.Aldmeri .. ShissuGT.Color[6] .. "%" )
  SGT_Roster.UI.EbonheartInGuild:SetText( ShissuGT.Color[5] .. Proc.Ebonheart .. ShissuGT.Color[6] .. "%"  )
  SGT_Roster.UI.DaggerfallInGuild:SetText( ShissuGT.Color[5] .. Proc.Daggerfall .. ShissuGT.Color[6] .. "%"  )
  SGT_Roster.UI.Choice:SetText (ShissuGT.Color[5] .. ShissuGT.i18n.Notebook.MailChoiceL .. ShissuGT.Color[6] .. GuildInfo.Choice .. "/" .. ShissuGT.Color[5] .. GuildInfo.Max .. ShissuGT.Color[5] .. " (" .. ShissuGT.Color[6] .. Proc.Choice .. ShissuGT.Color[5] .. "%)")
end

function SGT_Roster.CreateButton(name, var, offsetX, offsetY, parent) 
  local button = CreateControlFromVirtual(name, ZO_GuildRoster, "ZO_CheckButton")
  button:SetAnchor(TOPLEFT, parent, TOPLEFT, offsetX, offsetY)
  
  ShissuGT.Lib.CheckBox(button, var)
  
  ZO_CheckButton_SetToggleFunction(button, function(control, checked)
    SGT_Roster.Player[var] = checked
    ShissuGT.Roster.RefreshFilters()
  end)
  
  ShissuGT.Lib.SetToolTip(button, "Roster", var)
  ShissuGT.Lib.HideToolTip(button)
   
  return button
end

function SGT_Roster.CreateControl(parent, anchor, name)
  local control = WINDOW_MANAGER:CreateControl(parent:GetName() .. name, parent, CT_CONTROL)
  --control:SetDimensions(dimensions[1],dimensions[2])
  control:SetDimensions(175, 30)
  control:SetAnchor(LEFT, anchor, nil, 0, 0)
  return control
end

function SGT_Roster.CreateNewRowLabel(parent, anchor, name, dimensions)
  if(not dimensions) then dimensions = {175, 30} end
  
  local control = WINDOW_MANAGER:CreateControl(parent:GetName() .. name, parent, CT_LABEL)
  control:SetFont( "ZoFontGame")
  control:SetColor(255,255,255,255)
  control:SetDimensions(dimensions[1], dimensions[2])
  control:SetAnchor(LEFT, anchor, RIGHT, 0)
  control:SetText("")
  control:SetVerticalAlignment(TOP)
  control:SetHidden(false)

  return control
end

function ShissuGT.Roster.PersonalNoteChange(displayName, note)
  local guildId = GUILD_ROSTER_MANAGER:GetGuildId()
    
  if guildId == nil then return false end
  if displayName == nil then return false end
  
  -- Variablen erstellen, falls nicht vorhanden, und danach abspeichern
  if SGT_Roster.PersonalNote[guildId] == nil then SGT_Roster.PersonalNote[guildId] = {} end
  if SGT_Roster.PersonalNote[guildId][displayName] == nil then SGT_Roster.PersonalNote[guildId][displayName] = "" end
  
  if note == nil then
    SGT_Roster.PersonalNote[guildId][displayName] = nil
    return false
  end
  
  SGT_Roster.PersonalNote[guildId][displayName] = note
  
  -- Roster aktualisieren
  ShissuGT.Roster.RefreshFilters()
end

function ShissuGT.Roster.initRoster()
  if ShissuGT.Roster.originalRosterStatsCallback then return end
    
  ShissuGT.Roster.initRosterHeader()

  local dataType = GUILD_ROSTER_KEYBOARD.list.dataTypes[GUILD_MEMBER_DATA]

  ShissuGT.Roster.originalRosterCallback = dataType.setupCallback
  if ShissuGT.Roster.originalRosterCallback then
    dataType.setupCallback = function(...)
      local row, data = ...
      
      ShissuGT.Roster.originalRosterCallback(...)
      zo_callLater(function() ShissuGT.AddRosterInfo(row, data) end, 25)
    end
  end    
end

function ShissuGT.AddRosterInfo(rowControl, data)
  if data == nil then return end
  
  local character = rowControl:GetNamedChild("Character")
  local displayName = rowControl:GetNamedChild("DisplayName")
  local rank = rowControl:GetNamedChild("RankIcon")
  local zone = rowControl:GetNamedChild("Zone")
  local class = rowControl:GetNamedChild("Class")
  local level = rowControl:GetNamedChild("Level")
  local persNote = rowControl:GetNamedChild("PersNote")
  local note = rowControl:GetNamedChild("Note")
    
  -- Spalte: UserID; positionieren 
  if (displayName) then
    displayName:SetDimensions(175, 30)
    displayName:ClearAnchors() 
    displayName:SetAnchor(LEFT, rank, RIGHT, 0, 0)
  end
  
  -- Spalte: Charakter; erstellen & positionieren
  if(not character) then
    local controlName = rowControl:GetName() .. 'Character'
    
    character = rowControl:CreateControl(controlName, CT_LABEL)
    character:SetAnchor(LEFT, displayName, RIGHT, 3, 0)
    character:SetFont('ZoFontGame')
    character:SetWidth(190)
    character:SetHeight(30)
    character:SetHidden(false)    
  end
   
  -- Spalte: Charakter; je nach Status des Spielers einfärben 
  if data.online then
    character:SetColor(1,1,1,1)
    character:SetText(data.characterName)
  else
    character:SetColor(displayName:GetColor())
    character:SetText(data.characterName)
  end 
  
  -- Spalte Charakter; ToolTip
  local DisplayName = data.displayName
  local MemberChars = SGT_Roster.MemberChars[DisplayName]
  local firstChar = 1
  
  if data.characterNameTT then 
    character:SetMouseEnabled(true);
    character:SetHandler("OnMouseEnter", function (self) ZO_Tooltips_ShowTextTooltip(self, TOP, data.characterNameTT) end)
    character:SetHandler("OnMouseExit", function () ZO_Tooltips_HideTextTooltip() end)
  end

  -- Spalte: Ort; Inhalte anpassen & positionieren
  zone:ClearAnchors()
  zone:SetAnchor(TOPLEFT, character, TOPRIGHT, 0, 0) 
  zone:SetDimensions(215,30)

  -- Spalte: Persönliche Notizen; erstellen und positionieren
  if(not persNote) then
    local controlName = rowControl:GetName() .. 'PersNote'
    
    persNote = rowControl:CreateControl(controlName, CT_LABEL)
    persNote:SetAnchor(LEFT, level, RIGHT, -25, 0)
    persNote:SetFont('ZoFontGame')
    persNote:SetWidth(36)
    persNote:SetHidden(false)
  end
  
  if (data.persNote) then
    persNote:SetText("|t36:36:EsoUI/Art/Journal/journal_tabicon_cadwell_up.dds|t")
    persNote:SetMouseEnabled(true);
    persNote:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, TOP, data.persNote); self:SetText("|t36:36:EsoUI/Art/Journal/journal_tabicon_cadwell_down.dds|t") end);
    persNote:SetHandler("OnMouseExit", function(self) ZO_Tooltips_HideTextTooltip(); self:SetText("|t36:36:EsoUI/Art/Journal/journal_tabicon_cadwell_up.dds|t") end);
  else 
    persNote:SetText(" ")
  end
  
  -- Spalte: Notizen; positionieren
  note:ClearAnchors()
  note:SetAnchor(LEFT, persNote, RIGHT, -10, -3) 
  
  -- Entfernen sonst doppelte, dreifache, ... Objekte 
  character = nil
  persNote = nil
end

function ShissuGT.Roster.initRosterHeader()
  local rosterHeader = ZO_GuildRosterHeaders
  local displayNameHeader = rosterHeader:GetNamedChild("DisplayName")
  local levelHeader = rosterHeader:GetNamedChild("Level")
  
  -- Neue Überschrift: Charakter
  GUILD_ROSTER_ENTRY_SORT_KEYS['character'] = { tiebreaker = 'displayName', isNumeric = true }
  
  local controlName = rosterHeader:GetName() .. 'Charakter'
  
  local characterHeader = CreateControlFromVirtual(controlName, rosterHeader, 'ZO_SortHeader')
  ZO_SortHeader_Initialize(characterHeader, "Charakter", 'character', ZO_SORT_ORDER_DOWN, TEXT_ALIGN_LEFT, 'ZoFontGameLargeBold')

  characterHeader:SetAnchor(TOPLEFT, displayNameHeader, TOPRIGHT, 0, 0)
  displayNameHeader.sortHeaderGroup:AddHeader(characterHeader)
  characterHeader:SetDimensions(190, 32)
  characterHeader:SetHidden(false)
  
  -- Neue Überschrift: Persönliche Notiz
  GUILD_ROSTER_ENTRY_SORT_KEYS['persNote'] = { tiebreaker = 'displayName', isNumeric = true }
  local controlName2 = rosterHeader:GetName() .. 'PersNote'
  
  local persNoteHeader = CreateControlFromVirtual(controlName2, rosterHeader, 'ZO_SortHeader')
  ZO_SortHeader_Initialize(persNoteHeader, "", 'persNote', ZO_SORT_ORDER_DOWN, TEXT_ALIGN_LEFT, 'ZoFontGameLargeBold')

  persNoteHeader:SetAnchor(TOPLEFT, levelHeader, TOPRIGHT, 0, 0)
  levelHeader.sortHeaderGroup:AddHeader(persNoteHeader)
  
  -- Alte Überschriften; positionieren/anpassen
  local rankHeader = rosterHeader:GetNamedChild("Rank")
  local zoneHeader = rosterHeader:GetNamedChild("Zone")
  local classHeader = rosterHeader:GetNamedChild("Level")   
  
  displayNameHeader:SetDimensions(175, 30) 
  displayNameHeader:ClearAnchors() 
  displayNameHeader:SetAnchor(TOPLEFT, rankHeader, TOPRIGHT, 8)     
  
  zoneHeader:ClearAnchors()
  zoneHeader:SetAnchor(TOPLEFT, characterHeader, TOPRIGHT, 0, 0)
  zoneHeader:SetDimensions(215,30)

  -- Roster aktualisieren    
  ShissuGT.Roster.RefreshFilters()
end
	
-- Mitgliederliste initialisieren
function ShissuGT.Roster.Initialize()
  local SGT = ShissuGT.Roster
  local CL = ShissuGT.Lib.CreateZOButton
  local CB = SGT_Roster.CreateButton

  ShissuGT.Roster.initRoster()

  shissuGT.MemberChars = shissuGT.MemberChars or {}
  SGT_Roster.MemberChars = shissuGT.MemberChars

  shissuGT.PersonalNote = shissuGT.PersonalNote or {}
  SGT_Roster.PersonalNote = shissuGT.PersonalNote
  
  shissuGT.History = shissuGT.History or {}
  SGT_Roster.History = shissuGT.History
  
  ShissuGT.Roster.Note = true
  ShissuGT.Roster.Active = true

  -- Fenster formatieren & Objekte erstellen
  local SearchLabel = ShissuGT.Color[6] .. ZO_GuildRosterSearchLabel:GetText()  
  ZO_GuildRosterSearchLabel:SetText(SearchLabel)  
  ZO_GuildRosterSearch:SetWidth(200)  
  
  SGT_Roster.AnchorSet(55,-320,7)

  GUILD_ROSTER_KEYBOARD.FilterScrollList = SGT_Roster.FilterScrollList
  GUILD_ROSTER_KEYBOARD.BuildMasterList = SGT_Roster.BuildMasterList

  -- Allianzen
  SGT_Roster.UI.AllianceLabel = CL("SGT_Roster_AllianceLabel",ShissuGT.i18n.Alliance, 150, 180, -2 , ZO_GuildRosterSearchLabel)                                                                          
  SGT_Roster.UI.Aldmeri = CB("SGT_Roster_Aldmeri","Aldmeri", 50, 30, SGT_Roster_AllianceLabel)  
  SGT_Roster.UI.AldmeriInGuild = CL("SGT_Roster_AldmeriInGuild", "", 50, 35, -5, SGT_Roster_Aldmeri)  
  
  SGT_Roster.UI.Ebonheart = CB("SGT_Roster_Ebonheart","Ebonheart", 90, 0, SGT_Roster_Aldmeri)
  SGT_Roster.UI.EbonheartInGuild = CL("SGT_Roster_EbonheartInGuild", "", 50, 35, -5, SGT_Roster_Ebonheart)
  SGT_Roster.UI.Daggerfall = CB("SGT_Roster_Daggerfall","Daggerfall", 90, 0, SGT_Roster_Ebonheart)  
  SGT_Roster.UI.DaggerfallInGuild = CL("SGT_Roster_DaggerfallInGuild", "", 50, 35, -5, SGT_Roster_Daggerfall)

  -- Info Status Label  
  SGT_Roster.UI.StatusLabel = CL("SGT_Roster_StatusLabel","Status:", 100, -380 , 50, ZO_GuildRosterSearchLabel)
  SGT_Roster.UI.Online = CB("SGT_Roster_Online","Online", 100, 5, SGT_Roster_StatusLabel)                        
  SGT_Roster.UI.Offline = CB("SGT_Roster_Offline","Offline", 50, 0, SGT_Roster_Online) 
  
  -- Button Offline seit...
  SGT_Roster.UI.OfflineSince = CL("SGT_Roster_OfflineSince",ShissuGT.Color[6] .. ShissuGT.i18n.Notebook.MailOfflineSince .. ": ".. ShissuGT.Color[5].. "0 " .. ShissuGT.i18n.Notebook.MailDays, 200, 20, -5, SGT_Roster_Offline)
  SGT_Roster.UI.OfflineSince:SetHandler("OnMouseUp", function(self, button) 
    if button == 1 then SGT_Roster.Player.OfflineSince = SGT_Roster.Player.OfflineSince + 1    
    elseif button == 2 then SGT_Roster.Player.OfflineSince = SGT_Roster.Player.OfflineSince - 1     
    else SGT_Roster.Player.OfflineSince = SGT_Roster.Player.OfflineSince + 10 end
    
    self:SetText(ShissuGT.i18n.Notebook.MailOfflineSince .. ": ".. ShissuGT.Color[6].. SGT_Roster.Player.OfflineSince .." " .. ShissuGT.i18n.Notebook.MailDays )
    ShissuGT.Roster.RefreshFilters()
  end)

  SGT_Roster.UI.Choice = CL("SGT_Roster_Choice","", 200, 290, 50, ZO_GuildRosterSearchLabel)
  
  ShissuGT.Lib.SetToolTip(SGT_Roster.UI.Choice, "Roster", "Choice")
  ShissuGT.Lib.HideToolTip(SGT_Roster.UI.Choice)      
  
  -- Rang
  SGT_Roster.UI.RankLabel = ShissuGT.Lib.CreateLabel("SGT_Roster_RankLabel", ZO_GuildRoster, "Rank:", {50,30},  {50, -5}, false, BOTTOMLEFT)
  SGT_Roster.UI.Rank = WINDOW_MANAGER:CreateControlFromVirtual("SGT_Roster_Rank", SGT_Roster_RankLabel, "ZO_StatsDropdownRow")
  SGT_Roster.UI.Rank:SetAnchor(RIGHT, SGT_Roster_RankLabel, RIGHT, 150, -5)
  SGT_Roster.UI.Rank:SetHidden(false)
  SGT_Roster.UI.Rank:GetNamedChild("Dropdown"):SetWidth(140)
  SGT_Roster.UI.Rank:SetWidth(140)  
 
  SGT_Roster.Rank = SGT_Roster.UI.Rank.dropdown
  SGT_Roster.SetRank(SGT_Roster.Rank)
  
  ZO_GuildRosterHideOffline:SetHidden(true)
  
  -- Gold Deposit
  SGT_Roster.UI.GoldDeposit = CreateControlFromVirtual("SGT_Roster_GoldDeposit", SGT_Roster_Rank, "ZO_DefaultTextButton")
  SGT_Roster.UI.GoldDeposit:SetText(ShissuGT.Color[5] .. "Gold eingezahlt >" .. ShissuGT.Color[6].. "0")
  SGT_Roster.UI.GoldDeposit:SetAnchor(LEFT, SGT_Roster_Rank, LEFT, 120, 0)
  SGT_Roster.UI.GoldDeposit:SetWidth(200) 
  
  SGT_Roster.UI.GoldDeposit:SetHandler("OnMouseUp", function(self, button) 
    if button == 1 then SGT_Roster.Player.GoldDeposit = SGT_Roster.Player.GoldDeposit + 500    
    elseif button == 2 then SGT_Roster.Player.GoldDeposit = SGT_Roster.Player.GoldDeposit - 500     
    else SGT_Roster.Player.GoldDeposit = SGT_Roster.Player.GoldDeposit + 5000 end
    
    self:SetText(ShissuGT.Color[5] .. "Gold eingezahlt >" .. ShissuGT.Color[6].. SGT_Roster.Player.GoldDeposit)
    ShissuGT.Roster.RefreshFilters()
  end)
  
  ShissuGT.History.Scanner()
end

function SGT_Roster.SetRank(control)
  local guildId = GUILD_SELECTOR.guildId
  
  if control ~= nil then 
    control:ClearItems()
    control:AddItem(SGT_Roster.Rank:CreateItemEntry(ShissuGT.i18n.Notebook.All, SGT_Roster.SelectRank))
    
    for rankIndex = 1, GetNumGuildRanks(guildId) do
      control:AddItem(control:CreateItemEntry(GetFinalGuildRankName(guildId, rankIndex), SGT_Roster.SelectRank))
    end
  end
end
  
function SGT_Roster.SelectRank(_, statusText)
  SGT_Roster.CurrentRank = statusText
  ShissuGT.Roster.RefreshFilters()
end

function SGT_Roster.buildTooltip(guildName, displayName, tooltip, saveVar, titleText)
  local gold = "|t24:24:EsoUI/Art/Guild/guild_tradinghouseaccess.dds|t"
  local timeStamp = GetTimeStamp()
  
  if saveVar == ShissuGT.ZOS.ItemAdded or saveVar == ShissuGT.ZOS.ItemRemoved then gold = "" end
  
  if SGT_Roster.History[guildName][displayName][saveVar].last ~= 0 or
    SGT_Roster.History[guildName][displayName][saveVar].currentNPC ~= 0 or
    SGT_Roster.History[guildName][displayName][saveVar].previousNPC ~= 0 or
    SGT_Roster.History[guildName][displayName][saveVar].total ~= 0 then
        
    tooltip = tooltip .. "\n\n" .. titleText .. "\n" .. ShissuGT.Color[5]  
  end  

  if SGT_Roster.History[guildName][displayName][saveVar].currentNPC ~= 0 then  
    tooltip = tooltip .. ShissuGT.i18n.History.thisWeek .. ": " .. SGT_Roster.History[guildName][displayName][saveVar].currentNPC .. gold
    .. "\n"  
  end
        
  if SGT_Roster.History[guildName][displayName][saveVar].previousNPC ~= 0 then  
    tooltip = tooltip .. ShissuGT.i18n.History.lastWeek .. ": " .. SGT_Roster.History[guildName][displayName][saveVar].previousNPC .. gold 
    .. "\n"  
  end
         
  if SGT_Roster.History[guildName][displayName][saveVar].last ~= 0 then  
    tooltip = tooltip .. ShissuGT.i18n.History.Last .. ": " .. SGT_Roster.History[guildName][displayName][saveVar].last .. gold
    .. " (" .. ShissuGT.i18n.History.before .. " " .. ShissuGT.Lib.SecsToTime(timeStamp - SGT_Roster.History[guildName][displayName][saveVar].timeLast) .. ")"
    .. "\n"  
  end
        
  if SGT_Roster.History[guildName][displayName][saveVar].total ~= 0 then    
    tooltip = tooltip .. ShissuGT.i18n.History.Total .. ": " .. SGT_Roster.History[guildName][displayName][saveVar].total .. gold
    .. " (in " .. ShissuGT.Lib.SecsToTime(timeStamp - SGT_Roster.History[guildName]["oldestEvent"][ShissuGT.ZOS.Bank]) .. ")"    
  end

  return tooltip
end

function ZO_KeyboardGuildRosterRowDisplayName_OnMouseEnter(control)
  org_ZO_KeyboardGuildRosterRowDisplayName_OnMouseEnter(control)

  local parent = control:GetParent()
  local data = ZO_ScrollList_GetData(parent)
  local guildName = GetGuildName(GUILD_SELECTOR.guildId)
  local displayName = data.displayName
  local timeStamp = GetTimeStamp()

  local tooltip = data.characterName
  
  if SGT_Roster.History ~= nil then
    if (SGT_Roster.History[guildName] ~= nil) then
      -- Account taucht nicht in der Gildenaufzeichnung auf
      if (SGT_Roster.History[guildName][displayName] == nil) then
        -- Mitglied seit?
        tooltip = tooltip .. "\n\n"
        tooltip = tooltip .. ShissuGT.i18n.History.Member .. " > " .. ShissuGT.Lib.SecsToTime(timeStamp - SGT_Roster.History[guildName]["oldestEvent"][ShissuGT.ZOS.History])
      end
      
      -- Account taucht in der Gildenaufzeichnung auf   
      if (SGT_Roster.History[guildName][displayName] ~= nil) then
        -- Mitglied seit?
        if (SGT_Roster.History[guildName][displayName].timeJoined ~= nil) then
          tooltip = tooltip .. "\n\n" .. ShissuGT.i18n.History.Member .. " " .. ShissuGT.Lib.SecsToTime(timeStamp - SGT_Roster.History[guildName][displayName].timeJoined)
        else
          tooltip = tooltip .. "\n\n" .. ShissuGT.i18n.History.Member .. " > " .. ShissuGT.Lib.SecsToTime(timeStamp - SGT_Roster.History[guildName]["oldestEvent"][ShissuGT.ZOS.History])
        end
  
        tooltip = SGT_Roster.buildTooltip(guildName, displayName, tooltip, ShissuGT.ZOS.GoldAdded, ShissuGT.Color[1] .. "Gold " .. ShissuGT.i18n.History.GoldAdded)
        tooltip = SGT_Roster.buildTooltip(guildName, displayName, tooltip, ShissuGT.ZOS.GoldRemoved, ShissuGT.Color[3] .. "Gold " .. ShissuGT.i18n.History.GoldRemoved)
        tooltip = SGT_Roster.buildTooltip(guildName, displayName, tooltip, ShissuGT.ZOS.ItemAdded, ShissuGT.Color[1] .. "Item " .. ShissuGT.i18n.History.ItemAdded)
        tooltip = SGT_Roster.buildTooltip(guildName, displayName, tooltip, ShissuGT.ZOS.ItemRemoved, ShissuGT.Color[3] .. "Item " .. ShissuGT.i18n.History.ItemRemoved)
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