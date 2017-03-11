-- Shissu GuildTools Module File
--------------------------------
-- File: contextmenu.lua
-- Version: v1.0.6
-- Last Update: 06.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!

local ZOS_ShowPlayerContextMenu = CHAT_SYSTEM.ShowPlayerContextMenu
local ZOS_MailInboxRow_OnMouseUp = ZO_MailInboxRow_OnMouseUp
local ZOS_GUILD_ROSTER_KEYBOARD = GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp

local _lib = Shissu_SuiteManager._lib
local _SGT = Shissu_SuiteManager._lib["SGT"]
local getString = _SGT.getString

local _globals = Shissu_SuiteManager._globals
local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]

local _addon = {}
_addon.Name	= "ShissuContextMenu"
_addon.Version = "1.0.7"
_addon.core = {}
_addon.fN = _SGT["title"](getString(ShissuContextMenu))

_addon.settings = {
  guild = true,
  chatNewMail = true,
  chatInvite = true,
  mailAnswer = true,
  mailInvite = true,
}

_addon.panel = _lib.setPanel(getString(ShissuContextMenu), _addon.fN, _addon.Version)
_addon.controls = {}

local _personalNote = {}

function _addon.core.createControls()
  local controls = _addon.controls

  controls[#controls+1] = {
    type = "title",
    name = getString(Shissu_chat),
  }

  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuContextMenu_newMail),
    getFunc = _addon.settings["chatNewMail"],
    setFunc = function(_, value)
      _addon.settings["chatNewMail"] = value
      _addon.core.chat()
    end,
  }

  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuContextMenu_invite),
    getFunc = _addon.settings["chatInvite"],
    setFunc = function(_, value)
      _addon.settings["chatInvite"] = value
      _addon.core.chat()
    end,
  }

  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuContextMenu_mail),
  }

  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuContextMenu_answer),
    getFunc = _addon.settings["mailAnswer"],
    setFunc = function(_, value)
      _addon.settings["mailAnswer"] = value
      ZO_MailInboxRow_OnMouseUp = _addon.core.MailOnMouseUp
    end,
  }

  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuContextMenu_invite),
    getFunc = _addon.settings["mailInvite"],
    setFunc = function(_, value)
      _addon.settings["mailInvite"] = value
      ZO_MailInboxRow_OnMouseUp = _addon.core.MailOnMouseUp
    end,
  }

  controls[#controls+1] = {
    type = "title",
    name = getString(Shissu_guild),
  }

  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuContextMenu_invite),
    getFunc = _addon.settings["guild"],
    setFunc = function(_, value)
      _addon.settings["guild"] = value
      GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp = _addon.core.GuildRosterRow_OnMouseUp
    end,
  }
end

function _addon.core.guildInvite(displayName)
  for i = 1, GetNumGuilds() do
    local guildId = GetGuildId(i)

    if DoesPlayerHaveGuildPermission(guildId, GUILD_PERMISSION_INVITE) then
      local GuildName = GetGuildName(guildId)

      AddMenuItem(string.gsub(getString(ShissuContextMenu_inviteC), "%%1", GuildName), function()
        GuildInvite(guildId, displayName)

        local allowInvite = shissuGT["ShissuWelcomeInvite"]["invite"][GuildName]

        if allowInvite then
          local currentText = CHAT_SYSTEM.textEntry:GetText()

          if string.len(currentText) < 1 then
            local welcomeString = shissuGT["ShissuWelcomeInvite"]["message"][GuildName]

              if welcomeString then
                  local chatMessageArray = Shissu_SuiteManager._lib.splitToArray(welcomeString, "|")
                  local rnd = math.random(#chatMessageArray)
                  local chatMessage = string.gsub(chatMessageArray[rnd], "%%1", displayName)
                  chatMessage = string.gsub(chatMessage, "%%2", GuildName)

                  local text = "/g" .. guildId .. " " .. chatMessage
                  ZO_ChatWindowTextEntryEditBox:SetText(text)
            end
          end
        end
      end)
    end
  end
end

function _addon.core.contextHead(previous)
  if (not previous) then previous = 1 end
  local func = function() end

  if (previous == 1) then AddMenuItem(" ", func, nil, "$(CHAT_FONT)|1|shadow") end
  AddMenuItem("|cAFD3FFShissu's|r|ceeeeee Guild Tools", func, nil, "$(ANTIQUE_FONT)|16")
  AddMenuItem(" ", func, nil, "$(CHAT_FONT)|1|shadow")
end

function _addon.core.chat()
  CHAT_SYSTEM.ShowPlayerContextMenu = function(self, displayName, rawName)
    ZOS_ShowPlayerContextMenu(self, displayName, rawName)

    if _addon.settings["chatNewMail"] or _addon.settings["chatInvite"] then _addon.core.contextHead() end

    if _addon.settings["chatNewMail"] then

      AddMenuItem("|ceeeeee".. getString(ShissuContextMenu_newMail), function()
        SCENE_MANAGER:Show('mailSend') ZO_MailSendToField:SetText(displayName)
      end)
    end

    if _addon.settings["chatInvite"] then _addon.core.guildInvite(displayName) end

    if ZO_Menu_GetNumMenuItems() > 0 then ShowMenu() end
  end
end

-- KONTEXTMENÜ: E-Mail Fenster (Empfangen)
function _addon.core.MailOnMouseUp(control, button)
  ClearMenu()
  ZOS_MailInboxRow_OnMouseUp(control, button)

  if (button ~= 2) then return end
  if (_addon.settings["mailAnswer"] or _addon.settings["mailInvite"]) then
    _addon.core.contextHead(0)
  end

  if _addon.settings["mailAnswer"] then
    AddMenuItem(white .. getString(ShissuContextMenu_newMail), function() SCENE_MANAGER:Show('mailSend') ZO_MailSendToField:SetText(GetMailSender(control.dataEntry.data.mailId)) end)
    AddMenuItem(white .. getString(ShissuContextMenu_answer2), function()
      SCENE_MANAGER:Show('mailSend')
      ZO_MailSendToField:SetText(GetMailSender(control.dataEntry.data.mailId))
      ZO_MailSendSubjectField:SetText(getString(ShissuContextMenu_answer_prefix) .. control.dataEntry.data.subject)
    end)

    AddMenuItem(white .. getString(ShissuContextMenu_forward), function()
      SCENE_MANAGER:Show('mailSend')
      ZO_MailSendSubjectField:SetText(getString(ShissuContextMenu_forward_prefix) .. control.dataEntry.data.subject)
      ZO_MailSendBodyField:SetText(ZO_MailInboxMessageBody:GetText())
    end)

    AddMenuItem(white .. getString(ShissuContextMenu_del), function()
      DeleteMail(control.dataEntry.data.mailId, control.dataEntry.data.confirmedDelete)
      MAIL_INBOX:RefreshData()
    end)
  end

  if _addon.settings["mailInvite"] then
    _addon.core.guildInvite(GetMailSender(control.dataEntry.data.mailId))
  end

  ShowMenu()
end

-- KONTEXTMENÜ: Gildenroster
-- Original ZOS Code + SGT Code: esoui\ingame\guild\keyboard\guildroster_keyboard.lua
-- Original Version Date: 01.09.2015
function _addon.core.GuildRosterRow_OnMouseUp(self, control, button, upInside)
  local data = ZO_ScrollList_GetData(control)

  data.characterName = string.gsub(data.characterName, "|ceeeeee", "")
  ZOS_GUILD_ROSTER_KEYBOARD(self, control, button, upInside)

  if (button ~= MOUSE_BUTTON_INDEX_RIGHT and not upInside) then return end

  --ClearMenu()

  if data then
    if (shissuGT["ShissuRoster"]) then
      if (shissuGT["ShissuRoster"]["colNote"]) or _addon.settings["guild"] then
        _addon.core.contextHead(1, self:ShowMenu(control))
      end
    elseif _addon.settings["guild"] then
      _addon.core.contextHead(1, self:ShowMenu(control))
    end

    if _addon.settings["guild"] then
      _addon.core.guildInvite(data.displayName)
    end

    -- Persönliche Notizen
    _addon.core.persNote(data)

    self:ShowMenu(control)
  end
end

-- Persönliche Notizen
function _addon.core.persNote(data)
  if (shissuGT) then
    if (shissuGT["ShissuRoster"]) then
      if (shissuGT["ShissuRoster"]["colNote"]) then
        AddMenuItem(white .. getString(ShissuContextmenu_note), function(self)
          zo_callLater(function()
            local guildId = GUILD_ROSTER_MANAGER:GetGuildId()
            local notes = ""
            local displayName = data.displayName

            if _personalNote[guildId] == nil then
              _personalNote[guildId] = {}
              notes = ""
            end

            if _personalNote[guildId][displayName] == nil then
              notes = ""
            else
              notes = _personalNote[guildId][displayName]
            end

            ZO_Dialogs_ShowDialog("EDIT_NOTE", {displayName = data.displayName, note = notes, changedCallback = _addon.core.personalNoteChange})
          end, 50)
        end)
      end
    end
  end
end

function _addon.core.personalNoteChange(displayName, note)
  local guildId = GUILD_ROSTER_MANAGER:GetGuildId()

  if guildId == nil then return false end
  if displayName == nil then return false end

  -- Variablen erstellen, falls nicht vorhanden, und danach abspeichern
  if _personalNote[guildId] == nil then _personalNote[guildId] = {} end

  --if (string.len(note) > 0) then
    if _personalNote[guildId] ~= nil then
      _personalNote[guildId][displayName] = note
    else
      _personalNote[guildId] = {}
      _personalNote[guildId][displayName] = note
    end
 -- end

  GUILD_ROSTER_MANAGER:RefreshData()
end

-- Initialisierung
function _addon.core.initialized()
  shissuGT = shissuGT or {}

  shissuGT[_addon.Name] = shissuGT[_addon.Name] or _addon.settings
  _addon.settings = shissuGT[_addon.Name]

  shissuGT.PersonalNote = shissuGT.PersonalNote or {}
  _personalNote = shissuGT.PersonalNote

  _addon.core.createControls()

  if _addon.settings["chatNewMail"] or _addon.settings["chatInvite"] then
    _addon.core.chat()
  end

  if (_addon.settings["mailAnswer"] or _addon.settings["mailInvite"]) then
    ZO_MailInboxRow_OnMouseUp = _addon.core.MailOnMouseUp
  end

  GUILD_ROSTER_KEYBOARD.GuildRosterRow_OnMouseUp = _addon.core.GuildRosterRow_OnMouseUp
end

Shissu_SuiteManager._settings[_addon.Name] = {}
Shissu_SuiteManager._settings[_addon.Name].panel = _addon.panel
Shissu_SuiteManager._settings[_addon.Name].controls = _addon.controls
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized
