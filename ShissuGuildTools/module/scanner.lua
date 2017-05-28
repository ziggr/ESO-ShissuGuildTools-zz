-- Shissu GuildTools Module File
--------------------------------
-- File: scanner.lua
-- Version: v1.3.3
-- Last Update: 21.05.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!


local _globals = Shissu_SuiteManager._globals
local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]

local _SGT = Shissu_SuiteManager._lib["SGT"]
local getString = _SGT.getString
                                    
_addon = {}
_addon.Name = "ShissuScanner"

_addon.scanGuild = 5 * 60 * 1000
_addon.scanInterval = 3000
_addon.guildId = nil
_addon.firstGuildScan = false
_addon.firstScan = true
_addon.scanCategory = GUILD_HISTORY_GENERAL
_addon.core = {}

function _addon.core.getData(eventType, displayName, guildName)
  local timeFirst = 0  
  local timeLast = 0                        
  local totalGold = 0
  local currentNPC = 0
  local previousNPC = 0
  
  if _history[guildName] then                        
    if _history[guildName][displayName] then
      if _history[guildName][displayName][eventType] then
        timeFirst = _history[guildName][displayName][eventType].timeFirst or 0
        timeLast = _history[guildName][displayName][eventType].timeLast or 0                        
        totalGold = _history[guildName][displayName][eventType].total or 0
        totalGold = _history[guildName][displayName][eventType].currentNPC or 0
        totalGold = _history[guildName][displayName][eventType].previousNPC or 0
      end
    end
  end

  return {timeFirst, timeLast, totalGold, currentNPC, previousNPC}
end

function _addon.core.createDisplayNameData(guildName, displayName)
  if (_history[guildName][displayName] == nil) then
    _history[guildName][displayName] = {}
  end    
end

function _addon.core.copyCurrentToPrev(guildName, displayName, eventType)
  if (_history[guildName][displayName] ~= nil) then
    if _history[guildName][displayName][eventType] ~= nil then  
      if _history[guildName][displayName][eventType].currentNPC ~= nil then
        _history[guildName][displayName][eventType].previousNPC = _history[guildName][displayName][eventType].currentNPC
        _history[guildName][displayName][eventType].currentNPC = nil
      end
    end
  end
end

function _addon.core.copyCurrentDateToLast() 
  for guildId=1, GetNumGuilds() do
    guildId = GetGuildId(guildId)
    local guildName = GetGuildName(guildId)
    
    for displayName, _ in pairs(_history[guildName]) do
      if (_history[guildName][displayName] ~= nil) then
      
        _addon.core.copyCurrentToPrev(guildName, displayName, GUILD_EVENT_BANKGOLD_ADDED)
        _addon.core.copyCurrentToPrev(guildName, displayName, GUILD_EVENT_BANKGOLD_REMOVED)
        _addon.core.copyCurrentToPrev(guildName, displayName, GUILD_EVENT_BANKITEM_ADDED)
        _addon.core.copyCurrentToPrev(guildName, displayName, GUILD_EVENT_BANKITEM_REMOVED)
      end
    end
  end
end

function _addon.core.previousTime(guildName, category)
  if _history[guildName] ~= nil then
    return 1500000000
  end
  
  if _history[guildName]["oldestEvent"] ~= nil then
    return 1500000000
  end
  
  local oldestEvent = _history[guildName]["oldestEvent"][category]
  
  if oldestEvent ~= nil then 
    if oldestEvent > 0 then return oldestEvent end
  end  

  local t = 1500000000
      
  for _, displayName in pairs(_history[guildName]) do
    if (displayName["timeJoined"] ~= nil) then
      
      if (category == GUILD_HISTORY_GENERAL) then
        if (displayName["timeJoined"] > 0) and (displayName["timeJoined"] < t) then
          t = displayName["timeJoined"]
        end
      else
        if (displayName[GUILD_EVENT_BANKGOLD_ADDED].timeFirst > 0) and (displayName[GUILD_EVENT_BANKGOLD_ADDED].timeFirst < t) then
          t = displayName[GUILD_EVENT_BANKGOLD_ADDED].timeFirst
        end
      end
    end
  end

  return t
end

function _addon.core.processEvents(guildId, category)
  local guildName = GetGuildName(guildId)
  local numEvents = GetNumGuildEvents(guildId, category)

  if (numEvents == 0) then return end

  local _, firstEventTime = GetGuildEventInfo(guildId, category, 1)
  local _, lastEventTime = GetGuildEventInfo(guildId, category, numEvents)
  local lastScan = _history[GetGuildName(guildId)]["lastScans"][category] or 0
  local first = numEvents
  local last = 1
  local inc = -1

  local nextKiosk = _SGT.currentTime() + _SGT.getKioskTime()
  local lastKiosk = nextKiosk - 604800
  local previousKiosk = lastKiosk - 604800
  
  --d("process: " .. guildId .. guildName)
  
  --d("NÄCHSTER: " .. GetDateStringFromTimestamp(nextKiosk) .. " - " .. ZO_FormatTime((previousKiosk) % 86400, TIME_FORMAT_STYLE_CLOCK_TIME, TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR))    
  --d("LETZTER: " .. GetDateStringFromTimestamp(lastKiosk) .. " - " .. ZO_FormatTime((lastKiosk) % 86400, TIME_FORMAT_STYLE_CLOCK_TIME, TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR))
  ---d("VORLETZTER: " .. GetDateStringFromTimestamp(previousKiosk) .. " - " .. ZO_FormatTime((previousKiosk) % 86400, TIME_FORMAT_STYLE_CLOCK_TIME, TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR))  
     
  -- Kopieren der "aktuellen Woche" zu "letzte Woche", Neustart "aktuelle Woche"
  if (_history["Kiosk"] ~= nil) then
    if (lastKiosk > _history["Kiosk"] ) then
      _history["Kiosk"] = lastKiosk
      _addon.core.copyCurrentDateToLast() 
    end
  else
    _history["Kiosk"] = lastKiosk
  end    
  
  if (firstEventTime > lastEventTime) then
    first = 1
    last = numEvents
    inc = 1
  end
  
  -- Event abarbeiten  
  for eventId = first, last, inc do
    local eventType, eventTime, displayName, eventGold = GetGuildEventInfo(guildId, category, eventId)
    local timeStamp = GetTimeStamp() - eventTime
    local oldestEvent = _addon.core.previousTime(guildName, category)
    
    -- TimeStamp vom ältesten Event speichern 
    if timeStamp > 0 then               
      if (oldestEvent == 0) or (oldestEvent > timeStamp) then
        if _history[guildName] ~= nil then
          if _history[guildName]["oldestEvent"] ~= nil then
            _history[guildName]["oldestEvent"][category] = timeStamp
          else
            _history[guildName]["oldestEvent"] = {}
            _history[guildName]["oldestEvent"][category] = timeStamp
          end
        end
      end
    end

    if (timeStamp > lastScan) or (lastScan == 0) then  
      -- Wann eingeladen / beigetreten in die Gilde?       
      if (category == GUILD_HISTORY_GENERAL) then
        if (eventType == GUILD_EVENT_GUILD_JOIN) then
          local timeJoined = 0 
                          
          if _history[guildName][displayName] ~= nil then
            timeJoined = _history[guildName][displayName].timeJoined or 0 
              
            if (timeJoined < timeStamp) then
              _history[guildName][displayName].timeJoined = timeStamp
            end
              
          else
            _addon.core.createDisplayNameData(guildName, displayName)
            _history[guildName][displayName].timeJoined = timeStamp  
          end
        end

        _history[guildName]["lastScans"][category] = timeStamp
      end
      
      -- Bankaktivitäten  
      if (category == GUILD_HISTORY_BANK) then
        if (eventType == GUILD_EVENT_BANKGOLD_ADDED) or (eventType == GUILD_EVENT_BANKGOLD_REMOVED) or (eventType == GUILD_EVENT_BANKITEM_ADDED) or (eventType == GUILD_EVENT_BANKITEM_REMOVED) then
          local getData =  _addon.core.getData(eventType, displayName, guildName)
                        
          local timeFirst = getData[1]
          local timeLast = getData[2]
          local totalGold = getData[3]
          local currentNPC = getData[4]
          local previousNPC = getData[5]
          
          if (timeLast < timeStamp) and (math.abs(timeLast - timeStamp) > 2) then
            _addon.core.createDisplayNameData(guildName, displayName)
            
            if (diplayName == "@Shissu") then
              d(_history[guildName][displayName][eventType])
            end  
            
            if _history[guildName][displayName][eventType] == nil then
              _history[guildName][displayName][eventType] = {}
            end
              
            _history[guildName][displayName][eventType].total = totalGold + eventGold
            _history[guildName][displayName][eventType].last = eventGold
            _history[guildName][displayName][eventType].timeLast = timeStamp

            -- seit NPC
            if timeStamp > lastKiosk then
              _history[guildName][displayName][eventType].currentNPC = currentNPC + eventGold 
            end
            
          -- d(timeStamp)
           -- d(previousKiosk)
           -- d(lastKiosk)
              
            if timeStamp > previousKiosk and timeStamp < lastKiosk then
              _history[guildName][displayName][eventType].previousNPC = previousNPC + eventGold 
            end
     
            if (timeFirst == 0) then
              _history[guildName][displayName][eventType].timeFirst = timeStamp      
            end
          end
        end
          
        _history[guildName]["lastScans"][category] = timeStamp
      end
    end
  end
end

function _addon.core.historyResponseReceived(eventCode, guildId, category)
  if (category ~= GUILD_HISTORY_GENERAL) and (category ~= GUILD_HISTORY_BANK) and guildId ~= nil then return end

  local numEvents = GetNumGuildEvents(guildId, category)
  local _, firstEventTime = GetGuildEventInfo(guildId, category, 1)
  local _, lastEventTime = GetGuildEventInfo(guildId, category, numEvents)
  local lastScan = _history[GetGuildName(guildId)]["lastScans"][category] or 0
  local timeStamp = GetTimeStamp()

  if ((timeStamp - firstEventTime) > lastScan and (timeStamp  - lastEventTime) > lastScan) or (lastScan == 0) then
    zo_callLater(_addon.core.openHistoryPages, _addon.scanInterval)
  else
    _addon.core.processEvents(guildId, category)
    _addon.core.scanNext()
  end
end

function _addon.core.openHistoryPages()
  local guildId = GetGuildId(_addon.guildId)

  --local historyPage = RequestGuildHistoryCategoryNewest(guildId, _addon.scanCategory)
  local historyPage = RequestGuildHistoryCategoryOlder(guildId, _addon.scanCategory)
 -- local historyPage
    
  if (_addon.firstScan) then
    _addon.firstScan = false
    local guildName = GetGuildName(guildId)
      
    _history[guildName] = _history[guildName] or {}
    _history[guildName]["oldestEvents"] = _history[guildName]["oldestEvents"] or {}
    _history[guildName]["lastScans"] = _history[guildName]["lastScans"] or {}    
    
    --local historyPage = RequestGuildHistoryCategoryOlder(guildId, _addon.scanCategory)
  else
   -- local historyPage = RequestGuildHistoryCategoryNewest(guildId, _addon.scanCategory) 
  end

  if (not historyPage) then          
    --if (GetNumGuilds() > 0) then
    --  if (GetNumGuilds() == _addon.guildId) then
     --   _addon.guildId = 1
     --   guildId = GetGuildId(_addon.guildId) 
     -- end
    --end
    
    _addon.core.processEvents(guildId, _addon.scanCategory)
    _addon.core.scanNext()
  end
end

function _addon.core.scanNext()
  if (_addon.scanCategory == GUILD_HISTORY_GENERAL) then
    _addon.core.scan(_addon.guildId, GUILD_HISTORY_BANK)
  else               
    if (_addon.firstGuildScan == true) then
      local guildId = GetGuildId(_addon.guildId)
      local guildName = GetGuildName(guildId)
      
      _addon.firstGuildScan = false
      
      d(blue.. "Shissu's" .. white .. "Guild Tools: " .. guildName .. " DONE")  
    end

    local numGuilds = GetNumGuilds() 
    
    if (_addon.guildId < numGuilds) then
      _addon.core.scan(_addon.guildId + 1, GUILD_HISTORY_GENERAL)
    else
      EVENT_MANAGER:UnregisterForEvent(_addon.Name, EVENT_GUILD_HISTORY_RESPONSE_RECEIVED)
      zo_callLater(_addon.scanAvailableGuilds, _addon.scanGuild)
    end
  end
end

function _addon.core.scan(guildId, category)                                                    
  _addon.guildId = GetGuildId(guildId)
  _addon.scanCategory = category

  local guildName = GetGuildName(guildId)  
  
  _addon.firstScan = true

  if (_history[guildName] == nil) then
    d(blue.. "Shissu's " .. white .. "Guild Tools: " .. getString(ShissuScanner_scan1) .. ": " .. guildName .. " " .. getString(ShissuScanner_scan2))

    _addon.firstGuildScan = true   
  end

  zo_callLater(_addon.core.openHistoryPages, _addon.scanInterval)
end

-- Gilden vorhanden?
function _addon.core.scanAvailableGuilds()
  local numGuilds = GetNumGuilds() 
  
  if (numGuilds > 0) then
    EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_GUILD_HISTORY_RESPONSE_RECEIVED, _addon.core.historyResponseReceived)
    _addon.core.scan(1, GUILD_HISTORY_GENERAL)
  else
    zo_callLater(_addon.core.scanAvailableGuilds, _addon.scanGuild)
  end
end

function _addon.core.removeOldData2(guildName, displayName, eventType)
  if _history[guildName] ~= nil then
    if _history[guildName][displayName] ~= nil then
      local newTable = _history[guildName][displayName][eventType]
      
      if (type(newTable) == "table") then
        if (_history[guildName][displayName][eventType].timeFirst == 0) then _history[guildName][displayName][eventType].timeFirst = nil end
        if (_history[guildName][displayName][eventType].timeLast == 0) then _history[guildName][displayName][eventType].timeLast= nil end
        if (_history[guildName][displayName][eventType].total == 0) then _history[guildName][displayName][eventType].total = nil end  
        if (_history[guildName][displayName][eventType].last == 0) then _history[guildName][displayName][eventType].last = nil end  
        if (_history[guildName][displayName][eventType].currentNPC == 0) then _history[guildName][displayName][eventType].currentNPC = nil end  
        if (_history[guildName][displayName][eventType].previousNPC == 0) then _history[guildName][displayName][eventType].previousNPC = nil end   
        
        local count = 0
        for _ in pairs(_history[guildName][displayName][eventType]) do count = count + 1 end
          
        if count == 0 then
          _history[guildName][displayName][eventType] = nil
        end      
      end
    end
  end  
end

function _addon.core.removeOldData()
  if (_history.reduce == nil) then
    for guildName, members in pairs(_history) do
      local guildData = _history[guildName]
        
      d(blue.. "Shissu's " .. white .. "Guild Tools: SAVEVAR REDUCING " .. guildName)
        
      if (type(guildData) == "table") then
        for displayName, memberData in pairs(guildData) do
          if (type(memberData) == "table") then
            _addon.core.removeOldData2(guildName, displayName, GUILD_EVENT_BANKGOLD_ADDED)
            _addon.core.removeOldData2(guildName, displayName, GUILD_EVENT_BANKGOLD_REMOVED)
            _addon.core.removeOldData2(guildName, displayName, GUILD_EVENT_BANKITEM_ADDED)
            _addon.core.removeOldData2(guildName, displayName, GUILD_EVENT_BANKITEM_REMOVED)
          end
        end  
      end
    end
      
    _history.reduce = true
  end 
end

-- * Initialisierung
function _addon.core.initialized()
  shissuGT.History = shissuGT.History or {}
  _history = shissuGT.History
  
  zo_callLater(_addon.core.removeOldData, 10000) 
  zo_callLater(_addon.core.scanAvailableGuilds, _addon.scanInterval)
end                               
  
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized