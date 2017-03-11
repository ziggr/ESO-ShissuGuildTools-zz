-- Shissu GuildTools Module File
--------------------------------
-- File: notifications.lua
-- Version: v1.2.0
-- Last Update: 07.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!

local _addon = {}
_addon.Name	= "ShissuNotifications"
_addon.Version = "1.1.8"
_addon.core = {}

local _globals = Shissu_SuiteManager._globals
local blue = _globals["color"]["blue"]
local white = _globals["color"]["white"]

local _lib = Shissu_SuiteManager._lib
local _SGT = Shissu_SuiteManager._lib["SGT"]
local getString = _SGT.getString

_addon.fN = _SGT["title"](getString(ShissuNotifications))

_addon.settings = {
  ["mail"] = false,
  ["inSight"] = {},
  ["motD"] = {},
  ["background"] = {},
  ["raid"] = { true, true },
  ["friend"] = true,
}

_addon.panel = _lib.setPanel(getString(ShissuNotifications), _addon.fN, _addon.Version)
_addon.controls = {}

local fString = {
  ["mail"] = blue .. getString(ShissuNotifications_info) .. "|r " .. getString(ShissuNotifications_mail),
  ["inSight"] = blue .. getString(ShissuNotifications_info) .. "|r " .. getString(ShissuNotifications_inSight),
  ["motD"] = blue .. getString(ShissuNotifications_info) .. "|r " .. getString(ShissuNotifications_motD),
  ["friend"] = blue .. getString(ShissuNotifications_info) .. "|r " .. getString(ShissuNotifications_friend),
  ["background"] = blue .. getString(ShissuNotifications_info) .. "|r " .. getString(ShissuNotifications_background),
  ["friendRaid"] = blue .. getString(ShissuNotifications) .. "|r " .. getString(Shissu_friend),
  ["guild"] = blue .. getString(ShissuNotifications) .. "|r " .. getString(ShissuNotifications_guild),
}

function _addon.core.createControls()
  local controls = _addon.controls

  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuGeneral),
   }

  controls[#controls+1] = {
    type = "checkbox",
    name = fString["mail"],
    getFunc = _addon.settings["mail"],
    setFunc = function(_, value)
      _addon.settings["mail"] = value

      if (not value) then
        MAIL_INBOX.Delete = _addon.core.mailInBoxDelete
      end
    end,
  }

  controls[#controls+1] = {
    type = "checkbox",
    name = fString["friend"],
    getFunc = _addon.settings["friend"],
    setFunc = function(_, value)
      _addon.settings["friend"] = value

      if (not value) then
        _addon.core.deactiveFriendStatus()
      end
    end,
  }

  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuNotifications_rank),
  }

  controls[#controls+1] = {
    type = "checkbox",
    name = fString["guild"],
    getFunc = _addon.settings["raid"][1],
    setFunc = function(_, value)
      _addon.settings["raid"][1] = value
    end,
  }

  controls[#controls+1] = {
    type = "checkbox",
    name = fString["friendRaid"],
    getFunc = _addon.settings["raid"][2],
    setFunc = function(_, value)
      _addon.settings["raid"][2] = value
    end,
  }
end

function _addon.core.createGuildSettings(title)
  local controls = _addon.controls

  controls[#controls+1] = {
    type = "title",
    name = fString[title],
  }

  local numGuild = GetNumGuilds()

  for guildId = 1, numGuild do
    local name = GetGuildName(guildId)

    controls[#controls+1] = {
      type = "checkbox",
      name = name,
      getFunc = _addon.settings[title][name],
      setFunc = function(_, value)
        _addon.settings[title][name] = value
      end,
    }
  end
end

-- Mail Benachrichtigungen
-- Original ZOS LUA Code + Modifikation: esoui\ingame\mail\keyboard\mailinbox_keyboard.lua, Version 08.03.2017
function _addon.core.mailInBoxDelete(self)
  if self.mailId then
    if self:IsMailDeletable() then
      local numAttachments, attachedMoney = GetMailAttachmentInfo(self.mailId)

      if numAttachments > 0 and attachedMoney > 0 then
        ZO_Dialogs_ShowDialog("DELETE_MAIL_ATTACHMENTS_AND_MONEY", self.mailId)
      elseif numAttachments > 0 then
        ZO_Dialogs_ShowDialog("DELETE_MAIL_ATTACHMENTS", self.mailId)
      elseif attachedMoney > 0 then
        ZO_Dialogs_ShowDialog("DELETE_MAIL_MONEY", self.mailId)
      else
        if _addon.settings["mail"] then
          ZO_Dialogs_ShowDialog("DELETE_MAIL", {callback = function(...) self:ConfirmDelete(...) end, mailId = self.mailId})
        else
          self:ConfirmDelete(self.mailId)
        end
      end
    end
  end
end

function _addon.core.deactiveFriendStatus()
  ZO_PreHook(ZO_ChatSystem_GetEventHandlers(), EVENT_FRIEND_PLAYER_STATUS_CHANGED, function() return true end )
  EVENT_MANAGER:UnregisterForEvent( "FriendsList", EVENT_FRIEND_PLAYER_STATUS_CHANGE)
end

-- GuildMoTD deaktivieren
-- Original ZOS LUA Code + Modifikation: notifications_common.lua, Version 01.09.2015
function ZO_GuildMotDProvider:BuildNotificationList()
  if self.sv then
    ZO_ClearNumericallyIndexedTable(self.list)
    local numGuilds = GetNumGuilds()

    for i = 1, numGuilds do
      local guildId = GetGuildId(i)

      if _addon.settings["motD"][guildId] then
        local guildName = GetGuildName(guildId)
        local savedMotDHash = self.sv[guildName]
        local currentMotD = GetGuildMotD(guildId)
        local currentMotDHash = HashString(currentMotD)

        if savedMotDHash == nil then
          self.sv[guildName] = currentMotDHash
        elseif savedMotDHash ~= currentMotDHash then
          local guildAlliance = GetGuildAlliance(guildId)
          local message = self:CreateMessage(guildAlliance, guildName)
          table.insert(self.list,
          {
            dataType = NOTIFICATIONS_ALERT_DATA,
            notificationType = NOTIFICATION_TYPE_GUILD_MOTD,
            note = currentMotD,
            message = message,
            guildId = guildId,
            shortDisplayText = guildName,
          })
        end
      end
    end
  end
end

-- Leaderbord Raid deaktivieren
function ZO_LeaderboardRaidProvider:BuildNotificationList()
    ZO_ClearNumericallyIndexedTable(self.list)
    if GetSetting_Bool(SETTING_TYPE_UI, UI_SETTING_SHOW_LEADERBOARD_NOTIFICATIONS) then
        for notificationIndex = 1, GetNumRaidScoreNotifications() do
            local notificationId = GetRaidScoreNotificationId(notificationIndex)
            local raidId, raidScore, millisecondsSinceRequest = GetRaidScoreNotificationInfo(notificationId)
            local numMembers = GetNumRaidScoreNotificationMembers(notificationId)
            local numKnownMembers = 0
            local hasFriend = false
            local hasGuildMember = false
            local hasPlayer = false
            for memberIndex = 1, numMembers do
                local displayName, characterName, isFriend, isGuildMember, isPlayer = GetRaidScoreNotificationMemberInfo(notificationId, memberIndex)

                hasFriend = hasFriend or isFriend
                hasGuildMember = hasGuildMember or isGuildMember
                hasPlayer = hasPlayer or isPlayer

                if isFriend or isGuildMember then
                    numKnownMembers = numKnownMembers + 1
                end
            end

            if hasPlayer then
                -- Player just received a notification about themselves, so filter it out
                self:Decline({ notificationId = notificationId, })
            elseif (hasFriend and _addon.settings["raid"][2]) or (_addon.settings["raid"][1] and hasGuildMember) then
                local raidName = GetRaidName(raidId)

                table.insert(self.list,
                {
                    dataType = NOTIFICATIONS_LEADERBOARD_DATA,
                    notificationId = notificationId,
                    raidId = raidId,
                    notificationType = NOTIFICATION_TYPE_LEADERBOARD,
                    secsSinceRequest = ZO_NormalizeSecondsSince(millisecondsSinceRequest / 1000),
                    message = self:CreateMessage(raidName, raidScore, numKnownMembers, hasFriend, hasGuildMember, notificationId),
                    shortDisplayText = zo_strformat(SI_NOTIFICATIONS_LEADERBOARD_RAID_NOTIFICATION_SHORT_TEXT_FORMATTER, raidName),
                })


            end
        end
    end
end

-- EVENT_GUILD_DESCRIPTION_CHANGED (integer eventCode, integer guildId)
function _addon.core.guildDescriptionChanged(_, guildId)
  local guildId = GetGuildId(guildId)


  local guildName = GetGuildName(guildId)
  local guildDescription = GetGuildDescription(guildId)

  local allianceIcon = zo_iconFormat(GetAllianceBannerIcon(guildId), 24, 24)

  local text = white .. getString(ShissuNotifications_background) .. " " .. getString(ShissuNotifications_background2)  .. " " .. allianceIcon .. blue .. guildName .. " " .. getString(ShissuNotifications_background3)
    .. "|r:\n\n|ceeeeee" .. guildDescription

  d(text)
end

function _addon.core.memberInSight(_, name)
  local target = GetUnitName('reticleover')
  local unitName = GetRawUnitName('reticleover')
  local count = 0

  ZO_Tooltips_HideTextTooltip()

  if unitName ~= "" and _SGTcharacterList[unitName] then
    local memberData = _SGTcharacterList[unitName]

    if memberData then
      local _, _, _, class, alliance, lvl, vr = GetGuildMemberCharacterInfo( memberData["gid"], memberData["id"])
      local text = GetGuildMemberInfo(memberData["gid"], memberData["id"])

      local acc = text
      local charName = _lib.cutStringAtLetter(unitName, '^')

      local class = "|t28:28:" .. GetClassIcon(class) .. "|t"
      local alliance = "|t28:28:" .. GetAllianceBannerIcon(alliance) .. "|t"

      text = blue .. acc .. "\n"
      text = text .. alliance .. class .. "|ceeeeee" .. charName

      if vr == 0 then
        text = text .. " |ceeeeee(|cAFD3FFLvL " .. "|ceeeeee" .. lvl .. ")"
      else
        text = text .. " |ceeeeee(|cAFD3FFCP " .. "|ceeeeee" .. vr .. ")"
      end

      if (_addon.settings["inSight"][1] or _addon.settings["inSight"][2] or _addon.settings["inSight"][3] or _addon.settings["inSight"][4] or _addon.settings["inSight"][5]) then
        memberData = memberData["guilds"]

        local first = 0

        for numGuild = 1, #memberData do
          if (_addon.settings["inSight"][1] and memberData[numGuild][2] == 1
          or _addon.settings["inSight"][2] and memberData[numGuild][2] == 2
          or _addon.settings["inSight"][3] and memberData[numGuild][2] == 3
          or _addon.settings["inSight"][4] and memberData[numGuild][2] == 4
          or _addon.settings["inSight"][5] and memberData[numGuild][2] == 5) then

            count = count + 1

            if (first == 0) then
              first = 1
              text = text .. "\n\n"
            end

            text = text .. "|ceeeeee" .. memberData[numGuild][1]

            if numGuild ~= #memberData then
              text = text .. "\n"
            end
          end
        end
      end

      if (count > 0 ) then
        ZO_Tooltips_ShowTextTooltip(SGT_notificationsInSight, TOPRIGHT, text)
      end
    end
  end
end

-- Initialisierung
function _addon.core.initialized()
  shissuGT = shissuGT or {}
  shissuGT[_addon.Name] = shissuGT[_addon.Name] or _addon.settings
  _addon.settings = shissuGT[_addon.Name]

  if (not _addon.settings.mail) then
    MAIL_INBOX.Delete = _addon.core.mailInBoxDelete
  end

  if (not _addon.settings.friend) then _addon.core.deactiveFriendStatus() end

  -- Hat jemand die neue SaveVar schon?
  if (_addon.settings["inSight"] == nil) then _addon.settings["inSight"] = {} end
  if (_addon.settings["motD"] == nil) then _addon.settings["motD"] = {} end
  if (_addon.settings["background"] == nil) then _addon.settings["background"] = {} end

  for guildId=1, GetNumGuilds() do
    local guildName = GetGuildName(guildId)
    if (_addon.settings["inSight"][guildName] == nil) then _addon.settings["inSight"][guildName] = true end
    if (_addon.settings["motD"][guildName] == nil) then _addon.settings["motD"][guildName] = true end
    if (_addon.settings["background"][guildName] == nil) then _addon.settings["background"][guildName] = true end
  end

  _addon.core.createControls()
  _addon.core.createGuildSettings("inSight")
  _addon.core.createGuildSettings("motD")
  _addon.core.createGuildSettings("background")

  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_GUILD_DESCRIPTION_CHANGED, _addon.core.guildDescriptionChanged)
  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_RETICLE_TARGET_CHANGED, _addon.core.memberInSight)
end

Shissu_SuiteManager._settings[_addon.Name] = {}
Shissu_SuiteManager._settings[_addon.Name].panel = _addon.panel
Shissu_SuiteManager._settings[_addon.Name].controls = _addon.controls
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized
