-- Shissu GuildTools Module File
--------------------------------
-- File: roster.lua
-- Version: v1.2.0
-- Last Update: 19.10.2016
-- Written by Christian Flory (@Shissu) - esoui@flory.one

-- Distribution without license is prohibited!

local _globals = Shissu_SuiteManager._globals
local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]

local _lib = Shissu_SuiteManager._lib
local _SGT = Shissu_SuiteManager._lib["SGT"]
local getString = _SGT.getString

local _addon = {}
_addon.Name	= "ShissuAutoAFK"
_addon.Version = "1.1.0"
_addon.core = {}
_addon.fN = _SGT["title"](getString(ShissuAutoAFK))

_addon.settings = {
  ["enabled"] = true,
  ["autoOnline"] = true,
  ["whisperOnline"] = true,
  ["reminderOffline"] = true,
  ["reminderOfflineTime"] = 1,
  ["time"] = 1,
}

_addon.panel = _lib.setPanel(getString(ShissuAutoAFK), _addon.fN, _addon.Version)
_addon.controls = {}

local _offlineText = blue .. getString(ShissuAFK_reminder) .. white .. ": " .. getString(ShissuAFK_infoOffline)

local _offline = PLAYER_STATUS_OFFLINE
local _online = PLAYER_STATUS_ONLINE
local _dnd = PLAYER_STATUS_DO_NOT_DISTURB
local _away = PLAYER_STATUS_AWAY
local _cache = PLAYER_STATUS_ONLINE

function _addon.core.createSettingMenu()
  local controls = Shissu_SuiteManager._settings[_addon.Name].controls

  controls[#controls+1] = {
    type = "title",
    name = getString(ShissuAutoAFK),
  }

  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuAutoAFK),
    getFunc = _addon.settings["enabled"],
    setFunc = function(_, value)
      _addon.settings["enabled"] = value
      if (value) then _addon.core.autoAFK() end
    end,
  }

  controls[#controls+1] = {
    type = "slider",
    name = getString(ShissuAutoAFK) .. " " .. getString(ShissuAFK_minute),
    minimum = 1,
    maximum = 120,
    steps = 1,
    getFunc = _addon.settings["time"],
    setFunc = function(value)
      _addon.settings["time"] = value
      _addon.core.isAutoAFK()
    end,
  }

  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuAFK_autoOnline),
    getFunc = _addon.settings["autoOnline"],
    setFunc = function(_, value)
      _addon.settings["autoOnline"] = value
      if (value) then _addon.core.reminderOffline() end
    end,
  }

  controls[#controls+1] = {
    type = "checkbox",
    name = getString(ShissuAFK_reminderOffline),
    getFunc = _addon.settings["reminderOffline"],
    setFunc = function(_, value)
      _addon.settings["reminderOffline"] = value
      if (value) then _addon.core.setOnline() end
    end,
  }

  controls[#controls+1] = {
    type = "slider",
    name = getString(ShissuAFK_reminder) .. " " .. getString(ShissuAFK_minute),
    minimum = 1,
    maximum = 120,
    steps = 1,
    getFunc = _addon.settings["reminderOfflineTime"],
    setFunc = function(value)
      _addon.settings["reminderOfflineTime"] = value

      if ( _addon.settings["reminderOffline"] ) then
        EVENT_MANAGER:UnregisterForUpdate("SGT_AutoAFK_Reminder")
        _addon.core.reminderOffline()
      end

    end,
  }
end

function _addon.core.setOnline()
  local currentStatus = GetPlayerStatus()

  if ( _addon.settings["autoOnline"] and currentStatus == _offline ) then
      SelectPlayerStatus(_online)
  end
end

function _addon.core.isAutoAFK()
  if ( _addon.settings["enabled"] ) then
    EVENT_MANAGER:UnregisterForUpdate("ShissuGT_AutoAFK")
    local currentStatus = GetPlayerStatus()

    if currentStatus == _online or currentStatus == _dnd then
      _addon.core.autoAFK()
    end
  end
end

-- Bewegungen in der UI / Bewegung im Sichtfeld?
function _addon.core.EVENT_UI_MOVEMENT(eventCode)
  _addon.core.setOnline()

  local currentStatus = GetPlayerStatus()

  if (_addon.settings["enabled"] and currentStatus == _away) then
    SelectPlayerStatus(_cache)
    _addon.core.autoAFK()
  end
end

function _addon.core.autoAFK()
  local _minute = _addon.settings["time"]

  EVENT_MANAGER:RegisterForUpdate("ShissuGT_AutoAFK", _minute * 60 * 1000 , function()
    local currentStatus = GetPlayerStatus()
    local notMoving = not IsPlayerMoving()

    if notMoving and (currentStatus == _online or currentStatus == _dnd) then
      EVENT_MANAGER:UnregisterForUpdate("ShissuGT_AutoAFK")
      SelectPlayerStatus(_away)
    end
  end)
end

-- AutoAFK: Spielerstatus -> AFK -> Online/BRB
function _addon.core.EVENT_PLAYER_STATUS_CHANGED(eventCode, oldStatus, newStatus)
  _addon.cacheStatus = oldStatus

  if ( _addon.settings["reminderOffline"] and newStatus == _offline) then
    _addon.core.reminderOffline()
  end

  if _addon.settings["enabled"] then
    if newStatus == _away then
      EVENT_MANAGER:RegisterForUpdate("ShissuGT_AutoAFK", 500, function()
        local currentStatus = GetPlayerStatus()
        local moving = not IsPlayerMoving()

        if IsPlayerMoving() and currentStatus == _away then
          SelectPlayerStatus(_cache)
          EVENT_MANAGER:UnregisterForUpdate("ShissuGT_AutoAFK")
        end
      end)
    --end
    elseif newStatus == _online or newStatus == _dnd then
      _cache = newStatus
    end

    _addon.core.autoAFK()
  end
end

-- Automatische Erinnerung alle _addon.settings["reminderOfflineTime"]-Minuten
function _addon.core.reminderOffline()
  local _minute = _addon.settings["reminderOfflineTime"]
  local currentStatus = GetPlayerStatus()

  if ( currentStatus == _offline ) then
    EVENT_MANAGER:RegisterForUpdate("SGT_AutoAFK_Reminder", _minute * 60 * 1000 , function()
      local currentStatus = GetPlayerStatus()

      if ( currentStatus == _offline ) then
        d(_offlineText)
        _addon.core.setOnline()
      end

      if ( _addon.settings["reminderOffline"] == false ) then
        EVENT_MANAGER:UnregisterForUpdate("SGT_AutoAFK_Reminder")
      end
    end)
  end
end

-- * Initialisierung
function _addon.core.initialized()
  shissuGT = shissuGT or {}

  shissuGT[_addon.Name] = shissuGT[_addon.Name] or _addon.settings
  _addon.settings = shissuGT[_addon.Name]

  _addon.core.createSettingMenu()

  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_NEW_MOVEMENT_IN_UI_MODE, _addon.core.EVENT_UI_MOVEMENT)
  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_RETICLE_HIDDEN_UPDATE, _addon.core.EVENT_UI_MOVEMENT)
  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_PLAYER_STATUS_CHANGED, _addon.core.EVENT_PLAYER_STATUS_CHANGED)

  _addon.core.isAutoAFK()

  if ( _addon.settings["reminderOffline"] ) then
    if ( currentStatus == _offline ) then
      d(_offlineText)
    end

    _addon.core.reminderOffline()
  end
end

Shissu_SuiteManager._settings[_addon.Name] = {}
Shissu_SuiteManager._settings[_addon.Name].panel = _addon.panel
Shissu_SuiteManager._settings[_addon.Name].controls = _addon.controls
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized
