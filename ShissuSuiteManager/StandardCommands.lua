-- Shissu Suite Manager
-----------------------
-- File: StandardCommands.lua
-- Last Update: 27.10.2016
-- Written by Christian Flory (@Shissu) - esoui@flory.one

-- Released under terms in license accompanying this file.
-- Distribution without license is prohibited!

local _addon = {}
_addon.Name	= "ShissuStandardCommands"
_addon.Version = "1.0.1"
_addon.core = {}
_addon.formattedName	= "|cAFD3FFShissu's|r|ceeeeee Standard Commands"
_addon.panel = Shissu_SuiteManager._lib.setPanel("Standard Commands", _addon.formattedName, _addon.Version)
_addon.controls = {
  [1] = {
    type = "title",
    name = Shissu_SuiteManager._lib.getString(SGT_Standard1),     
  }, 
  [2] = {
    type = "description",
    text = Shissu_SuiteManager._lib.getString(SGT_Standard2),
  },          
}

function _addon.core.initialized()
end

Shissu_SuiteManager._settings[_addon.Name] = {}
Shissu_SuiteManager._settings[_addon.Name].panel = _addon.panel                                       
Shissu_SuiteManager._settings[_addon.Name].controls = _addon.controls                 
Shissu_SuiteManager._init[_addon.Name] = function() end 
