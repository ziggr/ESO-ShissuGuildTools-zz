-- Shissu GuildTools Module File
--------------------------------
-- File: chat.lua
-- Version: v1.2.12
-- Last Update: 08.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!

local _globals = Shissu_SuiteManager._globals
local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]

local _lib = Shissu_SuiteManager._lib
local _SGT = Shissu_SuiteManager._lib["SGT"]

local _i18nC = _SGT.i18nC
local _setPanel = _lib.setPanel
local getString = _SGT.getString

local _addon = {}
_addon.Name	= "ShissuChat"
_addon.Version = "1.2.12"
_addon.core = {}
_addon.fN = _SGT["title"](getString(ShissuChat))

_addon.panel = _setPanel(getString(ShissuChat), _addon.fN, _addon.Version)
_addon.controls = {}

_addon.settings = {
  ["time"] = true,
  ["date"] = true,
  ["guild"] = true,
  ["level"] = true,
  ["alliance"] = true,
  ["account"] = "Accountname",
  ["rank"] = true,
  ["autoWhisper"] = true,
  ["autoZone"] = true,
  ["autoGroup"] = true,
  ["whisperSound"] = "Benachrichtigung",
  ["auto"] = {},
  ["info"] = {},
  ["names"] = {},
}

local _sound = {
  [SOUNDS.NONE] = getString(ShissuNotebookMail_mailOff),
  [SOUNDS.EMPEROR_DEPOSED_ALDMERI] = "AVA 1",
  [SOUNDS.AVA_GATE_CLOSED] = "AVA 2",
  [SOUNDS.NEW_NOTIFICATION] = "Benachrichtigung",
  [SOUNDS.CHAMPION_POINTS_COMMITTED] =  "Championspunkte 1",
  [SOUNDS.CHAMPION_ZOOM_IN] =  "Championspunkte 2",
  [SOUNDS.CHAMPION_ZOOM_OUT] =  "Championspunkte 3",
  [SOUNDS.CHAMPION_STAR_MOUSEOVER] =  "Championspunkte 4",
  [SOUNDS.CHAMPION_CYCLED_TO_MAGE] =  "Championspunkte 5",
  [SOUNDS.BLACKSMITH_EXTRACTED_BOOSTER] =  "Crafting 1",
  [SOUNDS.ENCHANTING_ASPECT_RUNE_REMOVED] =  "Crafting 2",
  [SOUNDS.SMITHING_OPENED] =  "Crafting 3",
  [SOUNDS.GUILD_ROSTER_REMOVED] =  "Gilde 1",
  [SOUNDS.GUILD_ROSTER_ADDED] =  "Gilde 2",
  [SOUNDS.GUILD_WINDOW_OPEN] =  "Gilde 3",
  [SOUNDS.GROUP_DISBAND] = "Gruppe",
  [SOUNDS.DEFAULT_CLICK] = "Klick 1",
  [SOUNDS.EDIT_CLICK] = "Klick 2",
  [SOUNDS.STABLE_FEED_STAMINA] = "Misc 1",
  [SOUNDS.QUICKSLOT_SET] = "Quickslot",
  [SOUNDS.MARKET_CROWNS_SPENT] = "Shop",
}

function _addon.core.getSound()
  local soundStrings = {}

  for key, value in pairs(_sound) do
    table.insert(soundStrings, value)
  end

  table.sort(soundStrings)

  return soundStrings
end

function _addon.core.createSettingMenu()
  local controls = Shissu_SuiteManager._settings[_addon.Name].controls
  controls[#controls+1] = {
    type = "title",
    name = getString(Shissu_addInfo),
  }
  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuChat_time),
    getFunc = _addon.settings["time"],
    setFunc = function(_, value)
      _addon.settings["time"] = value
    end,
  }
  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuChat_date),
    getFunc = _addon.settings["date"],
    setFunc = function(_, value)
      _addon.settings["date"] = value
    end,
  }
  controls[#controls+1] = {
    type = "combobox",
    name = getString(ShissuChat_sound),
    items = _addon.core.getSound(),
    getFunc = _addon.settings["whisperSound"],
    setFunc = function(_, value)
      for key ,text in pairs(_sound) do
        if text == value then
          _addon.settings["whisperSound"] = key
          PlaySound(key)
        end
      end

    end,
  }
  controls[#controls+1] = {
    type = "combobox",
    name = getString(ShissuChat_char),
    items = { getString(ShissuChat_charAcc1), getString(ShissuChat_charAcc2), getString(ShissuChat_charAcc3) },
    getFunc = _addon.settings["account"],
    setFunc = function(_, value)
      _addon.settings["account"] = value
    end,
  }
  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuChat_guildInfo),
  }
  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuChat_guilds),
    getFunc = _addon.settings["guild"],
    setFunc = function(_, value)
      _addon.settings["guild"] = value
    end,
  }
  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuChat_rang),
    getFunc = _addon.settings["rank"],
    setFunc = function(_, value)
      _addon.settings["rank"] = value
    end,
  }
  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuChat_alliance),
    getFunc = _addon.settings["alliance"],
    setFunc = function(_, value)
      _addon.settings["alliance"] = value
    end,
  }
  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuChat_lvl),
    getFunc = _addon.settings["level"],
    setFunc = function(_, value)
      _addon.settings["level"] = value
    end,
  }

  controls[#controls+1] = {
    type = "description",
    text = blue .. getString(ShissuChat_guildWhich),
  }

  local numGuild = GetNumGuilds()

  for guildId = 1, numGuild do
    local guildName = GetGuildName(guildId)

    controls[#controls+1] = {
      type = "checkbox",
      name = guildName,
      getFunc = _addon.settings["info"][guildName],
      setFunc = function(_, value)
        _addon.settings["info"][guildName] = value
      end,
    }
  end

  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuChat_auto),
  }
  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuChat_whisper),
    getFunc = _addon.settings["autoWhisper"],
    setFunc = function(_, value)
      _addon.settings["autoWhisper"] = value
    end,
  }
  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuChat_party),
    getFunc = _addon.settings["autoGroup"],
    setFunc = function(_, value)
      _addon.settings["autoGroup"] = value
    end,
  }
  controls[#controls+1] = {
    type = "checkbox",
    name = "Zone",
    getFunc = _addon.settings["autoZone"],
    setFunc = function(_, value)
      _addon.settings["autoZone"] = value
    end,
  }

  controls[#controls+1] = {
    type = "description",
    text = blue .. getString(ShissuChat_guildchan),
  }

  for guildId = 1, numGuild do
    local guildName = GetGuildName(guildId)

    controls[#controls+1] = {
      type = "checkbox",
      name = guildName,
      getFunc = _addon.settings["auto"][guildName],
      setFunc = function(_, value)
        _addon.settings["auto"][guildName] = value
      end,
    }
  end

  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuChat_guildNames1),
  }

   controls[#controls+1] = {
    type = "description",
    text = blue .. getString(ShissuChat_guildNames2),
  }

  for guildId=1, GetNumGuilds() do
    guildName = GetGuildName(guildId)

    controls[#controls+1] = {
      type = "textbox",
      name = guildName,
      getFunc = _addon.settings["names"][guildName],
      setFunc = function(value, name)
        _addon.settings["names"][name] = value
      end,
    }
  end

end

function _addon.core.getGuildIdName(channelString)
  local guildId = nil
 -- d(channelString)

  if string.find(channelString, "guild1") then guildId = 1
  elseif string.find(channelString, "guild2") then guildId = 2
  elseif string.find(channelString, "guild3") then guildId = 3
  elseif string.find(channelString, "guild4") then guildId = 4
  elseif string.find(channelString, "guild5") then guildId = 5 end

  local guildName = GetGuildName(guildId)
  return {guildId, guildName}
end

function _addon.core.getGuildInfo(fromName, displayName)
  for guildId=1, GetNumGuilds() do
    local guildName = GetGuildName(guildId)

    if _addon.settings["info"] then
      if (_addon.settings["info"][guildName]) then
        local guildName = GetGuildName(guildId)

        for memberId=1, GetNumGuildMembers(guildId), 1 do
          local accInfo = {GetGuildMemberInfo(guildId, memberId)}
          local charInfo = {GetGuildMemberCharacterInfo(guildId, memberId)}
          local accName = accInfo[1]
          local charName = charInfo[2]

          if accName == fromName or charName == fromName then
            local charLvL = charInfo[6]

            local charAlliance = charInfo[5]
            charAlliance = zo_iconFormat(GetAllianceBannerIcon(charAlliance), 24, 24)

            local rang = GetGuildRankSmallIcon(GetGuildRankIconIndex(guildId, accInfo[3]))
            rang = "|t24:24:" .. rang .. "|t"

            if (accName == displayName) then
              charName = _lib.cutStringAtLetter(charName, '^')
            else
              charName = displayName
            end

            if charLvL == 50 and charInfo[7] > 0 then charLvL = "[CP" .. charInfo[7] .."]"
            else
              charLvL = " [" .. charLvL .. "]"
            end

            -- Liegen abgespeicherte Namen vor?
            if (_addon.settings["names"] ~= nil) then
              if (_addon.settings["names"][guildName] ~= nil) then
                return { guildName, _addon.settings["names"][guildName], guildId, charLvL, rang, charAlliance, charName}

              end
            else
              _addon.settings["names"] = {}
            end

            return { guildName, guildName, guildId, charLvL, rang, charAlliance, charName }
          end
        end
      end
    end
  end

  return ""
end

function _addon.core.chatMessageChannel(_, messageType, fromName, text, isCustomerService, fromDisplayName)
  local channelInfo = ZO_ChatSystem_GetChannelInfo()[messageType]


  -- Channel Wechsel
  if (channelInfo.switches ~= nil) then
    local currentText = CHAT_SYSTEM.textEntry:GetText()

    if string.len(currentText) < 1 then
      local channelString = string.sub(channelInfo.switches, 1, string.find (channelInfo.switches, " "))
      local allowSwitch = 0

      -- Flüstern
      if string.find(channelString, "tell") and _addon.settings["autoWhisper"] then
        allowSwitch = 1
        channelString = "/tell " .. fromDisplayName .. " "
      -- Gruppe
      elseif string.find(channelString, "party") and _addon.settings["autoGroup"] then
        allowSwitch = 1
      -- Zone
      elseif string.find(channelString, "zone") and _addon.settings["autoZone"] then
        allowSwitch = 1
      --Gilde
      else
        local guildName = _addon.core.getGuildIdName(channelString)[2]
        if (_addon.settings["auto"][guildName]) then
          allowSwitch = 1
        end
      end

      if (allowSwitch == 1) then
        ZO_ChatWindowTextEntryEditBox:SetText(channelString)
      end
    end
  end
end

function _addon.core.formatMessage(chanCode, from, text, isFromCustomerService, fromDisplayName, originalText, DDSBeforeAll, TextBeforeAll, DDSBeforeSender, TextBeforeSender, TextAfterSender, DDSAfterSender, DDSBeforeText, TextBeforeText, TextAfterText, DDSAfterText)
  local channelInfo = ZO_ChatSystem_GetChannelInfo()[chanCode]

  if not channelInfo or not channelInfo.format then return end

  local customerIcon = ""
  local channelLink = ""

  -- Namen
  local displayName = fromDisplayName
  local characterName = _lib.cutStringAtLetter(from, '^')
  local fromLink = displayName

  -- KrimsKrams von anderen AddOns
  local message = DDSBeforeAll .. TextBeforeAll
  fromLink = DDSBeforeSender .. TextBeforeSender .. fromLink .. TextAfterSender .. DDSAfterSender
  text = DDSBeforeText .. TextBeforeText .. text .. TextAfterText .. DDSAfterText

  -- CustomIcon (Gildenoffizier/Lead); Channel; From; Text
  local standardString = "%s%s %s%s: %s"

  -- CustomIcon; From; Text;
  local standardString2 = "%s %s%s: %s"

  -- Uhrzeit und Datum
  local chatTime = ""

  if _addon.settings["time"] or _addon.settings["time"] then
    chatTime = "|c8989A2" .. "[" .. "|r"

    if _addon.settings["date"] then
      local timeStamp = GetTimeStamp()
      chatTime = chatTime .. blue .. GetDateStringFromTimestamp(timeStamp)
    end

    if _addon.settings["time"] and _addon.settings["date"] then
      chatTime = chatTime .. " "
    end

    if _addon.settings["time"] then
      chatTime = chatTime .. white .. GetTimeString()
    end

    chatTime = chatTime .. "|c8989A2" .. "]" .. "|r "
  end

  -- Chatchannel: Link & Kontextmenü
  local channelName = GetChannelName(channelInfo.id)

  if channelInfo.channelLinkable and channelName then
    channelLink = ZO_LinkHandler_CreateChannelLink(channelName)
  elseif channelName then
    channelLink = "" .. channelName .. ""
  end

  local guildInfos = _addon.core.getGuildInfo(from, displayName)

  local origname = guildInfos[1]
  local guildName = guildInfos[2]
  local guildId = guildInfos[3]
  local guildLvL = guildInfos[4]
  local guildRang = guildInfos[5]
  local guildAlliance  = guildInfos[6]
  local guildChar  = guildInfos[7]

  local additionalInfo = ""

  if (chanCode >= CHAT_CHANNEL_GUILD_1 and guildId == 1 and _addon.settings["info"][origname])
     or (chanCode >= CHAT_CHANNEL_GUILD_2 and guildId == 2 and _addon.settings["info"][origname])
     or (chanCode >= CHAT_CHANNEL_GUILD_3 and guildId == 3 and _addon.settings["info"][origname])
     or (chanCode >= CHAT_CHANNEL_GUILD_4 and guildId == 4 and _addon.settings["info"][origname])
     or (chanCode >= CHAT_CHANNEL_GUILD_5 and guildId == 5 and _addon.settings["info"][origname]) then


    if (chanCode >= CHAT_CHANNEL_GUILD_1 and chanCode <= CHAT_CHANNEL_GUILD_5) then
      additionalInfo = ""
     -- d("GILDENCHAT")
    elseif (_addon.settings["guild"]) then
     -- d("ALLES ANDERE")
      additionalInfo = blue .. "[" .. guildName .. "]|r"
    end

    if (_addon.settings["alliance"]) then
      additionalInfo = additionalInfo .. guildAlliance
    end


    if (_addon.settings["rank"]) then
      additionalInfo = additionalInfo .. guildRang
    end

    if (_addon.settings["level"] == false) then
      guildLvL = ""
    end
  end

  -- Soundausgabe, beim Flüstern
  if chanCode == CHAT_CHANNEL_WHISPER and _addon.settings["whisperSound"] ~= getString(ShissuNotebookMail_mailOff) then
    PlaySound(_addon.settings["whisperSound"])
  end

  -- Customer, GM Support
  if isFromCustomerService then customerIcon = "|t16:16:EsoUI/Art/ChatWindow/csIcon.dds|t" end

  -- Spieler: Link & Kontextmenü
  if channelInfo.playerLinkable then fromLink = ZO_LinkHandler_CreatePlayerLink(fromLink) end

  -- Charaktername?, Accountname + Charaktername?
  if (_addon.settings["account"]) then
    if (_addon.settings["account"] == getString(ShissuChat_charAcc2)) then
      -- Nur Charakternamen
      fromLink = characterName

      if (chanCode >= CHAT_CHANNEL_GUILD_1 and chanCode <= CHAT_CHANNEL_GUILD_5 or chanCode == CHAT_CHANNEL_MONSTER_WHISPER or chanCode == CHAT_CHANNEL_SAY) then
        fromLink = guildChar -- _addon.core.getCharacterName(guildId, displayName)
      end

      if channelInfo.playerLinkable then fromLink = ZO_LinkHandler_CreatePlayerLink(fromLink) end
    elseif (_addon.settings["account"] == getString(ShissuChat_charAcc3)) then
      -- Account-, Charaktername
      fromLink = characterName

      if (chanCode >= CHAT_CHANNEL_GUILD_1 and chanCode <= CHAT_CHANNEL_GUILD_5 or chanCode == CHAT_CHANNEL_MONSTER_WHISPER or chanCode == CHAT_CHANNEL_SAY) then
        fromLink = guildChar
      end

      if (fromLink == displayName) then
        if fromLink == nil then fromLink = from end

        if channelInfo.playerLinkable then fromLink = ZO_LinkHandler_CreatePlayerLink(fromLink) end
      else
        if string.len(displayName) > 0 then
          if (fromLink ~= nil) then
            if channelInfo.playerLinkable then fromLink = ZO_LinkHandler_CreatePlayerLink(fromLink) end
          end
          if channelInfo.playerLinkable then displayName = ZO_LinkHandler_CreatePlayerLink(displayName) end

          fromLink = displayName .. fromLink
        else
          if channelInfo.playerLinkable then fromLink = ZO_LinkHandler_CreatePlayerLink(fromLink) end
        end

      end
    end
  end

  if (guildLvL ~= nil) then
    fromLink = fromLink .. guildLvL
  end

  if channelLink then
    message = chatTime .. string.format(standardString, customerIcon, channelLink, additionalInfo, fromLink, text)
  else
    message = chatTime .. string.format(standardString2, customerIcon, additionalInfo, fromLink, text)
  end

  return message
end

-- * Initialisierung
function _addon.core.initialized()
  shissuGT = shissuGT or {}

  shissuGT[_addon.Name] = shissuGT[_addon.Name] or _addon.settings
  _addon.settings = shissuGT[_addon.Name]

  -- Hat jemand die neue SaveVar schon?
  if (_addon.settings["info"] == nil) then _addon.settings["info"] = {} end
  if (_addon.settings["auto"] == nil) then _addon.settings["auto"] = {} end

  for guildId=1, GetNumGuilds() do
    local guildName = GetGuildName(guildId)
    if (_addon.settings["info"][guildName] == nil) then _addon.settings["info"][guildName] = true end
    if (_addon.settings["auto"][guildName] == nil) then _addon.settings["auto"][guildName] = true end
  end

  _addon.core.createSettingMenu()

  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_CHAT_MESSAGE_CHANNEL, _addon.core.chatMessageChannel)

  -- Vergrößerung der Chatbox, nun möglich
  CHAT_SYSTEM.maxContainerWidth, CHAT_SYSTEM.maxContainerHeight = GuiRoot:GetDimensions()

  local libChat = LibStub('libChat-1.0')
  libChat:registerFormat(_addon.core.formatMessage, "00000A" .. _addon.Name)
end

Shissu_SuiteManager._settings[_addon.Name] = {}
Shissu_SuiteManager._settings[_addon.Name].panel = _addon.panel
Shissu_SuiteManager._settings[_addon.Name].controls = _addon.controls
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized
