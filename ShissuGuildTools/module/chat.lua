-- Shissu GuildTools Module File
--------------------------------
-- File: chat.lua
-- Version: v2.0.14
-- Last Update: 20.05.2017
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
local RGBtoHex = _SGT.RGBtoHex2
 
local _addon = {}
_addon.Name	= "ShissuChat2"
_addon.Version = "2.0.14"
_addon.core = {}
_addon.fN = _SGT["title"](getString(ShissuChat))             

_addon.panel = _setPanel(getString(ShissuChat), _addon.fN, _addon.Version)

_addon.controls = {}

_addon.enabled = false

_addon.settings = {
  ["hideText"] = true,                                                                          
  ["brackets"] = true,                                  
  ["nameFormat"] = 3,
  ["registerTab"] = 1,
  ["channel"] = "/zone",
  ["startChannel"] = true,
  ["url"] = true,
  ["partySwitch"] = true,
  ["partyLead"] = true,
  ["whisperSound"] = 2,
  ["partyLeadColor"] = {1, 1, 1, 1},
  ["whisperInfoColor"] = {0.50196081399918, 0.80000001192093, 1, 1},
  ["timeStamp"] = true,
  ["timeStampFormat"] = "DD.MM.Y HH:m:s" ,  
  ["timeColor"] = {0.50196081399918, 0.80000001192093, 1, 1},
  ["dateColor"] = {0.8901960849762, 0.93333333730698, 1, 1},  
  ["autoWhisper"] = true,
  ["autoGroup"] = true,
  ["autoZone"] = true,
  ["auto"] = {},
  ["info"] = {},
  ["names"] = {},
  ["guild"] = true,
  ["level"] = true,
  ["alliance"] = true,
  ["rank"] = true, 
}

_addon.LINK = "shissu"
_addon.urlLINK = 101

local _sounds = {
  SOUNDS.NONE,
  SOUNDS.EMPEROR_DEPOSED_ALDMERI,
  SOUNDS.AVA_GATE_CLOSED,
  SOUNDS.NEW_NOTIFICATION,
  SOUNDS.CHAMPION_POINTS_COMMITTED,
  SOUNDS.CHAMPION_ZOOM_IN,
  SOUNDS.CHAMPION_ZOOM_OUT,
  SOUNDS.CHAMPION_STAR_MOUSEOVER,
  SOUNDS.CHAMPION_CYCLED_TO_MAGE,
  SOUNDS.BLACKSMITH_EXTRACTED_BOOSTER,
  SOUNDS.ENCHANTING_ASPECT_RUNE_REMOVED,
  SOUNDS.SMITHING_OPENED,
  SOUNDS.GUILD_ROSTER_REMOVED,
  SOUNDS.GUILD_ROSTER_ADDED,
  SOUNDS.GUILD_WINDOW_OPEN,
  SOUNDS.GROUP_DISBAND,
  SOUNDS.DEFAULT_CLICK,
  SOUNDS.EDIT_CLICK,
  SOUNDS.STABLE_FEED_STAMINA,
  SOUNDS.QUICKSLOT_SET,
  SOUNDS.MARKET_CROWNS_SPENT,
}       

function _addon.core.createSettingMenu()
  local controls = Shissu_SuiteManager._settings[_addon.Name].controls
  
  -- Allgemeines
  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuGeneral),
  } 
  
  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuChat_brackets),
    tooltip = getString(ShissuChat_bracketsTT),
    getFunc = _addon.settings["brackets"],
    setFunc = function(_, value)
      _addon.settings["brackets"] = value
    end,
  } 
  
  local accountArr = { getString(ShissuChat_charAcc1), getString(ShissuChat_charAcc2), getString(ShissuChat_charAcc3) }
  
  controls[#controls+1] = {
    type = "combobox",
    name = getString(ShissuChat_char),
    items = accountArr,
    getFunc = accountArr[_addon.settings["nameFormat"]],
    setFunc = function(_, value)

      for valueId = 1, 3 do
        if accountArr[valueId] == value then
          _addon.settings["nameFormat"] = valueId
          break
        end
      end
    end,
  }  
         
  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuChat_url),
    tooltip = getString(ShissuChat_urlTT),
    getFunc = _addon.settings["url"],
    setFunc = function(_, value)
      _addon.settings["url"] = value
    end,
  } 
  
  -- Zeitstempel
  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuChat_timeStamp),
  }             

  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuChat_timeStamp),
    tooltip = getString(ShissuChat_timeStampTT),
    getFunc = _addon.settings["timeStamp"],
    setFunc = function(_, value)
      _addon.settings["timeStamp"] = value
    end,
  }
  controls[#controls+1] = {
    type = "textbox",
    name = getString(ShissuChat_timeStampFormat),
    tooltip = getString(ShissuChat_timeStampFormatTT),
    getFunc = _addon.settings["timeStampFormat"],
    setFunc = function(value)
      _addon.settings["timeStampFormat"] = value
    end,
  }  

  controls[#controls+1] = {
    type = "colorpicker", 
    name = getString(ShissuChat_time),
    getFunc = _addon.settings["timeColor"], 
    setFunc = function (r, g, b, a)                                                                                                                                                           
      _addon.settings["timeColor"] = {r, g, b, a}
    end,
  }        
  controls[#controls+1] = {
    type = "colorpicker", 
    name = getString(ShissuChat_date),
    getFunc = _addon.settings["dateColor"], 
    setFunc = function (r, g, b, a)                                                                                                                                                           
      _addon.settings["dateColor"] = {r, g, b, a}
    end,
  }         
    
  -- Chatfenster
  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuChat_window),
  }             
  
  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuChat_hideText),
    tooltip = getString(ShissuChat_hideTextTT),
    getFunc = _addon.settings["hideText"],
    setFunc = function(_, value)
      _addon.settings["hideText"] = value
    end,
  } 
  
  local channels = {}

  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuChat_channel),
    tooltip = getString(ShissuChat_channelTT),
    getFunc = _addon.settings["startChannel"],
    setFunc = function(_, value)
      _addon.settings["startChannel"] = value
    end,
  } 
  
  for chanId = 1, table.getn(CHAT_SYSTEM.channelData) do
    if (CHAT_SYSTEM.channelData[chanId] ~= nil) then
		  table.insert(channels, CHAT_SYSTEM.channelData[chanId].switches)
    end
	end 

  controls[#controls+1] = {
    type = "combobox",
    name = getString(ShissuChat_channel),
    tooltip = getString(ShissuChat_channelTT),
    items = channels,
    getFunc = _addon.settings["channel"],
    setFunc = function(_, value)
      _addon.settings["channel"] = value
    end,
  }  
    
	local countRegister = {}
  
  if (CHAT_SYSTEM ~= nil) then
    if (CHAT_SYSTEM.primaryContainer ~= nil) then
  
    for tabId = 1, table.getn(CHAT_SYSTEM.primaryContainer.windows) do
  		table.insert(countRegister, tabId)
  	end
 -- end
	
  controls[#controls+1] = {
    type = "combobox",
    name = getString(ShissuChat_register),
    tooltip = getString(ShissuChat_registerTT),
    items = countRegister,
    getFunc = _addon.settings["registerTab"],
    setFunc = function(_, value)
      _addon.settings["registerTab"] = value
    end,
  }  
  
  end
  end
    
  -- Flüstern
  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuChat_whisper),
  }   
  
  local sounds = {}
  
  for soundId = 0, table.getn(_sounds)-1 do
		table.insert(sounds, soundId)
  end
  
  controls[#controls+1] = {
    type = "combobox",
    name = getString(ShissuChat_sound),
    tooltip = getString(ShissuChat_soundTT),
    items = sounds,
    getFunc = _addon.settings["whisperSound"],
    setFunc = function(_, value)
      _addon.settings["whisperSound"] = value + 1
      PlaySound(_sounds[value+1])
    end,
  } 
  
  controls[#controls+1] = {
    type = "colorpicker", 
    name = getString(ShissuChat_warningColor),
    tooltip = getString(ShissuChat_warningColorTT),
    getFunc = _addon.settings["whisperInfoColor"], 
    setFunc = function (r, g, b, a)                                                                                                                                                           
      _addon.settings["whisperInfoColor"] = {r, g, b, a}
    end,
  }         

  -- Gruppe
  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuChat_party),
  } 

  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuChat_partySwitch),
    tooltip = getString(ShissuChat_partySwitchTT),
    getFunc = _addon.settings["partySwitch"],
    setFunc = function(_, value)
      _addon.settings["partySwitch"] = value
    end,    
  }        
  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuChat_partyLead),
    tooltip = getString(ShissuChat_partyLead),
    getFunc = _addon.settings["partyLead"],
    setFunc = function(_, value)
      _addon.settings["partyLead"] = value
    end,
  }   
  controls[#controls+1] = {
    type = "colorpicker", 
    name = getString(ShissuChat_partyLead),
    getFunc = _addon.settings["partyLeadColor"], 
    setFunc = function (r, g, b, a)                                                                                                                                                           
      _addon.settings["partyLeadColor"] = {r, g, b, a}
    end,
  }       

  -- Gildeninformationen
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
    type = "guildCheckbox",
    name = blue .. getString(ShissuChat_guildWhich),
    saveVar = _addon.settings["info"],
  }   

  -- Automatischer Wechsel
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
    type = "guildCheckbox",
    name = blue .. getString(ShissuChat_guildchan),
    saveVar = _addon.settings["auto"],
  }     

  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuChat_guildNames1),
  }
  
   controls[#controls+1] = {
    type = "description",
    text = blue .. getString(ShissuChat_guildNames2),
  }   
  
  local numGuild = GetNumGuilds()
  
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

-- FENSTER FUNKTIONEN
-- ******************
function _addon.core.defaultRegister()
  local numRegister = #CHAT_SYSTEM.primaryContainer.windows
	
	if numRegister > 1 then
		for numRegister, container in ipairs (CHAT_SYSTEM.primaryContainer.windows) do
      local control = GetControl("ZO_ChatWindowTabTemplate" .. numRegister .. "Text")
      
      if (numRegister == _addon.settings["registerTab"]) then
        CHAT_SYSTEM.primaryContainer:HandleTabClick(container.tab)
					
				control:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_SELECTED))
				control:GetParent().state = PRESSED
      else
				control:SetColor(GetInterfaceColor(INTERFACE_COLOR_TYPE_TEXT_COLORS, INTERFACE_TEXT_COLOR_CONTRAST))
    		control:GetParent().state = UNPRESSED      
      end
    end
  end
end

function _addon.core.changePrimaryContainer()
	for tabIndex, tabObject in ipairs(CHAT_SYSTEM.primaryContainer.windows) do
		tabObject.buffer:SetMaxHistoryLines(1000)
      
    if _addon.settings["hideText"] == false then
  		tabObject.buffer:SetLineFade(3600, 2)
  	end
	end
end

function _addon.core.createNewTab()
	local origChatSystemCreateNewChatTab = CHAT_SYSTEM.CreateNewChatTab
  
	CHAT_SYSTEM.CreateNewChatTab = function(self, ...)
		origChatSystemCreateNewChatTab(self, ...)
		_addon.core.changePrimaryContainer()
	end
end

-- Orig Func: ingame/chatsystem/chathandlers.lua
local ChannelInfo = ZO_ChatSystem_GetChannelInfo()

local function CreateChannelLink(channelInfo, overrideName)
  if channelInfo.channelLinkable then
    local channelName = overrideName or GetChannelName(channelInfo.id)
    return ZO_LinkHandler_CreateChannelLink(channelName)
  end
end

local function GetCustomerServiceIcon(isCustomerServiceAccount)
  if(isCustomerServiceAccount) then
    return "|t16:16:EsoUI/Art/ChatWindow/csIcon.dds|t"
  end
  
  return ""
end

function _addon.core.displayBrackets(from, userFacingName, linkType)
	if not userFacingName then userFacingName = from end
	
  if (_addon.settings["brackets"]) then
		return ZO_LinkHandler_CreateLinkWithoutBrackets(userFacingName, nil, linkType, from)
	else
		return ZO_LinkHandler_CreateLink(userFacingName, nil, linkType, from)
	end
end

function _addon.core.fromLink(messageType, fromName, isCS, fromDisplayName)
  local newFrom = fromName

	if IsDecoratedDisplayName(fromName) then
    -- Nachricht mit "@" (Gilde, Whisper)
    newFrom = _addon.core.displayBrackets(newFrom, newFrom, DISPLAY_NAME_LINK_TYPE) 
  else
    newFrom = zo_strformat(SI_UNIT_NAME, newFrom)

    -- Nicht für NPCs
		if not (messageType == CHAT_CHANNEL_MONSTER_SAY or messageType == CHAT_CHANNEL_MONSTER_YELL or messageType == CHAT_CHANNEL_MONSTER_WHISPER or messageType == CHAT_CHANNEL_MONSTER_EMOTE) then
			if _addon.settings["nameFormat"] == 1 then
				newFrom = _addon.core.displayBrackets(fromDisplayName, fromDisplayName, DISPLAY_NAME_LINK_TYPE)
			elseif _addon.settings["nameFormat"] == 3 then
        newFrom = newFrom
				newFrom = _addon.core.displayBrackets(newFrom, newFrom, CHARACTER_LINK_TYPE)  
        newFrom = newFrom .. _addon.core.displayBrackets(fromDisplayName, fromDisplayName, DISPLAY_NAME_LINK_TYPE) 
		  else
				newFrom = _addon.core.displayBrackets(newFrom, newFrom, CHARACTER_LINK_TYPE)
			end	
    end  
  end                                             
  
  if isCS then -- ZOS icon
		newFrom = "|t16:16:EsoUI/Art/ChatWindow/csIcon.dds|t" .. newFrom
	end
  
  -- Gruppenanführer???
	if (messageType == CHAT_CHANNEL_PARTY and _addon.settings["partyLead"]) then
    if zo_strformat(SI_UNIT_NAME, fromName) == GetUnitName(GetGroupLeaderUnitTag()) then
      newFrom = "|c" .. RGBtoHex(_addon.settings["partyLeadColor"]) .. newFrom .. "|r"
    end
  end 
  
	return newFrom
end

function _addon.core.createLinkURL(text)
  if (string.find(text, "www.") or string.find(text, "http://") or string.find(text, "https://")) then
    local cache = 0  
    local cache2 = 0
    local cache3 = 0
    
    local onlyWWW = string.find(text, "www.")
    
    if (onlyWWW and not string.find(text, "http")) then
      text = string.gsub(text, "www.", "http://www.")
    end
    
    if (string.sub(text, 1, 4) == "http" or string.sub(text, 1, 3) == "www") then
      cache2 = 1
      text = "shissu meow " .. text .. " meow shissu meow"
    end
               
    local preT, url, nextT = text:match( "(.+)%s+(https?%S+)%s+(.*)$" )
    
    if (nextT == nil) then
      cache3 = 1
      text = text .. " meow shissu meow"
      
      preT, url, nextT = text:match( "(.+)%s+(https?%S+)%s+(.*)$" )
    end

    local stringLen = string.len(url)  
    local last = string.sub(url, stringLen, stringLen)
        
    if (last== "," or last == ".") then
      url = string.sub(url, 0, stringLen-1)
      cache = 1
    end
   
    local urlLink = blue .. string.format("|H1:%s:%s:%s|h%s|h", _addon.LINK, 1, _addon.urlLINK, url) .. "|r"
  
    if (cache2 == 0) then  	
      local stringLen2 = string.len(preT)
      local stringLen3 = string.len(text)
         
      local newNextT = string.sub(text, stringLen + stringLen2 + 2, stringLen3)  
     
      if (cache3 == 1) then
        text = preT .. " " .. urlLink 
      elseif (cache == 1) then
        text = preT .. " " .. urlLink .. newNextT
      else
       text = preT .. " " .. urlLink .. " " .. newNextT
      end
    else
      text = urlLink
    end
  end
    
  return text
end

function createTimestamp()
 --d(_addon.core.createTimestamp())
end
                                                             
function _addon.core.createTimestamp()
	local timeString = GetTimeString()
  local dateString = GetDateStringFromTimestamp(GetTimeStamp())
  
  -- Uhrzeit
	local hours, minutes, seconds = timeString:match("([^%:]+):([^%:]+):([^%:]+)")
  
  local hours12	
  local hours_0 = tonumber(hours)
	local hours12_0 = (hours_0 - 1)%12 + 1
	
	if (hours12_0 < 10) then
		hours12 = "0" .. hours12_0
	else
		hours12 = hours12_0
	end        
  
  -- AM-PM-System
	local englishUP  = "AM"
	local englishLOW = "am"
  
	if (hours_0 >= 12) then
		englishUP = "PM"
		englishLOW = "pm"
	end
  
  local minutes_0 = minutes
  local seconds_0 = seconds
  
  if (string.len(minutes) < 2) then
    minutes_0 = "0" .. minutes     
  end

  if (string.len(seconds) < 2) then
    seconds_0 = "0" .. seconds
  end
    
  -- Datum
  local days, month, year = dateString:match("(%d+).(%d+).(%d+)")
  local days_0 = tonumber(days)
  local month_0 = tonumber(days)
  
  -- Farben
  local cTime = _addon.settings["timeColor"] or {1, 1, 1, 1}
  cTime = "|c" .. RGBtoHex(_addon.settings["timeColor"])
  
  local cDate = RGBtoHex(_addon.settings["dateColor"]) or {1, 1, 1, 1}
  cDate = "|c" .. RGBtoHex(_addon.settings["dateColor"])
  
  -- Ausgabe String
  timestamp = _addon.settings["timeStampFormat"] or "DD.MM.Y HH:m:s"
  
  -- Datum	
  timestamp = timestamp:gsub("DD", cDate .. days)
  timestamp = timestamp:gsub("D", cDate .. days_0)
  timestamp = timestamp:gsub("MM", cDate .. month)
  timestamp = timestamp:gsub("M", cDate .. month_0)  
  timestamp = timestamp:gsub("Y", cDate .. year)

  -- Uhrzeit  
	timestamp = timestamp:gsub("HH", cTime .. hours)
	timestamp = timestamp:gsub("H", cTime .. hours_0)
  timestamp = timestamp:gsub("hh", cTime .. hours12)
	timestamp = timestamp:gsub("h", cTime .. hours12_0)  
  timestamp = timestamp:gsub("mm", cTime .. minutes_0)  
	timestamp = timestamp:gsub("m", cTime .. minutes)
  timestamp = timestamp:gsub("ss", cTime .. seconds_0)    
	timestamp = timestamp:gsub("s", cTime .. seconds)  
	timestamp = timestamp:gsub("A", cTime .. englishUP)
	timestamp = timestamp:gsub("a", cTime .. englishLOW)
	
	return timestamp .. "|r"
end

function _addon.core.getGuildInfo(fromName, displayName)
  for guildId=1, GetNumGuilds() do
    local guildId = GetGuildId(guildId)
    local guildName = GetGuildName(guildId)
    
    if _addon.settings["info"] then
      if (_addon.settings["info"][guildName]) then  

        for memberId=1, GetNumGuildMembers(guildId), 1 do
          local accInfo = {GetGuildMemberInfo(guildId, memberId)}
          local charInfo = {GetGuildMemberCharacterInfo(guildId, memberId)}
          local accName = accInfo[1]
          local charName = zo_strformat(SI_UNIT_NAME, charInfo[2]) 
                    
          if accName == fromName or charName == fromName then
            local charLvL = charInfo[6]
            
            local charAlliance = charInfo[5]
            charAlliance = zo_iconFormat(GetAllianceBannerIcon(charAlliance), 24, 24)
            
            local rang = GetGuildRankSmallIcon(GetGuildRankIconIndex(guildId, accInfo[3]))
            rang = "|t24:24:" .. rang .. "|t"
      
            if charLvL == 50 and charInfo[7] > 0 then charLvL = "[CP" .. charInfo[7] .."]"
            else 
              charLvL = " [" .. charLvL .. "]"
            end            
             
            -- Liegen abgespeicherte Namen vor?
            if (_addon.settings["names"] ~= nil) then
              if (_addon.settings["names"][guildName] ~= nil) then
                if (_addon.settings["names"][guildName] ~= "") then
                  return guildName, _addon.settings["names"][guildName], guildId, charLvL, rang, charAlliance, charName 
                end
              end
            end
            
            return guildName, guildName, guildId, charLvL, rang, charAlliance, charName
          end
        end
      end
    end
  end

  return ""
end

function _addon.core.formatMessage(messageType, fromName, text, isFromCustomerService, fromDisplayName)
  local channelInfo = ChannelInfo[messageType]
  local timeStamp = ""
  local additionalInfo = ""
   
  if channelInfo and channelInfo.format then
    local channelLink = CreateChannelLink(channelInfo)
    
    local origname, guildName, guildId, guildLvL, guildRang, guildAlliance, guildChar = _addon.core.getGuildInfo(fromName, displayName)

    if ((messageType >= CHAT_CHANNEL_GUILD_1 and messageType <= CHAT_CHANNEL_GUILD_5) or messageType == CHAT_CHANNEL_WHISPER) then
      if (guildChar ~= nil) then
        fromName = guildChar
      end
    end

    local fromLink = _addon.core.fromLink(messageType, fromName, isCS, fromDisplayName)
    
    if (_addon.settings["guild"] and guildName ~= nil and not (messageType >= CHAT_CHANNEL_GUILD_1 and messageType <= CHAT_CHANNEL_GUILD_5)) then
      additionalInfo = blue .. "[" .. guildName .. "]|r"
    end

    if (_addon.settings["alliance"] and guildAlliance ~= nil) then
      additionalInfo = additionalInfo .. guildAlliance
      --d(guildAlliance)
    end 
    
    if (_addon.settings["rank"] and guildRang ~= nil)  then
      additionalInfo = additionalInfo .. guildRang
    end  
    
    if (_addon.settings["level"] == false) then
      guildLvL = ""
    end 
    
    -- URL Handling
    if _addon.settings["url"] then   
      text = _addon.core.createLinkURL(text)     
	  end
    
    if _addon.settings["timeStamp"] then
      timeStamp = "|c8989A2[|r" .. _addon.core.createTimestamp() .. "|c8989A2]|r "
    end

    -- Soundausgabe, beim Flüstern
    if (messageType == CHAT_CHANNEL_WHISPER and _addon.settings["whisperSound"] ~= 0) then
      PlaySound(_sounds[_addon.settings["whisperSound"]])
    end

    if (guildLvL ~= nil) then
      fromLink = fromLink .. " " .. guildLvL
    end   

    if channelLink then
      return timeStamp .. additionalInfo .. zo_strformat(channelInfo.format, channelLink, fromLink, text), channelInfo.saveTarget, fromDisplayName, text
    end
  
    return timeStamp .. additionalInfo .. zo_strformat(channelInfo.format, fromLink, text, GetCustomerServiceIcon(isFromCustomerService)), channelInfo.saveTarget, fromDisplayName, text
  end
  
  return timeStamp .. text
end

function _addon.core.onLickClicked(rawLink, mouseButton, linkText, color, linkType, lineNumber, chanCode)
	if linkType == _addon.LINK then
		local chanNumber = tonumber(chanCode)
		local numLine = tonumber(lineNumber)

		if chanCode and mouseButton == MOUSE_BUTTON_INDEX_LEFT then
			if (chanNumber == _addon.urlLINK) then
        RequestOpenUnsafeURL(linkText)
			end
		end

		return true
	end
end

function _addon.core.onGroupMemberJoined()
  if _addon.settings["partySwitch"] then
    ZO_ChatWindowTextEntryEditBox:SetText("/party ")  
  end
end

function _addon.core.onGroupMemberLeft()
  if _addon.settings["partySwitch"] then
    ZO_ChatWindowTextEntryEditBox:SetText("/zone ")  
  end
end 

function _addon.core.chatMessageChannel(eventId, messageType, fromName, _, _, fromDisplayName)
  local currentText = CHAT_SYSTEM.textEntry:GetText()
  local allow = 0
  local channel = ""
  
  local channelString = {
    [CHAT_CHANNEL_PARTY] = "/party ",
    [CHAT_CHANNEL_ZONE] = "/zone ",
    [CHAT_CHANNEL_WHISPER] = "/t " .. fromDisplayName .. " ",
    [CHAT_CHANNEL_ZONE_LANGUAGE_1] = "/zen ",
    [CHAT_CHANNEL_ZONE_LANGUAGE_2] = "/zfr ",
    [CHAT_CHANNEL_ZONE_LANGUAGE_3] = "/zde ",
    [CHAT_CHANNEL_ZONE_LANGUAGE_4] = "/zjp ",
    [CHAT_CHANNEL_GUILD_1] = {"/g1 ", 1},
    [CHAT_CHANNEL_GUILD_2] = {"/g2 ", 2},
    [CHAT_CHANNEL_GUILD_3] = {"/g3 ", 3},
    [CHAT_CHANNEL_GUILD_4] = {"/g4 ", 4},
    [CHAT_CHANNEL_GUILD_5] = {"/g5 ", 5},
  }

  if string.len(currentText) < 1 then
    if (messageType == CHAT_CHANNEL_WHISPER and _addon.settings["autoWhisper"] == true) 
      or (messageType == CHAT_CHANNEL_PARTY and _addon.settings["autoGroup"] == true)
      or (messageType >= CHAT_CHANNEL_ZONE and messageType <= CHAT_CHANNEL_ZONE_LANGUAGE_4 and _addon.settings["autoZone"] == true) then

      allow = 1
      channel = channelString[messageType]
    end   
        
    if (messageType >= CHAT_CHANNEL_GUILD_1 and messageType <= CHAT_CHANNEL_GUILD_5) then 
      local guildId = channelString[messageType][2]
      guildId = GetGuildId(guildId)
      
      local guildName = GetGuildName(guildId)  
      
      if _addon.settings["auto"] then
        if _addon.settings["auto"][guildName] then
          allow = 1
          channel = channelString[messageType][1]
        end
      end
    end    
  end 
  
  if (allow == 1 and channelString[messageType] ~= nil) then
     ZO_ChatWindowTextEntryEditBox:SetText(channel)
  end
end

function ZO_TabButton_Text_SetTextColor(self, color)
	local c = _addon.settings["whisperInfoColor"]

	if(self.allowLabelColorChanges) then
		local label = GetControl(self, "Text")
		label:SetColor(c[1], c[2], c[3], c[4])
	end	
end
 
function _addon.core.startModule()
  _addon.enabled = true
  -- FENSTER FUNKTIONEN
  -- ******************
  _addon.core.createNewTab()
  _addon.core.defaultRegister()
  
  if (_addon.settings["channel"] and _addon.settings["startChannel"]) then
    _addon.settings["channel"] = _lib.cutStringAtLetter(_addon.settings["channel"], ' ') 
    ZO_ChatWindowTextEntryEditBox:SetText(_addon.settings["channel"] .. " ")
  end

  -- Vergrößerung der Chatbox auf Fenstergröße, bei Bedarf
  CHAT_SYSTEM.maxContainerWidth, CHAT_SYSTEM.maxContainerHeight = GuiRoot:GetDimensions() 
  
  -- URL
  LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_CLICKED_EVENT, _addon.core.onLickClicked)
  LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_MOUSE_UP_EVENT, _addon.core.onLickClicked)
  
  -- Gruppenwechsel; automatischer Wechsel
	EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_GROUP_MEMBER_JOINED, _addon.core.onGroupMemberJoined)
	EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_GROUP_MEMBER_LEFT, _addon.core.onGroupMemberLeft)
  
  -- Formatierung der Textausgaben
  ZO_ChatSystem_AddEventHandler(EVENT_CHAT_MESSAGE_CHANNEL, _addon.core.formatMessage)
end
 
function _addon.core.createGuildVars(saveVar, value)
  if _addon.settings[saveVar] == nil then _addon.settings[saveVar] = {} end
  
  if _addon.settings[saveVar] ~= nil then  
    local numGuild = GetNumGuilds()
    
    for guildId=1, numGuild do
      local guildId = GetGuildId(guildId)
      local guildName = GetGuildName(guildId)  
      
      if _addon.settings[saveVar][guildName] == nil then _addon.settings[saveVar][guildName] = value end
    end
  end
end 

function _addon.core.copyFromOldToNew(saveVar)
  if shissuGT["ShissuChat"] ~= nil then
    if shissuGT["ShissuChat"][saveVar] ~= nil then _addon.settings[saveVar] = shissuGT["ShissuChat"][saveVar] end
  end
end

function _addon.core.createNewVar(saveVar, value)
  if _addon.settings[saveVar] == nil then _addon.settings[saveVar] = value end
end
 
function _addon.core.initNewVariables()
  _addon.core.createGuildVars("auto", true)
  _addon.core.createGuildVars("info", true)
  
  if _addon.settings["names"] == nil then _addon.settings["names"] = {} end
  
  _addon.core.createNewVar("hideText", true)
  _addon.core.createNewVar("brackets", true)
  _addon.core.createNewVar("nameFormat", 3)
  _addon.core.createNewVar("registerTab", 1)
  _addon.core.createNewVar("channel", "/zone")
  _addon.core.createNewVar("url", true)
  _addon.core.createNewVar("partySwitch",true)                                  
  _addon.core.createNewVar("partyLead", true)
  _addon.core.createNewVar("whisperSound", 2)
  _addon.core.createNewVar("partyLeadColor", {1, 1, 1, 1})
  _addon.core.createNewVar("whisperInfoColor", {0.50196081399918, 0.80000001192093, 1, 1})
  _addon.core.createNewVar("timeStamp", true)
  _addon.core.createNewVar("timeStampFormat", "DD.MM.Y HH:m:s")
  _addon.core.createNewVar("timeColor", {0.50196081399918, 0.80000001192093, 1, 1})
  _addon.core.createNewVar("dateColor", {0.8901960849762, 0.93333333730698, 1, 1})
  _addon.core.createNewVar("autoWhisper", true)
  _addon.core.createNewVar("autoGroup", true)
  _addon.core.createNewVar("autoZone", true)
  _addon.core.createNewVar("level", true)
  _addon.core.createNewVar("alliance", true)
  _addon.core.createNewVar("rank", true)
  _addon.core.createNewVar("guild", true) 
  _addon.core.createNewVar("startChannel", true) 
  
  -- einmaliges Übernehmen der alten Einstellungen
  if shissuGT["ShissuChat"] ~= nil then
    _addon.core.copyFromOldToNew("names")
    _addon.core.copyFromOldToNew("auto")
    _addon.core.copyFromOldToNew("info")
    _addon.core.copyFromOldToNew("autoWhisper")
    _addon.core.copyFromOldToNew("autoGroup")
    _addon.core.copyFromOldToNew("autoZone")
    _addon.core.copyFromOldToNew("guild")
    _addon.core.copyFromOldToNew("level")
    _addon.core.copyFromOldToNew("alliance")
    _addon.core.copyFromOldToNew("rank")

    shissuGT["ShissuChat"] = nil
  end
end
 
-- * Initialisierung
function _addon.core.initialized()
  shissuGT = shissuGT or {}

  shissuGT[_addon.Name] = shissuGT[_addon.Name] or _addon.settings
  _addon.settings = shissuGT[_addon.Name]
  
  _addon.core.initNewVariables()
  --_addon.core.startModule()
  _addon.core.createSettingMenu()
    
  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_CHAT_MESSAGE_CHANNEL, _addon.core.chatMessageChannel)
  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_PLAYER_ACTIVATED, _addon.core.startModule)

  if (_addon.enabled == false) then
    zo_callLater(function() _addon.core.startModule() end, 10000)  
  end
end                               

Shissu_SuiteManager._settings[_addon.Name] = {}
Shissu_SuiteManager._settings[_addon.Name].panel = _addon.panel                                       
Shissu_SuiteManager._settings[_addon.Name].controls = _addon.controls                 
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized    
