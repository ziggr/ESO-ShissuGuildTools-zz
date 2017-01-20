-- File: HistoryRosterConnect.lua
-- Zuletzt geändert: 18. Januar 2016

--local firstScan = true


local savedData = nil
local SGT = {}

SGT.guildId = nil
SGT.scanInterval = 3000
SGT.checkGuildTimer = 5 * 60 * 1000
SGT.firstGuildScan = false
SGT.scanCategory = ShissuGT.ZOS.History

-- SaveVariable Funktion: Anlegen Grundstruktur Gilde
function SGT.createGuild(guildName) 
  if (savedData[guildName] == nil) then 
    savedData[guildName] = {
      ["oldestEvent"] = {
        [ShissuGT.ZOS.History] = 0,
        [ShissuGT.ZOS.Bank] = 0,
      },
      
      ["lastScan"] = {
        [ShissuGT.ZOS.History] = 0,
        [ShissuGT.ZOS.Bank] = 0,     
      },
    } 
  end
end

-- SaveVariable Funktion: Anlegen Grundstruktur Accountname
function SGT.createAccount(guildName, displayName)
  if savedData[guildName][displayName] ~= nil then return end

  savedData[guildName][displayName] = {
    [ShissuGT.ZOS.GoldAdded] = {
      timeFirst = 0,
      timeLast = 0,
      last = 0,
      total = 0,
      currentNPC = 0,
      previousNPC = 0,
    },
    
    [ShissuGT.ZOS.GoldRemoved] = {
      timeFirst = 0,
      timeLast = 0,
      last = 0,
      total = 0,
      currentNPC = 0,
      previousNPC = 0,
    },  
    
    [ShissuGT.ZOS.ItemAdded] = {
      timeFirst = 0,
      timeLast = 0,
      last = 0,
      total = 0,
      currentNPC = 0,
      previousNPC = 0,
    },
    
    [ShissuGT.ZOS.ItemRemoved] = {
      timeFirst = 0,
      timeLast = 0,
      last = 0,
      total = 0,
      currentNPC = 0,
      previousNPC = 0,
    },      
  }
end

function SGT.previousTime(guildName, category)
  local oldestEvent = savedData[guildName]["oldestEvent"][category]
  
  if oldestEvent > 0 then return oldestEvent end
  
  local t = 1500000000
      
  for _, displayName in pairs(savedData[guildName]) do
    if (displayName["timeJoined"] ~= nil) then
      
      if (category == ShissuGT.ZOS.History) then
        if (displayName["timeJoined"] > 0) and (displayName["timeJoined"] < t) then
          t = displayName["timeJoined"]
        end
      else
        if (displayName[ShissuGT.ZOS.GoldAdded].timeFirst > 0) and (displayName[ShissuGT.ZOS.GoldAdded].timeFirst < t) then
          t = displayName[ShissuGT.ZOS.GoldAdded].timeFirst
        end
      end
    end
  end

  return t
end

function SGT.copyCurrentDateToLast(guildName)
  for _, displayName in pairs(savedData[guildName]) do
    savedData[guildName][displayName][ShissuGT.ZOS.GoldAdded].previousNPC = savedData[guildName][displayName][ShissuGT.ZOS.GoldAdded].currentNPC
    savedData[guildName][displayName][ShissuGT.ZOS.GoldAdded].currentNPC = 0
  
    savedData[guildName][displayName][ShissuGT.ZOS.GoldRemoved].previousNPC = savedData[guildName][displayName][ShissuGT.ZOS.GoldRemoved].currentNPC
    savedData[guildName][displayName][ShissuGT.ZOS.GoldRemoved].currentNPC = 0

    savedData[guildName][displayName][ShissuGT.ZOS.ItemAdded].previousNPC = savedData[guildName][displayName][ShissuGT.ZOS.ItemAdded].currentNPC
    savedData[guildName][displayName][ShissuGT.ZOS.ItemAdded].currentNPC = 0

    savedData[guildName][displayName][ShissuGT.ZOS.ItemRemoved].previousNPC = savedData[guildName][displayName][ShissuGT.ZOS.ItemRemoved].currentNPC
    savedData[guildName][displayName][ShissuGT.ZOS.ItemRemoved].currentNPC = 0  
  end
end

-- Events auslesen und Änderungen speichern / hinzufügen
function SGT.processEvents(guildId, category)
  local numEvents = GetNumGuildEvents(guildId, category)

  if (numEvents == 0) then return end
  
  local guildName = GetGuildName(guildId)
  local _, firstTime = GetGuildEventInfo(guildId, category, 1)
  local _, lastTime = GetGuildEventInfo(guildId, category, numEvents)
  local lastScan = savedData[GetGuildName(guildId)]["lastScan"][category]
  local first = numEvents
  local last = 1
  local inc = -1

  if lastScan == nil then lastScan = 0 end

  if (firstTime > lastTime) then
    first = 1
    last = numEvents
    inc = 1
  end

  -- NPC?
  local currentKioskTime = GetTimeStamp() + ShissuGT.Lib.GetNextKioskTime() - 604800
  
  if savedData["NPC"].currentTime ~= 0 then 
    if savedData["NPC"].currentTime < currentKioskTime then
      savedData["NPC"].previousTime = savedData["NPC"].currentTime
      savedData["NPC"].currentTime = savedData["NPC"].currentTime - (604800)
      
      --SGT.copyCurrentDateToLast(guildName)
    end     
  else
    savedData["NPC"].currentTime = currentKioskTime     
    savedData["NPC"].previousTime = currentKioskTime - (604800)   
  end

  -- Event abarbeiten
  for eventId = first, last, inc do
    local eventType, eventTime, displayName, eventGold = GetGuildEventInfo(guildId, category, eventId)

    -- Existiert der Account in der Datenbank? Wenn nein, erstellen!
    SGT.createAccount(guildName, displayName)
     
    local timeStamp = GetTimeStamp() - eventTime
    local oldestEvent = SGT.previousTime(guildName, category)

    if timeStamp > 0 then
      -- TimeStamp vom ältesten Event speichern        
      if (oldestEvent == 0) or (oldestEvent > timeStamp) then
        savedData[guildName]["oldestEvent"][category] = timeStamp
      end
    end

    if (timeStamp > lastScan) or (lastScan == 0) then
    -- Mitglied - Wann eingeladen?
      if (category == ShissuGT.ZOS.History) then
        if (eventType == ShissuGT.ZOS.Joined) then
          savedData[guildName][displayName].timeJoined = timeStamp
        end
          
        savedData[guildName]["lastScan"][category] = timeStamp
      end
        
      -- Mitglied - Bankaktivitäten
      if (category == ShissuGT.ZOS.Bank) then
        if (eventType == ShissuGT.ZOS.GoldAdded) or (eventType == ShissuGT.ZOS.GoldRemoved) or (eventType == ShissuGT.ZOS.ItemAdded) or (eventType == ShissuGT.ZOS.ItemRemoved) then
          if (savedData[guildName][displayName][eventType].timeLast < timeStamp) and (math.abs(savedData[guildName][displayName][eventType].timeLast - timeStamp) > 2) then   
            savedData[guildName][displayName][eventType].total = savedData[guildName][displayName][eventType].total + eventGold
            savedData[guildName][displayName][eventType].last = eventGold 
            savedData[guildName][displayName][eventType].timeLast = timeStamp

            -- seit NPC
            if timeStamp > savedData["NPC"].currentTime then
              savedData[guildName][displayName][eventType].currentNPC = savedData[guildName][displayName][eventType].currentNPC + eventGold 
            end
            
            if timeStamp < savedData["NPC"].currentTime and timeStamp > savedData["NPC"].previousTime then
              savedData[guildName][displayName][eventType].previousNPC = savedData[guildName][displayName][eventType].previousNPC + eventGold 
            end            

            if (savedData[guildName][displayName][eventType].timeFirst == 0) then
              savedData[guildName][displayName][eventType].timeFirst = timeStamp
            end
          
          end
        end

        savedData[guildName]["lastScan"][category] = timeStamp
      end
    end  
  end
end

function SGT.HistoryResponseReceived(eventCode, guildId, category)
  if (category ~= ShissuGT.ZOS.History) and (category ~= ShissuGT.ZOS.Bank) then return end

  local lastScan = savedData[GetGuildName(guildId)]["lastScan"][category]
  if lastScan == nil then  
    zo_callLater(SGT.requestData, SGT.scanInterval)
    return
  end
 
  local numEvents = GetNumGuildEvents(guildId, category)
  local _, firstTime = GetGuildEventInfo(guildId, category, 1)
  local _, lastTime = GetGuildEventInfo(guildId, category, numEvents)  
  local timeStamp = GetTimeStamp()

  if ((timeStamp - firstTime) > lastScan and (timeStamp  - lastTime) > lastScan) or (lastScan == 0) then
    zo_callLater(SGT.openHistoryPages, SGT.scanInterval)
  else
    SGT.processEvents(guildId, category)
    SGT.scanNext()
  end
end

function SGT.openHistoryPages()
  local historyPage = RequestGuildHistoryCategoryOlder(SGT.guildId, SGT.scanCategory)

 -- if (firstScan) then
  --  firstScan = false
--    SGT.createGuild(GetGuildName(guildId))
   -- historyPage = RequestGuildHistoryCategoryNewest(guildId, SGT.scanCategory)
  --else
    -- historyPage = RequestGuildHistoryCategoryOlder(guildId, SGT.scanCategory)
  --end

  -- Keine weiteren Seiten, bzw. Daten vorhanden
  if (not historyPage) then
    SGT.processEvents(SGT.guildId, SGT.scanCategory)
    SGT.scanNext()
  end
end

function SGT.scanNext()
  if (SGT.scanCategory == ShissuGT.ZOS.History) then
    SGT.scan(SGT.guildId, ShissuGT.ZOS.Bank)
  else
  --  if (SGT.firstGuildScan == true) then
  --    local guildName = GetGuildName(GetGuildId(SGT.guildId))    
    --  d("[SGT] Aufzeichnungen von: " .. guildName .. " werden eingelesen. Bitte warten sie einige Minuten... Danke!")      
--      SGT.firstGuildScan = false
    --  if SGT.guildId == GetNumGuilds() then
  --      d("FERTIG")
   --   end
 --   end


   if SGT.guildId == GetNumGuilds() and SGT.firstGuildScan == true then
        d("FERTIG")
      end
      

    if (SGT.guildId < GetNumGuilds()) then
      SGT.scan(SGT.guildId + 1, ShissuGT.ZOS.History)
    else
    
   
      EVENT_MANAGER:UnregisterForEvent(ShissuGT.Name, EVENT_GUILD_HISTORY_RESPONSE_RECEIVED)
      zo_callLater(SGT.availableGuild, SGT.checkGuildTimer)
    end
  end
end

function SGT.scan(guildId, category)
  SGT.guildId = GetGuildId(guildId)
  SGT.scanCategory = category
  --firstScan = true              
  
  local guildName = GetGuildName(guildId)

  if (savedData[guildName] == nil) then
    d("[SGT] Die Gildenaufzeichnungen von: " .. guildName .. " werden gerade eingelesen. Bitte warten Sie... !")
                              
    SGT.createGuild(guildName)
    SGT.firstGuildScan = true
  end

  zo_callLater(SGT.openHistoryPages, SGT.scanInterval)
end 

-- Gilden vorhanden?
function SGT.availableGuild()
  if GetNumGuilds() > 0 then  
    EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_GUILD_HISTORY_RESPONSE_RECEIVED, SGT.HistoryResponseReceived)
    SGT.scan(1, ShissuGT.ZOS.History)
  else
    zo_callLater(SGT.availableGuild, SGT.checkGuildTimer)
  end
end

-- Start History Scanner to Collect Data for Roster
function ShissuGT.History.Scanner()
  shissuGT.History2 = shissuGT.History2 or {}
  savedData = shissuGT.History2
  
  if savedData["NPC"] == nil then
    savedData["NPC"] = {
      ["currentTime"] = 0,
      ["previousTime"] = 0,         
    }
  end

  zo_callLater(SGT.availableGuild, 1000)
end

function SGT.OnPlayerActivated(eventCode)
  EVENT_MANAGER:UnregisterForEvent(ShissuGT.Name, eventCode)

  ShissuGT.History.Scanner()
end

EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_PLAYER_ACTIVATED, SGT.OnPlayerActivated)