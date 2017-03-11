-- Shissu GuildTools 3
----------------------
-- File: SGT.lua
-- Version: v3.0.4.14
-- Last Update: 08.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!

local _globals = Shissu_SuiteManager._globals
local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]

local _SGT = Shissu_SuiteManager._lib["SGT"]
local toolTip = _SGT.toolTip
local getString = _SGT.getString

local _addon = {}
_addon.Name	= "ShissuGuildTools"
_addon.Version = "3.0.4.14"
_addon.formattedName	= "|cAFD3FFShissu's|r|ceeeeee Guild Tools"
_addon.core = {}
_addon.settings = {}
_addon.lib = {}

_addon.active = {}

local _lib = Shissu_SuiteManager._lib

_addon.panel = _lib.setPanel(blue .. "Guild Tools Modules", _addon.formattedName, _addon.Version)
_addon.controls = {
  [1] = {
    type = "title",
    name = getString(Shissu_info),
  },
  [2] = {
    type = "description",
    text = getString(ShissuModule_moduleInfo),
  },
  [3] = {
    type = "title",
    name = getString(ShissuModule_module)
  }
 }

local _module = {}

--_memberList = {}
_SGTcharacterList = {}
_SGTaccountList = {}

function _addon.core.initialized()
   shissuGT = shissuGT or {}
   shissuGT[_addon.Name] = shissuGT[_addon.Name] or _addon.settings
  _addon.settings = shissuGT[_addon.Name]

  zo_callLater(function()
    _addon.core.createCharacterList()
    _addon.core.createAccountList()
  end, 1500);
end

-- Liste aller Spieler aus allen eigenen Gilden
-- <-- Schneller als direktes Abrufen
-- Charakterlist
function _addon.core.createCharacterList()
  local numGuild = GetNumGuilds()

  for guildId = 1, numGuild do
    local name = GetGuildName(guildId)
    local numMember = GetNumGuildMembers(guildId)

    for memberId = 1, numMember, 1 do
      local charData = { GetGuildMemberCharacterInfo(guildId, memberId) }
      local memberData = { GetGuildMemberInfo(guildId, memberId) }
      local accName = memberData[1]

      local charName = charData[2]

      _addon.core.memberCharacterVars(charName, memberId, guildId)

      local _SGTcharacterList = _SGTcharacterList[charName]["guilds"]
      _SGTcharacterList[#_SGTcharacterList +1] = { name, guildId }
    end
  end
end

function _addon.core.memberCharacterVars(charName, memberId, guildId)
  if _SGTcharacterList[charName] == nil then
    _SGTcharacterList[charName] = {}
  end

  if _SGTcharacterList[charName]["guilds"] == nil then
    _SGTcharacterList[charName]["guilds"] = {}

    _SGTcharacterList[charName].id = memberId
    _SGTcharacterList[charName].gid = guildId
  end
end

-- AccountList
function _addon.core.createAccountList()
  local numGuild = GetNumGuilds()

  for guildId = 1, numGuild do
    local name = GetGuildName(guildId)
    local numMember = GetNumGuildMembers(guildId)

    for memberId = 1, numMember, 1 do
      local charData = { GetGuildMemberCharacterInfo(guildId, memberId) }
      local memberData = { GetGuildMemberInfo(guildId, memberId) }
      local accName = memberData[1]
      local charName = charData[2]

      _addon.core.memberCreateAccountVars(accName, charName, memberId, guildId)

      local _SGTaccountList = _SGTaccountList[accName]["guilds"]
      _SGTaccountList[#_SGTaccountList + 1] = { name, guildId }
    end
  end
end

function _addon.core.memberCreateAccountVars(accName, charName, memberId, guildId)
  if _SGTaccountList[accName] == nil then
    _SGTaccountList[accName] = {}
  end

  if _SGTaccountList[accName]["guilds"] == nil then
    _SGTaccountList[accName]["guilds"] = {}

    _SGTaccountList[accName].charName = charName
    _SGTaccountList[accName].id = memberId
    _SGTaccountList[accName].gid = guildId
  end
end

function _addon.core.chatButton(button)
  checkSetting = _addon.checkSetting
   if (button == 1) then
    if (checkSetting("ShissuNotebook")) then
      if (SGT_Notebook:IsHidden()) then
        SGT_Notebook:SetHidden(false)
      else
        SGT_Notebook:SetHidden(true)
      end
    end
   elseif (button == 2) then
    if (checkSetting("ShissuTeleporter")) then
      if (SGT_Teleport:IsHidden()) then
        SGT_Teleport:SetHidden(false)
      else
        SGT_Teleport:SetHidden(true)
      end
    end
   elseif (button == 3) then
    if (checkSetting("ShissuMarks")) then
      if (SGT_Marks:IsHidden()) then
        SGT_Marks:SetHidden(false)
      else
        SGT_Marks:SetHidden(true)
      end
    end
  end
end

-- Module in Abhängigkeit der Einstellungen
function _addon.loadModule(moduleName, moduleInit, moduleDepends)
  local controls = _addon.controls

  local moduleText = GetString(moduleName) or moduleName

  _addon.settings["module"] = _addon.settings["module"] or {}

  if (_addon.settings["module"][moduleInit] == nil) then
    _addon.settings["module"][moduleInit] = true
  end

  if (_module[moduleInit] ~= nil) then return end


  controls[#controls+1] = {
    type = "checkbox",
    name = moduleText,
    getFunc = _addon.settings["module"][moduleInit],
    setFunc = function(_, value)
      _addon.settings["module"][moduleInit] = value

      if (value) then
        if (_module[moduleInit] ~= nil) then return end

        Shissu_SuiteManager.InitializedAddon(moduleInit)
        _module[moduleInit] = 1
      end
    end,
  }

  if (_addon.settings["module"][moduleInit]) then
    if (_module[moduleInit] ~= nil) then return end

    Shissu_SuiteManager.InitializedAddon(moduleInit)
    _module[moduleInit] = 1
  end
end

function _addon.checkSetting(savedVar)
  if (_addon.settings["module"]) then
    if (_addon.settings["module"][savedVar]) then
        return _addon.settings["module"][savedVar]
      end
  end
end

-- Initialize Event
function _addon.EVENT_ADD_ON_LOADED(_, addOnName)
  if addOnName ~= _addon.Name then return end

  zo_callLater(function()
    Shissu_SuiteManager.InitializedAddon(_addon.Name)

    -- fest eingeschaltete Module
    Shissu_SuiteManager.InitializedAddon("ShissuColor")

    -- Variable Module
    _addon.loadModule(ShissuAutoAFK, "ShissuAutoAFK")
    _addon.loadModule(ShissuNotifications, "ShissuNotifications")
    _addon.loadModule(ShissuChat, "ShissuChat")
    _addon.loadModule(ShissuHistory, "ShissuHistory")
    _addon.loadModule(ShissuRoster, "ShissuRoster")
    _addon.loadModule(ShissuGuildHome, "ShissuGuildHome")
    _addon.loadModule(ShissuMemberStatus, "ShissuMemberStatus")
    _addon.loadModule(ShissuContextMenu, "ShissuContextMenu")
    _addon.loadModule(ShissuMarks, "ShissuMarks")
    _addon.loadModule(ShissuTeleporter, "ShissuTeleporter")
    _addon.loadModule(ShissuWelcomeInvite, "ShissuWelcomeInvite")
    _addon.loadModule(ShissuNotebook, "ShissuNotebook")
    _addon.loadModule(ShissuNotebookMail, "ShissuNotebookMail")

    --_addon.loadModule(ShissuRoster, "ShissuCollectedData")

    local checkSetting = _addon.checkSetting

    if checkSetting("ShissuRoster") then
      _addon.loadModule(ShissuScanner, "ShissuScanner")
    end

    if checkSetting("ShissuNostebook") then
      _addon.loadModule(ShissuNotebookMail, "ShissuNotebookMail")
    end

    -- Button für Notizbuch, Teleporter, Blockliste
    if (checkSetting("ShissuNotebook") or checkSetting("ShissuTeleporter") or checkSetting("ShissuMarker")) then
      ZO_ChatWindowOptions:SetAnchor(TOPRIGHT, ZO_ChatWindow, TOPRIGHT, -50, 6 )
      SGT_ZO_ToogleButton:SetParent(ZO_ChatWindowOptions:GetParent() )

      local buttonText = ""

      if (checkSetting("ShissuNotebook")) then
        buttonText = blue .. getString(ShissuModule_leftMouse) .. white .. " - " .. getString(ShissuNotebook)
      end

      if (checkSetting("ShissuMarks")) then
        if (string.len(buttonText) > 2) then
          buttonText = buttonText .. "\n"
        end

        buttonText = buttonText .. blue .. getString(ShissuModule_middleMouse) .. white .. " - " .. getString(ShissuMarks)
      end

      if (checkSetting("ShissuTeleporter")) then
        if (string.len(buttonText) > 2) then
          buttonText = buttonText .. "\n"
        end

        buttonText = buttonText .. blue .. getString(ShissuModule_rightMouse) .. white .. " - " .. getString(ShissuTeleporter)
      end

      SGT_ZO_ToogleButton:SetHandler("OnMouseEnter", function(self) toolTip(self, buttonText) end)
      SGT_ZO_ToogleButton:SetHandler("OnMouseExit", ZO_Tooltips_HideTextTooltip)
      SGT_ZO_ToogleButton:SetHandler("OnMouseUp", function(_, button) _addon.core.chatButton(button) end)
    end
  end, 500);

  EVENT_MANAGER:UnregisterForEvent(_addon.Name, EVENT_ADD_ON_LOADED)
end

-- Übergabe an der Suite
Shissu_SuiteManager._settings[_addon.Name] = {}
Shissu_SuiteManager._settings[_addon.Name].panel = _addon.panel
Shissu_SuiteManager._settings[_addon.Name].controls = _addon.controls
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized

ZO_CreateStringId("SI_BINDING_NAME_SGT_Marks", "Markierungen")
ZO_CreateStringId("SI_BINDING_NAME_SGT_Notes", "Notizbuch")
ZO_CreateStringId("SI_BINDING_NAME_SGT_Teleporter", "Teleporter")

Shissu_SuiteManager._bindings[_addon.Name] = {}
Shissu_SuiteManager._bindings[_addon.Name].marks = function()
  checkSetting = _addon.checkSetting

  if (checkSetting("ShissuMarks")) then
    if (SGT_Marks:IsHidden()) then
      SGT_Marks:SetHidden(false)
    else
      SGT_Marks:SetHidden(true)
    end
  end
end

Shissu_SuiteManager._bindings[_addon.Name].notes = function()
  checkSetting = _addon.checkSetting

  if (checkSetting("ShissuNotebook")) then
    if (SGT_Notebook:IsHidden()) then
      SGT_Notebook:SetHidden(false)
    else
      SGT_Notebook:SetHidden(true)
    end
  end
end

Shissu_SuiteManager._bindings[_addon.Name].teleport = function()
  checkSetting = _addon.checkSetting

  if (checkSetting("ShissuTeleporter")) then
    if (SGT_Teleport:IsHidden()) then
      SGT_Teleport:SetHidden(false)
    else
      SGT_Teleport:SetHidden(true)
    end
  end
end

-- Not offical, testing
function checkGoldDeposits(guildName, goldDeposit)
  local lastKiosk = _SGT.getKioskTime(0, -1, true)
  local _history = shissuGT["History"]

  d("1: " .. GetDateStringFromTimestamp(lastKiosk) .. " - " .. ZO_FormatTime((lastKiosk) % 86400, TIME_FORMAT_STYLE_CLOCK_TIME, TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR))

  local daySeconds = 60 * 60 *24
  local weekSeconds = 7 * daySeconds + daySeconds

  -- GuildId?
  local numGuild = GetNumGuilds()
  local guildId = nil

  for gId = 1, numGuild do
    if (guildName == GetGuildName(gId)) then
      d("Gilde gefunden: " .. guildName .. "(" .. gId .. ")")
      guildId = gId
      break
    end
  end

  if (guildId ~= nil) then
    local reminderText = guildName .. " Reminder\n" .. gold .. " Gold"
    local numMember = GetNumGuildMembers(guildId)
    local numCount = 1
    local notPayed = 0
    local waitOnEdit = 0

    EVENT_MANAGER:RegisterForUpdate("SGT_NOTE_SALE_EDIT", 1300, function()
      local memberData = { GetGuildMemberInfo(guildId, numMember) }
      local note = memberData[2]
      local displayName = memberData[1]

      d(numCount .. " CHECK NAME: " .. displayName)

      if (waitOnEdit == 1) then
        if (string.find(note, reminderText)) then
          waitOnEdit = 0
        end
      else
        if _history[guildName] then
          if _history[guildName][displayName]  then
            if _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED] then
              local lastTime = _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].timeLast
              --d("1: " .. GetDateStringFromTimestamp(lastTime) .. " - " .. ZO_FormatTime((lastTime) % 86400, TIME_FORMAT_STYLE_CLOCK_TIME, TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR))

              if (lastTime) then
                if (lastTime > lastKiosk) then
                  -- Zeit ist korrekt
                  d("--> OK")
                else
                  if (string.find(note, reminderText)) then
                    d("--> REMINDER EXISTS")

                    --note = string.gsub(note, reminderText, "")
                    --note = string.gsub(note, "\n", "")
                    --SetGuildMemberNote(1, count, note)
                  else
                    local gold = _history[guildName][displayName][GUILD_EVENT_BANKGOLD_ADDED].last
                    local goldWeek = gold / goldDeposit
                    local addTime = goldWeek * weekSeconds
                    local newLastTime = lastTime + addTime

                    if (newLastTime < lastKiosk or gold == 0) then
                      d(count .. " NAME (NICHT GEZAHLT): " .. displayName)

                      local newNote = note .. "\n" .. reminderText
                      notPayed = notPayed + 1
                      waitOnEdit = 1
                      SetGuildMemberNote(guildId, count, newNote)
                    end
                  end
                end
              end
            end
          end
        end
      end

      if (count == numMember) then
        EVENT_MANAGER:UnregisterForUpdate("SGT_NOTE_SALE_EDIT")
      end

      if (cache == 0) then
        numCount = numCount + 1
      end
    end)

    d("Es haben " .. notPayed .. " Spieler nicht bezahlt")
  else
    d("KEINE Gilde gefunden: " .. guildName)
  end
end

EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_ADD_ON_LOADED, _addon.EVENT_ADD_ON_LOADED)
