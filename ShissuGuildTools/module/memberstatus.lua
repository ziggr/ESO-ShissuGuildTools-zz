-- Shissu GuildTools Module File
--------------------------------
-- File: memberstatus.lua
-- Version: v1.1.1
-- Last Update: 09.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!

local _globals = Shissu_SuiteManager._globals
local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]
local green = _globals["color"]["green"]
local red = _globals["color"]["red"]
local yellow = _globals["color"]["yellow"]
local gray = _globals["color"]["gray"] 

local _lib = Shissu_SuiteManager._lib
local _SGT = Shissu_SuiteManager._lib["SGT"]
local getString = _SGT.getString

local _addon = {}
_addon.Name	= "ShissuMemberStatus"
_addon.Version = "1.1.0"
_addon.core = {}
_addon.fN = _SGT["title"](getString(ShissuMemberStatus))

_addon.settings = {
  added = {}, 
  removed = {}, 
  memberstatus = {},
}

_addon.panel = _lib.setPanel(getString(ShissuMemberStatus), _addon.fN, _addon.Version)
_addon.controls = {}

local _guildId = 0
local _status = 0

function _addon.core.createGuildSettings(title, var, oneMore)
  local controls = Shissu_SuiteManager._settings[_addon.Name].controls
  local numGuild = GetNumGuilds()

  controls[#controls+1] = {
    type = "title",
    name = getString(title),  
  }
  
  for guildId = 1, numGuild do
    local name = GetGuildName(guildId)           

    controls[#controls+1] = {
      type = "checkbox",
      name = name,
      getFunc = _addon.settings[var][name],
      setFunc = function(_, value)
        _addon.settings[var][name] = value
      end,
    }
  end
end

-- Event: EVENT_GUILD_MEMBER_ADDED
function _addon.core.playerAdded(_, guildId, accName)
  local guildName = GetGuildName(guildId)
  
  if _addon.settings["added"][guildName] == false then return end

  text = blue .. guildName .. ": " .. white .. accName .. " - " .. green .. getString(ShissuContextMenu_added)
  d(text)
end

-- Event: EVENT_GUILD_MEMBER_REMOVED
function _addon.core.playerRemoved(_, guildId, accName)
  local guildName = GetGuildName(guildId)
  
  if _addon.settings["removed"][guildName] == false then return end

  text = blue .. guildName .. ": " .. white .. accName .. " - " .. red .. getString(ShissuContextMenu_removed)
  d(text)
end         

-- Event: EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED
function _addon.core.playerStatusChanged(_, guildId, accName, _, newStatus)
  if (_guildId == guildId and _status == newStatus) then return end
  local guildName = GetGuildName(guildId)
  
  if _addon.settings["memberstatus"][guildName] == false then return end
  
  _guildId = guildId
  _status = newStatus
  
  local statusText = {
    green .. "Online",
    yellow .. "AFK",
    red .. "BRB",                                   
    gray .. "Offline",
  }

  text = blue .. guildName .. ": " .. white .. accName .. " - " .. statusText[_status]

  d(text)
end

-- Initialisierung
function _addon.core.initialized()
  shissuGT = shissuGT or {}  
  shissuGT[_addon.Name] = shissuGT[_addon.Name] or _addon.settings
  _addon.settings = shissuGT[_addon.Name]

   -- Hat jemand die neue SaveVar schon?  
  if (_addon.settings["memberstatus"] == nil) then _addon.settings["invite"] = {} end
  if (_addon.settings["added"] == nil) then _addon.settings["message"] = {} end
  if (_addon.settings["removed"] == nil) then _addon.settings["message"] = {} end
  
  for guildId=1, GetNumGuilds() do
    local guildName = GetGuildName(guildId)  
    if (_addon.settings["memberstatus"][guildName] == nil) then _addon.settings["memberstatus"][guildName] = false end
    if (_addon.settings["added"][guildName] == nil) then _addon.settings["added"][guildName] = true end
    if (_addon.settings["removed"][guildName] == nil) then _addon.settings["removed"][guildName] = true end
  end

  _addon.core.createGuildSettings(ShissuContextMenu_memberStatus, "memberstatus")
  _addon.core.createGuildSettings(ShissuContextMenu_added, "added")
  _addon.core.createGuildSettings(ShissuContextMenu_removed, "removed")

  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_GUILD_MEMBER_REMOVED, _addon.core.playerRemoved)
  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_GUILD_MEMBER_ADDED, _addon.core.playerAdded)
  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_GUILD_MEMBER_PLAYER_STATUS_CHANGED, _addon.core.playerStatusChanged)
end                               

Shissu_SuiteManager._settings[_addon.Name] = {}
Shissu_SuiteManager._settings[_addon.Name].panel = _addon.panel                                       
Shissu_SuiteManager._settings[_addon.Name].controls = _addon.controls                 
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized    