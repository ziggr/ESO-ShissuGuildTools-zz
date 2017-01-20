-- File: Chat.lua
-- Zuletzt geändert: 18. Januar 2015

-- LOCALS
local SGT = {}

-- FUNCTIONS
function ShissuGT.Chat.NotePost(channelString, text)
  local notesData = shissuGT.Notes
  
  if notesData == nil then return false end
  for index, data in pairs(notesData) do
    if not ShissuGT.Lib.IsStringEmpty(data.autopost) and not ShissuGT.Lib.IsStringEmpty(data.autostring) then
      if data.autopost then        
        -- Mehrere getrennte Wörter in den jeweiligen Strings
        if string.find (data.autostring, " ") or string.find (text, " ")  then
          for singleString in string.gmatch(data.autostring, "%a+") do 
            for singleString2 in string.gmatch(text, "%a+") do 
              if string.lower(singleString) == string.lower(singleString2) then
                ShissuGT.Lib.TextToChat(channelString .. "")
                ShissuGT.Lib.TextToChat(data.text)
                return true
              end
            end
          end
        else
          -- Einzelnes AutoPOST Objekt
          if string.lower(text) == string.lower(data.autostring) then  
            ShissuGT.Lib.TextToChat(channelString .. "")
            ShissuGT.Lib.TextToChat(data.text)
            return true
          end
        end              
      end
    end
  end
  
  return false
end

-- AutoSwitch/Post
function ShissuGT.Chat.Auto(channelString, text, fromName, guildId)
  if channelString == nil then return false end
  
  local CurrentText = CHAT_SYSTEM.textEntry:GetText()
   
  -- Nur den Chat wechseln, bzw. die AUTOPost Nachricht niederschreiben, wenn die Chatbox leer ist
  if string.len(CurrentText) < 1 then
    fromName = ShissuGT.Lib.CutStringAtLetter(fromName, "^")
    
    -- Flüstern
    if (string.find(channelString, "tell") and (ShissuGT.Settings.Chat.AutoChat.Tell)) or
      (string.find(channelString, "tell") and (ShissuGT.Settings.Chat.AutoSwitch.Tell)) then  
      if string.find(fromName, "@") then
        if ShissuGT.Chat.NotePost(channelString .. fromName .. " ", text) then return end
        if ShissuGT.Settings.Chat.AutoSwitch.Tell then ShissuGT.Lib.TextToChat(channelString .. fromName .. " ") end
      end
    -- Gruppe
    elseif (string.find(channelString, "party") and (ShissuGT.Settings.Chat.AutoSwitch.Group)) or 
      (string.find(channelString, "party") and (ShissuGT.Settings.Chat.AutoChat.Group)) then
      
      if ShissuGT.Chat.NotePost(channelString, text) then return end
      if ShissuGT.Settings.Chat.AutoSwitch.Group then ShissuGT.Lib.TextToChat(channelString .. "") end      
    --Gilde
    elseif (guildId ~= 0 and string.find(channelString, "guild")) then
      if ShissuGT.Settings.Chat.AutoChat["Guild"..guildId] then 
        if ShissuGT.Chat.NotePost(channelString, text) then return end
      end
      if ShissuGT.Settings.Chat.AutoSwitch["Guild"..guildId] then ShissuGT.Lib.TextToChat(channelString .. "") end
    end     
  end
end

-- Neuen Chat LinkHandler String basteln
function SGT.NewChatString(guildId, fromName, charInfo) 
  local allianceSymbol = ""
  local charName = "" --ShissuGT.Lib.CutStringAtLetter(charInfo[2],"^")
  local charLvL = "" --charInfo[6]
  local newfromName = string.gsub(fromName, "@", "")

  -- Allianzsymbol
  if (ShissuGT.Settings["Guild" .. guildId].Alliance == true) then 
    local charAlliance = charInfo[5]
    allianceSymbol = zo_iconFormat(GetAllianceBannerIcon(charAlliance), 24, 24)
  end
  
  -- Charaktername einfärben
  local charColor = "|ceeeeee"
              
  if ShissuGT.Settings.Color.Character then
    if ShissuGT.Settings.Color.Character[1] and ShissuGT.Settings.Color.Character[2] and ShissuGT.Settings.Color.Character[3] then
      charColor = "|c" .. ShissuGT.Lib.RGBtoHex(ShissuGT.Settings.Color.Character[1], ShissuGT.Settings.Color.Character[2],ShissuGT.Settings.Color.Character[3])
    end
  end          
                       
  -- Levelangaben
  if (ShissuGT.Settings["Guild" .. guildId].Level == true) then    
    charLvL = charInfo[6]
    if charLvL == 50 and charInfo[7] > 0 then charLvL = "V" .. charInfo[7] end    
    charLvL = " [" .. charLvL .. "]"
  end

  -- Charakternames
  if (ShissuGT.Settings["Guild" .. guildId].Character == true) then 
    charName = ShissuGT.Lib.CutStringAtLetter(charInfo[2],"^") 
    charName = string.format("|H1:character:%s|h%s|h", charName, ShissuGT.Lib.CutStringAtLetter(charInfo[2],"^"))
  end 
  
  local displayName = string.format("|H1:display:%s|h%s|h", fromName, newfromName)
  
  return allianceSymbol .. charColor .. charName .. "|r@" .. displayName ..  charLvL
end

-- Chat: Gilde /& Flüstern
function SGT.ManipulateChat(fromName, channelString)
  --if (not string.find(channelString, "tell") and not string.find(channelString, "guild")) then return false end 

  local guildId = SGT.GetGuildId(channelString)
  
  if (string.find(channelString, "guild")) and (guildId == nil) then
    return false
  end
  
  if (string.find(channelString, "tell")) and (ShissuGT.Settings.Chat.WhisperChat == true) then 
    for guildId = 1, GetNumGuilds() do
      if SGT.ManipulateChat2 (guildId, fromName) then return SGT.ManipulateChat2 (guildId, fromName) end
    end
    
    return false    
  end
  
  if ( string.find(channelString, "guild") )then 
    if not (ShissuGT.Settings["Guild" .. guildId].Alliance) and 
      not (ShissuGT.Settings["Guild" .. guildId].Level) and 
      not (ShissuGT.Settings["Guild" .. guildId].Character) then return false end 
      
    return SGT.ManipulateChat2 (guildId, fromName)
  end
  
  -- Separate Schalter
  if ( string.find(channelString, "zone") or string.find(channelString, "yell") ) then
    for guildId = 1, GetNumGuilds() do
      if SGT.ManipulateChat2 (guildId, fromName) then return SGT.ManipulateChat2 (guildId, fromName) end
    end
  end
   
  return false  
end

function SGT.ManipulateChat2(guildId, fromName)
  for memberId=1, GetNumGuildMembers(guildId), 1 do
    local accInfo = { GetGuildMemberInfo(guildId, memberId) }   
      
    if accInfo[1] == fromName then
      local charInfo = { GetGuildMemberCharacterInfo(guildId, memberId) }
      return SGT.NewChatString(guildId, fromName, charInfo)  
    end 
  end
end

function SGT.GetGuildName(fromName)
  if ShissuGT.Settings.GuildNameChat == false then return "" end
  
  for guildId=1, GetNumGuilds() do
    for memberId=1, GetNumGuildMembers(guildId), 1 do
      local accInfo = {GetGuildMemberInfo(guildId, memberId)}
      local charInfo = {GetGuildMemberCharacterInfo(guildId, memberId)}

      if accInfo[1] == fromName or charInfo[2] == fromName then
        local charInfo = {GetGuildMemberCharacterInfo(guildId, memberId)}
        return "[" ..GetGuildName(guildId) ..  "]"  
      end
    end
  end
  
  return ""
end

function SGT.GetRankIndex(guildId)
  if ShissuGT.Settings["Guild"..guildId].LeadRank == nil then return end

  for rankIndex=1, GetNumGuildRanks(guildId) do
    if ShissuGT.Settings["Guild"..guildId].LeadRank == GetGuildRankCustomName(guildId, rankIndex) then
      return rankIndex
    end  
  end
    
  return 1
end

-- Gildenleiter, Gildenoffizier?
function SGT.IsGuildLead(fromName, guildId)
  -- if (string.find(channelString, "zone")) then return false end 

  local accName = 1
  local rankIndex
  
  if (not string.find(fromName, "@")) then accName = 0 end
  
  if guildId ~= nil then 
    rankIndex = SGT.GetRankIndex(guildId) 
    if SGT.GetPlayerIcon(fromName, guildId, rankIndex, accName) then return SGT.GetPlayerIcon(fromName, guildId, rankIndex, accName) end
  else
    for guildId=1,GetNumGuilds() do
      rankIndex = SGT.GetRankIndex(guildId)
      if SGT.GetPlayerIcon(fromName, guildId, rankIndex, accName) then return SGT.GetPlayerIcon(fromName, guildId, rankIndex, accName) end
    end
  end

  return false
end

function SGT.GetPlayerIcon(fromName, guildId, rankIndex, accName)
  if ShissuGT.Settings["Guild"..guildId].ChatLead then
    for memberIndex=1, GetNumGuildMembers(guildId), 1 do
      local accInfo = {GetGuildMemberInfo(guildId, memberIndex)}
      local icon = GetGuildRankSmallIcon(GetGuildRankIconIndex(guildId, accInfo[3]))
        
      if accInfo[3] <= rankIndex then
        if accName == 1 and accInfo[1] == fromName then 
          return "|t24:24:" .. icon .. "|t "
        else
          local charInfo = {GetGuildMemberCharacterInfo(guildId, memberIndex)}
          if charInfo[2] == fromName then return "|t24:24:" .. icon .. "|t "  end
        end
      end
    end
  end
  
  return false
end

-- Gildenindex auslesen
function SGT.GetGuildId(channelString)
  if channelString == nil then return 0 end
  local guildId = string.gsub (channelString, "/guild" , "")
  guildId = string.gsub(guildId , " " , "")
  guildId = tonumber(guildId)

  if guildId then return guildId end
  return 0      
end

-- Uhrzeit im Chat, und weitere Informationen für die anderen Tools abfangen
function SGT.formatMessage(chanCode, from, text, isFromCustomerService, originalFrom, originalText, DDSBeforeAll, TextBeforeAll, DDSBeforeSender, TextBeforeSender, TextAfterSender, DDSAfterSender, DDSBeforeText, TextBeforeText, TextAfterText, DDSAfterText)
  local channelInfo = ZO_ChatSystem_GetChannelInfo()[chanCode]

  if not channelInfo or not channelInfo.format then return end
 
  local customerIcon = ""
  local chatTime = ""
  local guildName = SGT.GetGuildName(from)
  local fromLink = ShissuGT.Lib.CutStringAtLetter(from, "^")
  local channelLink = ""

  -- KrimsKrams von anderen AddOns
  local message = DDSBeforeAll .. TextBeforeAll
  fromLink = DDSBeforeSender .. TextBeforeSender .. fromLink .. TextAfterSender .. DDSAfterSender  
  text = DDSBeforeText .. TextBeforeText .. text .. TextAfterText .. DDSAfterText

  -- CustomIcon (Gildenoffizier/Lead); Channel; From; Text
  local standardString = "%s%s %s%s: %s"
  
  -- CustomIcon; From; Text;
  local standardString2 = "%s %s%s: %s"
  
  -- Uhrzeit
  if ShissuGT.Settings.TimeInChat then chatTime = ShissuGT.Lib.GetTime() end

  -- Chatchannel: Link & Kontextmenü      
  local channelName = GetChannelName(channelInfo.id)
  
  if channelInfo.channelLinkable and channelName then
    channelLink = ZO_LinkHandler_CreateChannelLink(channelName)
  elseif channelName then
    channelLink = "[" .. channelName .. "]"
  end
  
  if (chanCode >= CHAT_CHANNEL_GUILD_1 and chanCode <= CHAT_CHANNEL_GUILD_5) then
    guildName = ""
  end

  -- Soundausgabe, beim Flüstern
  if chanCode == CHAT_CHANNEL_WHISPER and ShissuGT.Settings.WhisperSound then
    PlaySound(ShissuGT.Settings.WhisperSound)
  end
    
  -- Customer, GM Support
  if isFromCustomerService then customerIcon = "|t16:16:EsoUI/Art/ChatWindow/csIcon.dds|t" end
 
  -- Spieler: Link & Kontextmenü
  if channelInfo.playerLinkable then fromLink = ZO_LinkHandler_CreatePlayerLink(fromLink) end

  if (not ShissuGT.Lib.IsStringEmpty(channelInfo.switches)) then
    local channelString = string.sub(channelInfo.switches, 1, string.find (channelInfo.switches, " ")) 
    
    -- AutoSwitch/Post
    ShissuGT.Chat.Auto(channelString, text, from, SGT.GetGuildId(channelString))
    
    -- Gildenoffizier? Gildenleiter?
    local guildId = nil
    
    if string.find(channelString, "guild") then
      guildId = string.gsub(channelString, "/guild", " ")
      guildId = tonumber(guildId)
    end
    
    if SGT.IsGuildLead(from, guildId) then customerIcon = SGT.IsGuildLead(from, guildId) end
    if SGT.ManipulateChat(from, channelString) then fromLink = SGT.ManipulateChat(from, channelString) end    
  end   
  
  -- Channels with links will not have CS messages
  if channelLink then
    message = chatTime .. message .. string.format(standardString, customerIcon, channelLink, guildName, fromLink, text) 
  else
    --d(fromLink)
    message = chatTime .. message .. string.format(standardString2, customerIcon, guildName, fromLink, text)
  end
  
  return message
end

function ShissuGT.Chat.Initialize()
  local libChat = LibStub('libChat-1.0')
  
  libChat:registerFormat(SGT.formatMessage, "00A" .. ShissuGT.Name)
end