-- File: SlashCommand.lua
-- Zuletzt geändert: 16. Januar 2015

-- LOCALS
local SGT = {}

-- FUNCTIONS
-- Charakter aus der Charakterdatenbank entfernen, bzw. Liste vollständig leeren
function ShissuGT.RemoveChar(accName)
  d(accName)
  if accName ~= nil then
    if shissuGT.MemberChars[accName] then 
      shissuGT.MemberChars[accName] = {}
      d(ShissuGT.ColoredName .. ": " .. ShissuGT.Lib.ReplaceCharacter(string.gsub(ShissuGT.i18n.SlashCommand.RemoveChar1, "<<1>>", accName)))  
    elseif accName == "reset" then
      d(ShissuGT.ColoredName .. ": " .. ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.SlashCommand.RemoveChar3))
      shissuGT.MemberChars = {}
    else
      d(ShissuGT.ColoredName .. ": " .. ShissuGT.Lib.ReplaceCharacter(string.gsub(ShissuGT.i18n.SlashCommand.RemoveChar2, "<<1>>", accName)))      
    end
  end
end

-- Allgemeine Funktion zur Verarbeitung der Chatbefehle
function SGT.SlashCommand(text)
  if (ShissuGT.Lib.IsStringEmpty(text)) then SGT.SlashCommandHelp() return true end

  -- Spielerstatus
  if text == "online" or text == "on" then SelectPlayerStatus(PLAYER_STATUS_ONLINE) end
  if text == "afk" then SelectPlayerStatus(PLAYER_STATUS_AWAY) end
  if text == "brb" or text == "dnd" then SelectPlayerStatus(PLAYER_STATUS_DO_NOT_DISTURB) end
  if text == "offline" or "off" then SelectPlayerStatus(PLAYER_STATUS_OFFLINE) end

  if text == "hall" then  ShissuGT.Misc.OpenAllPages() return end

  -- Zufallszahlen z.B. für die Gildenlotterie
  local rollCommand = string.lower(string.sub(text,1,4))
  
  if rollCommand == "roll" or rollCommand == "dice" then
    local number = tonumber(string.sub(text,5))
    SGT.RandomRoll(number)
    return true
  end

  -- Charakterdatenbank RESET
  local charCommand = string.lower(string.sub(text,1,4))

  if charCommand == "char" then
    local resetAcc = string.sub(text,6)
    
    if ShissuGT.Lib.IsStringEmpty(resetAcc) then return false end
    
    local dialogTitle = "Reset?"
    local dialogText = ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.SlashCommand.RemoveChar4)
    if resetAcc ~= "reset" then dialogText = ShissuGT.Lib.ReplaceCharacter(string.gsub(ShissuGT.i18n.SlashCommand.RemoveChar1N, "<<1>>", resetAcc)) end

    ShissuGT.Lib.ShowDialog(dialogTitle, dialogText, function(dialog) ShissuGT.RemoveChar(dialog.data.accName) end, {accName = resetAcc})
    return true
  end

  -- Fenster Notizbuch, Teleporter, Zufallsteleporter, Notizen posten
  local noteCommand = string.sub(text,1,2) 
  
  if text ==  "tele" then ShissuGT.Teleport.Toggle()
  elseif text == "rnd" then ShissuGT.RandomTeleporter() 
  elseif text == "note" and ShissuGT.Settings.Notebook.Enabled == true then ShissuGT.Notebook.Toggle() 
  elseif noteCommand == "n:" and ShissuGT.Settings.Notebook.Enabled  == true then
    local numPages = #shissuGT.Notes
    local note = string.sub(text,3,string.len(text)) 
    
    for i = 1, numPages do
      if shissuGT.Notes[i].command == note then
        CHAT_SYSTEM:StartTextEntry(shissuGT.Notes[i].text)
        return true
      end 
    end
  end 
  
  SGT.SlashCommandHelp()
end

function SGT.GuildInvite(guildId, name)
  guildId = tonumber(guildId)
  
  if guildId == nil or name == nil then return false end

  if DoesPlayerHaveGuildPermission(guildId, GUILD_PERMISSION_INVITE) then
    GuildInvite(guildId, name) 
  end 
end

function SGT.PortToPlayer(name)
  if name == nil then return false end

  JumpToGuildMember(name) 
end

-- Textausgabe Zufallszahl in den Chat
function SGT.RandomRoll(number)
  if (ShissuGT.Lib.IsStringEmpty(number)) then return false end
  
  local textLang = string.sub(number, string.len(number)-2, string.len(number))
  local textLang2 = "RollChat" .. textLang
  textLang2 = string.gsub(textLang2, " ", "")

  local settingLang = "RollChat" .. GetCVar("Language.2")
  
  if textLang2 ~= nil then
    if ShissuGT.i18n[textLang2] ~= nil then
      settingLang = textLang2
      number = string.gsub(number, "" .. textLang, "")
    end
  end
    
  local max = tonumber(number)

  if max ~= nil then 
    local random = math.random(max)
    local text = string.gsub (ShissuGT.i18n[settingLang] , "MAX" , max)
    text = ShissuGT.Lib.ReplaceCharacter(string.gsub (text , "RND", random))
            
    CHAT_SYSTEM:StartTextEntry(GetUnitName("player") .. text)
  end
end

-- Ausgabe eines Infotextes über die verfügbaren Befehle im Chat
function SGT.SlashCommandHelp()
  commandHelp = ShissuGT.ColoredName .. ShissuGT.i18n.SlashCommand.Help 
  commandHelp = string.gsub (commandHelp , "<<1>>" , ShissuGT.Color[6]) 
  commandHelp = string.gsub (commandHelp , "<<2>>" , ShissuGT.Color[5]) 
 
  d(ShissuGT.Lib.ReplaceCharacter(commandHelp))
end

-- Chatbefehle initializieren                                             
function ShissuGT.SlashCommand()
  SLASH_COMMANDS["/sgt"] = SGT.SlashCommand

  -- Chatbefehle ohne ein /sgt-Kürzel
  -- Textausgabe Zufallszahl  
  SLASH_COMMANDS["/roll"] = SGT.RandomRoll
  SLASH_COMMANDS["/dice"] = SGT.RandomRoll
  SLASH_COMMANDS["/ginv"] = SGT.GuildInvite
  SLASH_COMMANDS["/teleport"] = SGT.PortToPlayer
  
  -- Spielerstatuswechsel     
  SLASH_COMMANDS["/dnd"] = function() SelectPlayerStatus(PLAYER_STATUS_DO_NOT_DISTURB) end 
  SLASH_COMMANDS["/brb"] = function() SelectPlayerStatus(PLAYER_STATUS_DO_NOT_DISTURB) end 
  SLASH_COMMANDS["/afk"] = function() SelectPlayerStatus(PLAYER_STATUS_AWAY) end
  SLASH_COMMANDS["/on"]  = function() SelectPlayerStatus(PLAYER_STATUS_ONLINE) end
  SLASH_COMMANDS["/online"] = function() SelectPlayerStatus(PLAYER_STATUS_ONLINE) end
  SLASH_COMMANDS["/off"] = function() SelectPlayerStatus(PLAYER_STATUS_OFFLINE) end
  SLASH_COMMANDS["/offline"] = function() SelectPlayerStatus(PLAYER_STATUS_OFFLINE) end
  SLASH_COMMANDS["/rl"] = function() SLASH_COMMANDS["/reloadui"]() end
end
