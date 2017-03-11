-- File: welcome.lua
-- Shissu GuildTools Module File
-----------------------------------------
-- File: welcome.lua
-- Version: v1.0.5
-- Last Update: 06.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!

local _globals = Shissu_SuiteManager._globals
local blue = _globals["color"]["blue"]
local white = _globals["color"]["white"]

local _lib = Shissu_SuiteManager._lib
local _SGT = Shissu_SuiteManager._lib["SGT"]
local getString = _SGT.getString

local _addon = {}
_addon.Name	= "ShissuWelcomeInvite"
_addon.Version = "1.0.5"
_addon.core = {}
_addon.fN = _SGT["title"](getString(ShissuWelcomeInvite))

_addon.settings = {
  ["invite"] = {}, -- true, true, true, true, true },
  ["message"] = {}, -- { "Welcome %1", "Welcome %1", "Welcome %1", "Welcome %1", "Welcome %1" }
}

_addon.panel = _lib.setPanel(getString(ShissuWelcomeInvite), _addon.fN, _addon.Version)
_addon.controls = {}

function _addon.core.createGuildInviteSetting()
  local controls = Shissu_SuiteManager._settings[_addon.Name].controls
  local numGuild = GetNumGuilds()
  
  controls[#controls+1] = {                
    type = "description",
    text = getString(ShissuWelcomeDesc1) .. ":",
  }
  controls[#controls+1] = {
    type = "description",
    text = blue .. "%1 " .. white .. "- " .. getString(ShissuWelcomeDesc2) .. "\n" .. 
           blue .. "%2 " .. white .. "- " .. getString(ShissuWelcomeDesc3) .. "\n" .. 
           blue .. "|| " .. white .. "- " .. getString(ShissuWelcomeDesc4) ,
  }
    
  controls[#controls+1] = {
    type = "title",
    name = getString(Shissu_guild),
  }
    
  for guildId = 1, numGuild do
    local name = GetGuildName(guildId)   

    controls[#controls+1] = {
      type = "description",
      text = blue .. name,
    }

    controls[#controls+1] = {
      type = "checkbox",
      name = "Chat: " .. getString(ShissuWelcomeInvite),
      getFunc = _addon.settings["invite"][name],
      setFunc = function(_, value)
        _addon.settings["invite"][name] = value 
      end,
    } 
    
    controls[#controls+1] = {
      type = "editbox",
      name = getString(ShissuWelcomeInvite),
      getFunc = _addon.settings["message"][name],
      setFunc = function(value)
        _addon.settings["message"][name] = value 
      end,
    }   
     
  end
end
                                          
-- Event: EVENT_GUILD_MEMBER_ADDED
function _addon.core.guildMemberAdded(_, guildId, accName)
  local guildName = GetGuildName(guildId) 
  local allowInvite = _addon.settings["invite"][guildName]
                        
  if allowInvite == false then return end

  local currentText = CHAT_SYSTEM.textEntry:GetText()
  
  if string.len(currentText) < 1 then
    local chatMessageArray = Shissu_SuiteManager._lib.splitToArray(_addon.settings["message"][guildName], "|")
          
    local rnd = math.random(#chatMessageArray) 
    local chatMessage = string.gsub(chatMessageArray[rnd], "%%1", accName)
    chatMessage = string.gsub(chatMessage, "%%2", guildName)
    
    local text = "/g" .. guildId .. " " .. chatMessage     
    ZO_ChatWindowTextEntryEditBox:SetText(text)
  end                        
end
          
-- Initialisierung
function _addon.core.initialized()
  shissuGT = shissuGT or {}  
  shissuGT[_addon.Name] = shissuGT[_addon.Name] or _addon.settings
  _addon.settings = shissuGT[_addon.Name]

  Shissu_SuiteManager._settings[_addon.Name].settings = _addon.settings     
  Shissu_SuiteManager._settings[_addon.Name].guildMemberAdded = _addon.core.guildMemberAdded
  
   -- Hat jemand die neue SaveVar schon?  
  if (_addon.settings["invite"] == nil) then _addon.settings["invite"] = {} end
  if (_addon.settings["message"] == nil) then _addon.settings["message"] = {} end
  
  local welcomeString = "Welcome / Willkommen %1"
  
  for guildId=1, GetNumGuilds() do
    local guildName = GetGuildName(guildId)  
    if (_addon.settings["invite"][guildName] == nil) then _addon.settings["invite"][guildName] = true end
    if (_addon.settings["message"][guildName] == nil) then _addon.settings["message"][guildName] = welcomeString end
  end

  _addon.core.createGuildInviteSetting()
  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_GUILD_MEMBER_ADDED, _addon.core.guildMemberAdded)
end                               

Shissu_SuiteManager._settings[_addon.Name] = {}
Shissu_SuiteManager._settings[_addon.Name].panel = _addon.panel                                       
Shissu_SuiteManager._settings[_addon.Name].controls = _addon.controls                 
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized    