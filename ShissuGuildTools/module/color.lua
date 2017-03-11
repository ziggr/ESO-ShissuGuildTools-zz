-- Shissu GuildTools Module File
--------------------------------
-- File: color.lua
-- Version: v1.0.5
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
_addon.Name	= "ShissuColor"
_addon.Version = "1.0.5"
_addon.core = {}
_addon.fN = _SGT["title"](getString(ShissuColor_title))

_addon.settings = {
  ["c1"] = {1, 1, 1, 1},
  ["c2"] = {1, 1, 1, 1},
  ["c3"] = {1, 1, 1, 1},
  ["c4"] = {1, 1, 1, 1},
  ["c5"] = {1, 1, 1, 1},
}

_addon.panel = _setPanel(getString(ShissuColor_title), _addon.fN, _addon.Version)
_addon.controls = {}

function _addon.core.createSettingMenu()
  local controls = Shissu_SuiteManager._settings[_addon.Name].controls
  
  controls[#controls+1] = {
    type = "description", 
    text = getString(ShissuColor_desc1) .. ":",
  }
  
  controls[#controls+1] = {
    type = "description", 
    text = "- " .. blue .. getString(ShissuNotebook) .. white .. "\n- " ..
      blue .. getString(ShissuContextmenu_note) .. white .. "\n- " .. 
      blue .. getString(ShissuNotifications_motD) .. white .. "\n- " .. blue .. "...",
  }
  
  for i = 1, 5 do
    controls[#controls+1] = {
      type = "colorpicker", 
      name = getString(ShissuGuildHome_c) .. " " .. i,
      getFunc = _addon.settings["c" .. i], 
      setFunc = function (r, g, b, a) 
                                                                                                                                                                                           
        _addon.settings["c" .. i] = {r, g, b, a}
      end,
    }    
  end
end
 
-- * Initialisierung
function _addon.core.initialized()
  shissuGT = shissuGT or {}

  shissuGT[_addon.Name] = shissuGT[_addon.Name] or _addon.settings
  _addon.settings = shissuGT[_addon.Name]

  _addon.core.createSettingMenu()  
end                               

Shissu_SuiteManager._settings[_addon.Name] = {}
Shissu_SuiteManager._settings[_addon.Name].panel = _addon.panel                                       
Shissu_SuiteManager._settings[_addon.Name].controls = _addon.controls                 
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized    