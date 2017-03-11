-- Shissu GuildTools Module File
--------------------------------
-- File: scanner.lua
-- Version: v1.2.7
-- Last Update: 09.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!

local _globals = Shissu_SuiteManager._globals
local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]
local zos = _globals["ZOS"]

local _lib = Shissu_SuiteManager._lib
local _SGT = Shissu_SuiteManager._lib["SGT"]
local getString = _SGT.getString

local _addon = {}
_addon.Name	= "ShissuScanner"
_addon.core = {}
     
local _scanner = {}

_scanner.guildId = nil
_scanner.scanInterval = 3000
_scanner.checkGuildTimer = 5 * 60 * 1000
_scanner.firstGuildScan = false
_scanner.scanCategory = zos["History"]

local _history = {}

-- SaveVariable Funktion: Anlegen Grundstruktur Gilde
function _scanner.createGuild(guildName) 
  if (_history[guildName] == nil) then 
    _history[guildName] = {
      ["oldestEvent"] = {
        [zos["History"]] = 0,
        [zos["Bank"]] = 0,
      },
      
      ["lastScan"] = {
        [zos["History"]] = 0,
        [zos["Bank"]] = 0,     
      },
    } 
  end
end 

-- SaveVariable Funktion: Anlegen Grundstruktur Accountname
function _scanner.createAccount(guildName, displayName)
  _scanner.createGuild(guildName)  
  if _history[guildName][displayName] ~= nil then return end
  
  function _scanner.createVars(guildName, displayName, event)
    _history[guildName][displayName][event] = {}
    _history[guildName][displayName][event].timeFirst = 0
    _history[guildName][displayName][event].timeLast = 0
    _history[guildName][displayName][event].last = 0
    _history[guildName][displayName][event].total = 0
    _history[guildName][displayName][event].currentNPC = 0
    _history[guildName][displayName][event].previousNPC = 0
  end       
  
  _history[guildName][displayName] = {}
  _scanner.createVars(guildName, displayName, zos["GoldAdded"])
  _scanner.createVars(guildName, displayName, zos["GoldRemoved"])
  _scanner.createVars(guildName, displayName, zos["ItemAdded"])
  _scanner.createVars(guildName, displayName, zos["ItemRemoved"])
end

function _scanner.previousTime(guildName, category)
  local oldestEvent = _history[guildName]["oldestEvent"][category]
  
  if oldestEvent > 0 then return oldestEvent end
  
  local t = 1500000000
      
  for _, displayName in pairs(_history[guildName]) do
    if (displayName["timeJoined"] ~= nil) then
      
      if (category == zos["History"]) then
        if (displayName["timeJoined"] > 0) and (displayName["timeJoined"] < t) then
          t = displayName["timeJoined"]
        end
      else
        if (displayName[zos["GoldAdded"]].timeFirst > 0) and (displayName[zos["GoldAdded"]].timeFirst < t) then
          t = displayName[zos["GoldAdded"]].timeFirst
        end
      end
    end
  end

  return t
end

function _scanner.copyCurrentDateToLast() 
  for guildId=1, GetNumGuilds() do
    local guildName = GetGuildName(guildId)
    
    for displayName, _ in pairs(_history[guildName]) do
      if (_history[guildName][displayName] ~= nil) then
      
        if _history[guildName][displayName][zos["GoldAdded"]] ~= nil then  
          if _history[guildName][displayName][zos["GoldAdded"]].currentNPC ~= nil then
            _history[guildName][displayName][zos["GoldAdded"]].previousNPC = _history[guildName][displayName][zos["GoldAdded"]].currentNPC
            _history[guildName][displayName][zos["GoldAdded"]].currentNPC = 0
          end
        end
        
        if _history[guildName][displayName][zos["GoldRemoved"]] ~= nil then 
          if _history[guildName][displayName][zos["GoldRemoved"]].currentNPC ~= nil then
            _history[guildName][displayName][zos["GoldRemoved"]].previousNPC = _history[guildName][displayName][zos["GoldRemoved"]].currentNPC
            _history[guildName][displayName][zos["GoldRemoved"]].currentNPC = 0
          end
        end
        
        if _history[guildName][displayName][zos["ItemAdded"]] ~= nil then 
          if _history[guildName][displayName][zos["ItemAdded"]].currentNPC ~= nil then
            _history[guildName][displayName][zos["ItemAdded"]].previousNPC = _history[guildName][displayName][zos["ItemAdded"]].currentNPC
            _history[guildName][displayName][zos["ItemAdded"]].currentNPC = 0
          end
        end

        if _history[guildName][displayName][zos["ItemRemoved"]] ~= nil then 
          if _history[guildName][displayName][zos["ItemRemoved"]].currentNPC ~= nil then
            _history[guildName][displayName][zos["ItemRemoved"]].previousNPC = _history[guildName][displayName][zos["ItemRemoved"]].currentNPC
            _history[guildName][displayName][zos["ItemRemoved"]].currentNPC = 0 
          end
        end
      end
    end
  end
end

-- Events auslesen und Änderungen speichern / hinzufügen
function _scanner.processEvents(guildId, category)
  local numEvents = GetNumGuildEvents(guildId, category)

  if (numEvents == 0) then return end
  
  local guildName = GetGuildName(guildId)
  local _, firstTime = GetGuildEventInfo(guildId, category, 1)
  local _, lastTime = GetGuildEventInfo(guildId, category, numEvents)
  local lastScan = _history[GetGuildName(guildId)]["lastScan"][category]
  local first = numEvents
  local last = 1
  local inc = -1

  if lastScan == nil then lastScan = 0 end

  local nextKiosk = _SGT.currentTime() + _SGT.getKioskTime()
  local lastKiosk = nextKiosk - 604800
  local previousKiosk = lastKiosk - 604800
  
  --d("NÄCHSTER: " .. GetDateStringFromTimestamp(nextKiosk) .. " - " .. ZO_FormatTime((previousKiosk) % 86400, TIME_FORMAT_STYLE_CLOCK_TIME, TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR))    
  --d("LETZTER: " .. GetDateStringFromTimestamp(lastKiosk) .. " - " .. ZO_FormatTime((lastKiosk) % 86400, TIME_FORMAT_STYLE_CLOCK_TIME, TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR))
  ---d("VORLETZTER: " .. GetDateStringFromTimestamp(previousKiosk) .. " - " .. ZO_FormatTime((previousKiosk) % 86400, TIME_FORMAT_STYLE_CLOCK_TIME, TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR))  
   
  -- Aktuelle Woche -> Letzte Woche
  -- Letzte Woche  -> Vorletzte Woche
  if (_history["Kiosk"] ~= nil) then
    if (lastKiosk > _history["Kiosk"] ) then
      _history["Kiosk"] = lastKiosk
      --d("Händler hat sich geänder: ---> Current -> Privious")
      
      _scanner.copyCurrentDateToLast() 
    end
  else
    _history["Kiosk"] = lastKiosk
  end  

  if (firstTime > lastTime) then
    first = 1
    last = numEvents
    inc = 1
  end

  -- Event abarbeiten
  for eventId = first, last, inc do
    local eventType, eventTime, displayName, eventGold = GetGuildEventInfo(guildId, category, eventId)

    -- Existiert der Account in der Datenbank? Wenn nein, erstellen!
    if displayName ~= nil then
      _scanner.createAccount(guildName, displayName)
       
      local timeStamp = GetTimeStamp() - eventTime
      local oldestEvent = _scanner.previousTime(guildName, category)
  
      if timeStamp > 0 then
        -- TimeStamp vom ältesten Event speichern                         
        if (oldestEvent == 0) or (oldestEvent > timeStamp) then
          _history[guildName]["oldestEvent"][category] = timeStamp
        end
      end
  
      if (timeStamp > lastScan) or (lastScan == 0) then
      -- Mitglied - Wann eingeladen?
        if (category == zos["History"]) then
          if (eventType == zos["Joined"]) then
            _history[guildName][displayName].timeJoined = timeStamp
          end
            
          _history[guildName]["lastScan"][category] = timeStamp
        end
          
        -- Mitglied - Bankaktivitäten
        if (category == zos["Bank"]) then
          if (eventType == zos["GoldAdded"]) or (eventType == zos["GoldRemoved"]) or (eventType == zos["ItemAdded"]) or (eventType == zos["ItemRemoved"]) then
            if (_history[guildName][displayName][eventType].timeLast < timeStamp) and (math.abs(_history[guildName][displayName][eventType].timeLast - timeStamp) > 2) then   
              _history[guildName][displayName][eventType].total = _history[guildName][displayName][eventType].total + eventGold
              _history[guildName][displayName][eventType].last = eventGold 
              _history[guildName][displayName][eventType].timeLast = timeStamp
    
              -- seit NPC
              if timeStamp > lastKiosk then
                _history[guildName][displayName][eventType].currentNPC = _history[guildName][displayName][eventType].currentNPC + eventGold 
              end
              
              if timeStamp > previousKiosk and timeStamp < lastKiosk then
                _history[guildName][displayName][eventType].previousNPC = _history[guildName][displayName][eventType].previousNPC + eventGold 
              end
   
              if (_history[guildName][displayName][eventType].timeFirst == 0) then
                _history[guildName][displayName][eventType].timeFirst = timeStamp
              end
            
            end
          end
  
          _history[guildName]["lastScan"][category] = timeStamp
        end
      end  
    end
  end
end

function _scanner.requestData()
  local guildId = GetGuildId(_scanner.guildId)
  local newPage

  if (firstGuildScan) then
    firstGuildScan = false
    _scanner.createGuild(guildName)
    _scanner.firstGuildScan = true
    _scanner.openHistoryPages()
  end

  if (not newPage) then
    _scanner.processEvents(guildId, category)
    _scanner.scanNext()
  end
end

function _scanner.HistoryResponseReceived(eventCode, guildId, category)
  if (category ~= zos["History"]) and (category ~= zos["Bank"]) then return end
  
  _scanner.createGuild(GetGuildName(guildId))
  
  local lastScan = _history[GetGuildName(guildId)]["lastScan"][category]
  if lastScan == nil then  
    zo_callLater(_scanner.requestData, _scanner.scanInterval)   
    --zo_callLater(_scanner.openHistoryPages, _scanner.scanInterval)
    return
  end
 
  local numEvents = GetNumGuildEvents(guildId, category)
  local _, firstTime = GetGuildEventInfo(guildId, category, 1)
  local _, lastTime = GetGuildEventInfo(guildId, category, numEvents)  
  local timeStamp = GetTimeStamp()

  if ((timeStamp - firstTime) > lastScan and (timeStamp  - lastTime) > lastScan) or (lastScan == 0) then
    zo_callLater(_scanner.openHistoryPages, _scanner.scanInterval)
  else
    _scanner.processEvents(guildId, category)
    _scanner.scanNext()
  end
end

function _scanner.openHistoryPages() 
  local historyPage = RequestGuildHistoryCategoryOlder(_scanner.guildId, _scanner.scanCategory)
   
  -- Keine weiteren Seiten, bzw. Daten vorhanden
  if (not historyPage) then
    if (GetNumGuilds() == _scanner.guildId) then
      if GetNumGuilds() > 1 then
        _scanner.guildId = 1  
      end
    end
    
    _scanner.processEvents(_scanner.guildId, _scanner.scanCategory)
    _scanner.scanNext()
  end
end

function _scanner.scanNext()
  if (_scanner.scanCategory == zos["History"]) then
    _scanner.scan(_scanner.guildId, zos["Bank"])
  else
    if _scanner.guildId == GetNumGuilds() and _scanner.firstGuildScan == true then
      _scanner.firstGuildScan = false
        d(blue .. "Shissu's " .. white  "Guild Tools: DONE")
    end
      
    if (_scanner.guildId < GetNumGuilds()) then
      _scanner.scan(_scanner.guildId + 1, zos["History"])
    else
      EVENT_MANAGER:UnregisterForEvent(_addon.Name, EVENT_GUILD_HISTORY_RESPONSE_RECEIVED)
      zo_callLater(_scanner.availableGuild, _scanner.checkGuildTimer)
    end
  end
end

function _scanner.scan(guildId, category)
  _scanner.guildId = GetGuildId(guildId)
  _scanner.scanCategory = category        
  
  local guildName = GetGuildName(guildId)

  if (_history[guildName] == nil) then
    d(blue.. "Shissu's" .. white .. "Guild Tools: " .. getString(ShissuScanner_scan1) .. ": " .. guildName .. " " .. getString(ShissuScanner_scan2))
                              
    _scanner.createGuild(guildName)
    _scanner.firstGuildScan = true
  end

  zo_callLater(_scanner.openHistoryPages, _scanner.scanInterval)
end 


-- Gilden vorhanden?
function _scanner.availableGuild()            
  if GetNumGuilds() > 0 then  
    EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_GUILD_HISTORY_RESPONSE_RECEIVED, _scanner.HistoryResponseReceived)
    _scanner.scan(1, zos["History"])
  else

    zo_callLater(_scanner.availableGuild, _scanner.checkGuildTimer)
  end
end

-- * Initialisierung
function _addon.core.initialized()
  shissuGT.History = shissuGT.History or {}
  _history = shissuGT.History
  
  zo_callLater(_scanner.availableGuild, 1000)
end                               
  
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized