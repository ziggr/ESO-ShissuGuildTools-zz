-- File: HistoryScanner.lua
-- Zuletzt geändert: 19. Januar 2016

local SGT = {}

SGT.guildId = nil
SGT.scanInterval = 6000
SGT.checkGuildTimer = 5 * 60 * 1000
SGT.firstGuildScan = false
SGT.scanCategory = ShissuGT.ZOS.History
SGT.History = nil

-- SaveVariable Funktion: Anlegen Grundstruktur Gilde
function SGT.createGuild(guildName) 
  if (SGT.History[guildName] == nil) then 
    SGT.History[guildName] = {
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
  SGT.createGuild(guildName)  
  if SGT.History[guildName][displayName] ~= nil then return end
  
  function SGT.createVars(guildName, displayName, event)
    SGT.History[guildName][displayName][event] = {}
    SGT.History[guildName][displayName][event].timeFirst = 0
    SGT.History[guildName][displayName][event].timeLast = 0
    SGT.History[guildName][displayName][event].last = 0
    SGT.History[guildName][displayName][event].total = 0
    SGT.History[guildName][displayName][event].currentNPC = 0
    SGT.History[guildName][displayName][event].previousNPC = 0
  end       
  
  SGT.History[guildName][displayName] = {}
  SGT.createVars(guildName, displayName, ShissuGT.ZOS.GoldAdded)
  SGT.createVars(guildName, displayName, ShissuGT.ZOS.GoldRemoved)
  SGT.createVars(guildName, displayName, ShissuGT.ZOS.ItemAdded)
  SGT.createVars(guildName, displayName, ShissuGT.ZOS.ItemRemoved)
end

function SGT.previousTime(guildName, category)
  local oldestEvent = SGT.History[guildName]["oldestEvent"][category]
  
  if oldestEvent > 0 then return oldestEvent end
  
  local t = 1500000000
      
  for _, displayName in pairs(SGT.History[guildName]) do
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

function SGT.copyCurrentDateToLast() 
  for guildId=1, GetNumGuilds() do
    local guildName = GetGuildName(guildId)
    
    for displayName, _ in pairs(SGT.History[guildName]) do
      if (SGT.History[guildName][displayName] ~= nil) then
      
        if SGT.History[guildName][displayName][ShissuGT.ZOS.GoldAdded] ~= nil then  
          if SGT.History[guildName][displayName][ShissuGT.ZOS.GoldAdded].currentNPC ~= nil then
            SGT.History[guildName][displayName][ShissuGT.ZOS.GoldAdded].previousNPC = SGT.History[guildName][displayName][ShissuGT.ZOS.GoldAdded].currentNPC
            SGT.History[guildName][displayName][ShissuGT.ZOS.GoldAdded].currentNPC = 0
          end
        end
        
        if SGT.History[guildName][displayName][ShissuGT.ZOS.GoldRemoved] ~= nil then 
          if SGT.History[guildName][displayName][ShissuGT.ZOS.GoldRemoved].currentNPC ~= nil then
            SGT.History[guildName][displayName][ShissuGT.ZOS.GoldRemoved].previousNPC = SGT.History[guildName][displayName][ShissuGT.ZOS.GoldRemoved].currentNPC
            SGT.History[guildName][displayName][ShissuGT.ZOS.GoldRemoved].currentNPC = 0
          end
        end
        
        if SGT.History[guildName][displayName][ShissuGT.ZOS.ItemAdded] ~= nil then 
          if SGT.History[guildName][displayName][ShissuGT.ZOS.ItemAdded].currentNPC ~= nil then
            SGT.History[guildName][displayName][ShissuGT.ZOS.ItemAdded].previousNPC = SGT.History[guildName][displayName][ShissuGT.ZOS.ItemAdded].currentNPC
            SGT.History[guildName][displayName][ShissuGT.ZOS.ItemAdded].currentNPC = 0
          end
        end

        if SGT.History[guildName][displayName][ShissuGT.ZOS.ItemRemoved] ~= nil then 
          if SGT.History[guildName][displayName][ShissuGT.ZOS.ItemRemoved].currentNPC ~= nil then
            SGT.History[guildName][displayName][ShissuGT.ZOS.ItemRemoved].previousNPC = SGT.History[guildName][displayName][ShissuGT.ZOS.ItemRemoved].currentNPC
            SGT.History[guildName][displayName][ShissuGT.ZOS.ItemRemoved].currentNPC = 0 
          end
        end
      end
    end
  end
end

-- Events auslesen und Änderungen speichern / hinzufügen
function SGT.processEvents(guildId, category)
  local numEvents = GetNumGuildEvents(guildId, category)

  if (numEvents == 0) then return end
  
  local guildName = GetGuildName(guildId)
  local _, firstTime = GetGuildEventInfo(guildId, category, 1)
  local _, lastTime = GetGuildEventInfo(guildId, category, numEvents)
  local lastScan = SGT.History[GetGuildName(guildId)]["lastScan"][category]
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
  
  if SGT.History.NPC.currentTime ~= 0 then 
    if SGT.History.NPC.currentTime < currentKioskTime then
      SGT.History.NPC.previousTime = currentKioskTime -  - (604800)  
      SGT.History.NPC.currentTime = currentKioskTime
      
      SGT.copyCurrentDateToLast()
    end     
  else
    SGT.History.NPC.currentTime = currentKioskTime     
    SGT.History.NPC.previousTime = currentKioskTime - (604800)   
  end

  -- Event abarbeiten
  for eventId = first, last, inc do
    local eventType, eventTime, displayName, eventGold = GetGuildEventInfo(guildId, category, eventId)

    -- Existiert der Account in der Datenbank? Wenn nein, erstellen!
    if displayName ~= nil then
      SGT.createAccount(guildName, displayName)
       
      local timeStamp = GetTimeStamp() - eventTime
      local oldestEvent = SGT.previousTime(guildName, category)
  
      if timeStamp > 0 then
        -- TimeStamp vom ältesten Event speichern        
        if (oldestEvent == 0) or (oldestEvent > timeStamp) then
          SGT.History[guildName]["oldestEvent"][category] = timeStamp
        end
      end
  
      if (timeStamp > lastScan) or (lastScan == 0) then
      -- Mitglied - Wann eingeladen?
        if (category == ShissuGT.ZOS.History) then
          if (eventType == ShissuGT.ZOS.Joined) then
            SGT.History[guildName][displayName].timeJoined = timeStamp
          end
            
          SGT.History[guildName]["lastScan"][category] = timeStamp
        end
          
        -- Mitglied - Bankaktivitäten
        if (category == ShissuGT.ZOS.Bank) then
          if (eventType == ShissuGT.ZOS.GoldAdded) or (eventType == ShissuGT.ZOS.GoldRemoved) or (eventType == ShissuGT.ZOS.ItemAdded) or (eventType == ShissuGT.ZOS.ItemRemoved) then
            if (SGT.History[guildName][displayName][eventType].timeLast < timeStamp) and (math.abs(SGT.History[guildName][displayName][eventType].timeLast - timeStamp) > 2) then   
              SGT.History[guildName][displayName][eventType].total = SGT.History[guildName][displayName][eventType].total + eventGold
              SGT.History[guildName][displayName][eventType].last = eventGold 
              SGT.History[guildName][displayName][eventType].timeLast = timeStamp
  
              -- seit NPC
              if timeStamp > SGT.History["NPC"].currentTime then
                SGT.History[guildName][displayName][eventType].currentNPC = SGT.History[guildName][displayName][eventType].currentNPC + eventGold 
              end
              
              if timeStamp < SGT.History["NPC"].currentTime and timeStamp > SGT.History["NPC"].previousTime then
                SGT.History[guildName][displayName][eventType].previousNPC = SGT.History[guildName][displayName][eventType].previousNPC + eventGold 
              end            
  
              if (SGT.History[guildName][displayName][eventType].timeFirst == 0) then
                SGT.History[guildName][displayName][eventType].timeFirst = timeStamp
              end
            
            end
          end
  
          SGT.History[guildName]["lastScan"][category] = timeStamp
        end
      end  
    end
  end
end

function SGT.HistoryResponseReceived(eventCode, guildId, category)
  if (category ~= ShissuGT.ZOS.History) and (category ~= ShissuGT.ZOS.Bank) then return end
  
  SGT.createGuild(GetGuildName(guildId))
  
  local lastScan = SGT.History[GetGuildName(guildId)]["lastScan"][category]
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
    if SGT.guildId == GetNumGuilds() and SGT.firstGuildScan == true then
      SGT.firstGuildScan = false
        d(ShissuGT.ColoredName .. ": DONE")
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
  
  local guildName = GetGuildName(guildId)

  if (SGT.History[guildName] == nil) then
    d(ShissuGT.ColoredName .. ": " .. ShissuGT.i18n.History.scanner1 .. ": " .. guildName .. " " .. ShissuGT.i18n.History.scanner2)
                              
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

-- Start History Scanner
function ShissuGT.History.Scanner()
  shissuGT.History = shissuGT.History or {}
  SGT.History = shissuGT.History
  
  if SGT.History.NPC == nil then
    SGT.History.NPC = {}
    SGT.History.NPC.currentTime = 0
    SGT.History.NPC.previousTime = 0    
  end

  zo_callLater(SGT.availableGuild, 1000)
end