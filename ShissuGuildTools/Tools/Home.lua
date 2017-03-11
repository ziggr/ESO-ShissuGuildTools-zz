-- File: Home.lua
-- Zuletzt geändert: 12. August 2015

local SGT_Home = {
  kioskTimer = 0
}

function ShissuGT.Lib.GetNextKioskTime(previous)
  local server = GetCVar("LastRealm")
  
  -- Händlervergabe NA: Montag 13:55 statt Dienstag 03:55
  local NAFix = 0
  
  if string.find(server, "EU") then 
    server = "EU"
  else 
    server = "NA" 
    NAFix = 86400 - 3600
  end

  local kioskExchange = {
    -- 03:55 (Dienstag)
    EU = 14100,
    -- 13:55 (Montag)
    NA = 50100, 
  }
  
  local secsSinceThu = 
  {
    -- Anzahl der Sekunden seit DI, Zeit bis zum nächsten Händler (ab 0:00)
    FR = { 86400,  (5*86400) + kioskExchange[server] },
    SA = { 169200, (4*86400) + kioskExchange[server] },
    SO = { 255600, (3*86400) + kioskExchange[server] },
    MO = { 342000, (2*86400) + kioskExchange[server] },
    DI = { 428400, (1*86400) + kioskExchange[server] },
    MI = { 514800, (7*86400) + kioskExchange[server] },
    DO = { 604800, (6*86400) + kioskExchange[server] },
  }  
   
  -- Zeit seit dem vorherigen/letzten Händler (ab 0:00)
  if previous == true then
    secsSinceThu.FR[2] = -((2*86400) - kioskExchange[server])
    secsSinceThu.SA[2] = -((3*86400) - kioskExchange[server])
    secsSinceThu.SO[2] = -((4*86400) - kioskExchange[server])
    secsSinceThu.MO[2] = -((5*86400) - kioskExchange[server])
    secsSinceThu.DI[2] = -((6*86400) - kioskExchange[server])
    secsSinceThu.MI[2] = -((1*86400) - kioskExchange[server])
    secsSinceThu.DO[2] = -((0*86400) - kioskExchange[server])
  end
  
  -- Zeitzone Deutschland: UTC+2
  local UTC2 = ShissuGT.Settings.UTC * 3600
       
  local currentTime = GetTimeStamp()

  -- Anzahl der Wochen seit 01.01.1970
  local weeks = math.floor(currentTime / secsSinceThu.DO[1])

  -- Beginn der aktuellen Woche
  local beginnWeek = weeks * secsSinceThu.DO[1]

  -- Restliche Zeit in der Woche
  local restWeekTime = currentTime - beginnWeek

  -- Anzahl der Tage seitdem 01.01.1970
  local days = math.floor(currentTime / secsSinceThu.FR[1])
  
  -- Beginn des aktuelles Tages xx.xx.xxxx 00:00
  local beginnDay = days * secsSinceThu.FR[1]
  
  -- Wieviel Zeit ist seit Tagesbeginn vergangen?
  local sinceBeginnDay = currentTime - beginnDay
  
  local timeStampNextKiosk = 0

  -- Welcher Wochentag?
  -- Donnerstag
  if (restWeekTime > 0 and restWeekTime < secsSinceThu.FR[1]) then timeStampNextKiosk = currentTime + secsSinceThu.FR[2] - sinceBeginnDay
  -- Freitag  
  elseif (restWeekTime > secsSinceThu.FR[1] and restWeekTime < secsSinceThu.SA[1]) then timeStampNextKiosk = currentTime + secsSinceThu.SA[2] - sinceBeginnDay
  -- Samstag
  elseif (restWeekTime > secsSinceThu.SA[1] and restWeekTime < secsSinceThu.SO[1]) then timeStampNextKiosk = currentTime + secsSinceThu.SO[2] - sinceBeginnDay
  -- Sonntag
  elseif (restWeekTime > secsSinceThu.SO[1] and restWeekTime < secsSinceThu.MO[1]) then timeStampNextKiosk = currentTime + secsSinceThu.MO[2] - sinceBeginnDay
  -- Montag
  elseif (restWeekTime > secsSinceThu.MO[1] and restWeekTime < secsSinceThu.DI[1]) then timeStampNextKiosk = currentTime + secsSinceThu.DI[2] - sinceBeginnDay
  -- Dienstag
  elseif (restWeekTime > secsSinceThu.DI[1] and restWeekTime < secsSinceThu.MI[1]) then timeStampNextKiosk = currentTime + secsSinceThu.MI[2] - sinceBeginnDay
  -- Mittwoch
  elseif (restWeekTime > secsSinceThu.MI[1] and restWeekTime < secsSinceThu.DO[1]) then timeStampNextKiosk = currentTime + secsSinceThu.DO[2] - sinceBeginnDay end  

  return (timeStampNextKiosk - NAFix) - currentTime - UTC2
end

function ShissuGT.Misc.KioskTimer()
  if SGT_Home.kioskTimer == 1 then return false end
  
  SGT_Home.kioskTimer = 1
        
  -- Fensterelement
  SGT_Home.time = CreateControlFromVirtual("SGT_HomeTimer", ZO_GuildHome, "ZO_DefaultTextButton")
  SGT_Home.time:SetAnchor(TOPLEFT, ZO_GuildHome, TOPLEFT, 32, 520)
  SGT_Home.time:SetWidth(180)
  SGT_Home.time:SetHidden(false)  
  SGT_Home.time:SetHandler("OnMouseEnter", function(self)
    ShissuGT.Lib.ToolTip(self, ShissuGT.Lib.SecsToTime(ShissuGT.Lib.GetNextKioskTime(), true))
  end)
  SGT_Home.time:SetHandler("OnMouseExit", function(self)
    ZO_Tooltips_HideTextTooltip()
  end)  
  -- Timer!
  SGT_Home.KioskUpdateTimer(1000) 
end

-- Gildenfenster, UPDATE EVENT
function SGT_Home.KioskUpdateTimer(time)
  EVENT_MANAGER:UnregisterForUpdate("ShissuGT_KioskTimer")  
  
  EVENT_MANAGER:RegisterForUpdate("ShissuGT_KioskTimer", time, function()
    local leftTime = ShissuGT.Lib.SecsToTime(ShissuGT.Lib.GetNextKioskTime())
    SGT_Home.time:SetText("|t36:36:EsoUI/Art/Guild/ownership_icon_guildtrader.dds|t" .. ShissuGT.Color[6]..ShissuGT.i18n.RestTime  ..": " .. ShissuGT.Color[5].. leftTime)

   if string.find(leftTime,"min") and time ~= 1000 and not string.find(leftTime,"h")  then 
      SGT_Home.KioskUpdateTimer(1000)
    elseif string.find(leftTime,"h") and time ~= 30*60*1000 and not string.find(leftTime,"min") then 
      SGT_Home.KioskUpdateTimer(30*60*1000) 
    end
  end)
end