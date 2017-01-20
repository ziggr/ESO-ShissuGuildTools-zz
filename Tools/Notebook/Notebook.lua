-- File: Notebook.lua
-- Zuletzt geändert: 28. Januar 2015

local SGT = {}

-- NOTEBOOKS LOCALS
SGT.Data = nil
SGT.scrollItem = 1
SGT.indexPool = nil
SGT.list = nil
SGT.lastFocus = nil
SGT.currentID = nil
SGT.autoPost = false
SGT.cache = {}

-- MAIL LOCALS
SGT.emailCache = {}
SGT.dropDownGuilds = nil
SGT.dropDownRanks = nil
SGT.offlineSince = 0
SGT.currentGuild = 1
SGT.currentRank = 0
SGT.guildList = {}
SGT.currentList = {}
SGT.scrollMailItem = 1
SGT.mailIndexPool = nil
SGT.mailList = nil
SGT.mailKickChoice = 1
SGT.protocolFullIndexPool = nil
SGT.protocolIgnoreIndexPool = nil
SGT.emailIsSend = false
SGT.emailIsOpen = false
SGT.emailKick = nil
SGT.emailAll = nil
SGT.clickChoice = nil
SGT.clickIndex = nil

SGT.recipientName = ""
SGT.RecipientChoice = {
  Online = true,
  Offline = true,
  Aldmeri = true,
  Ebonheart = true,
  Daggerfall = true,
}   
SGT.Item = {
  Full = 1,
  Ignore = 1,
}
  
SGT.customList = nil 
  
SGT.ProtocolList = {
  Full = nil,
  Ignore = nil,
}    

SGT.emailError = {
   full = {},
   ignore = {},
}    

-- SCROLL Container Funktionen
-- Einzelne Listen Einträge erstellen
function SGT.createIndexButton(indexPool)
  local control = ZO_ObjectPool_CreateControl("SGT_Notebook_Index", indexPool, SGT.list.scrollChild)
  local anchorBtn = SGT.scrollItem == 1 and SGT.list.scrollChild or indexPool:AcquireObject(SGT.scrollItem-1)
  
  control:SetAnchor(TOPLEFT, anchorBtn, SGT.scrollItem == 1 and TOPLEFT or BOTTOMLEFT)
  control:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  control:SetWidth(180)
  control:SetHandler("OnMouseUp", function(self, button)
    SGT.selected:SetHidden(false)
    SGT.selected:ClearAnchors()
    SGT.selected:SetAnchorFill(self)      
    SGT.currentID = self.ID

    SGT_Notebook_NoteTitleText:SetText(self.noteTitle) 
    SGT_Notebook_NoteText:SetText(self.text)
    SGT_Notebook_SlashText:SetText(self.command) 
    SGT_Notebook_AutoStringText:SetText(self.autoString)
    
    if self.autopost then ZO_CheckButton_SetChecked(SGT_Notebook_AutoStringEnabled)
    else ZO_CheckButton_SetUnchecked(SGT_Notebook_AutoStringEnabled) end

    -- Rückgängig machen - Cache
    SGT.cache.title = self.noteTitle
    SGT.cache.text = self.text
    SGT.cache.autoString = self.autoString
    SGT.cache.autoPost = SGT.autoPost
    SGT.cache.command = SGT.command
    
    if button == 2 then
      SGT.NoteDelete()
    end
  end)
  
  control:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, ShissuGT.Color[5] .. self.noteTitle) end)
  control:SetHandler("OnMouseExit", function(self) ZO_Tooltips_HideTextTooltip() end)  

  SGT.scrollItem = SGT.scrollItem  + 1
  
  return control
end

-- Einzelne Listen Eintrag entfernen (verstecken)
function SGT.removeIndexButton(control)
  control:SetHidden(true)
end

-- Liste füllen
function SGT.FillScrollList()
  local numPages = #SGT.Data
  local sortedTitle = {}
  local sortedData = {}
  
  for i = 1, numPages do
    table.insert(sortedTitle, i, SGT.Data[i].title .. "**shissu" ..i)
  end
  
  table.sort(sortedTitle)
  
  for i = 1, numPages do
    local length = string.len(sortedTitle[i])
    local number = string.sub(sortedTitle[i], string.find(sortedTitle[i], "**shissu"), length)
    
    number = string.gsub(number, "**shissu", "")
    number = string.gsub(number, " ", "")
    number = tonumber(number)

    sortedData[i] = {}
    sortedData[i].title = SGT.Data[number].title
    sortedData[i].text = SGT.Data[number].text
    sortedData[i].autoString = SGT.Data[number].autostring
    sortedData[i].autoPost = SGT.Data[number].autopost
    sortedData[i].command = SGT.Data[number].command
    sortedData[i].number = number
  end

  for i = 1, numPages do
    local control = SGT.indexPool:AcquireObject(i)
    control.noteTitle = sortedData[i].title
    control.text = sortedData[i].text
    control.ID = sortedData[i].number
    control.autoString = sortedData[i].autoString
    control.autoPost = sortedData[i].autoPost
    control.command = sortedData[i].command
    control:SetText(ShissuGT.Color[5] .. sortedData[i].title)
    control:SetHidden(false)
  end
  
  local activePages = SGT.indexPool:GetActiveObjectCount()
  if activePages > numPages then
    for i = numPages+1, activePages do SGT.indexPool:ReleaseObject(i) end
  end
end

function SGT.SlashOnTextChanged()
  local userSlash = SGT_Notebook_SlashText:GetText()
                    
  if ShissuGT.Lib.IsStringEmpty(userSlash) then 
    userSlash = ""
    SGT_Notebook_UserSlash:SetHidden(true)
  else
    SGT_Notebook_UserSlash:SetHidden(false) 
  end
    
  SGT_Notebook_UserSlash:SetText(ShissuGT.i18n.Notebook.ChatCommand .. userSlash .. "|r")
end

-- UI ELEMENTE
-- Create UI
function SGT.NoteUIElements()
  -- UI Elemente
  ZO_ChatWindowOptions:SetAnchor(TOPRIGHT, ZO_ChatWindow, TOPRIGHT, -50, 6 )
  SGT_ZO_ToogleButton:SetParent(ZO_ChatWindowOptions:GetParent() )
  
  -- Allgemeine Formatierungen
  SGT_Notebook_NoteText:SetMaxInputChars(1024)
  SGT_Notebook_SlashText:SetMaxInputChars(24)
  SGT_Notebook_SlashInfo:SetText(ShissuGT.i18n.Notebook.SlashCommand)
  SGT_Notebook_UserSlash:SetText(ShissuGT.i18n.Notebook.ChatCommand)  
  SGT_Notebook_Color1:SetText(ShissuGT.userColor[1] .. "1")
  SGT_Notebook_Color2:SetText(ShissuGT.userColor[2] .. "2")
  SGT_Notebook_Color3:SetText(ShissuGT.userColor[3].. "3")
  SGT_Notebook_Color4:SetText(ShissuGT.userColor[4] .. "4")
  SGT_Notebook_ColorW:SetText(ShissuGT.Color[5] .. "W")
  SGT_Notebook_ColorANY:SetText(ShissuGT.Color[5] .. "ANY") 
  
  ShissuGT.Lib.SetSGTTitle(SGT_Notebook_Title, ShissuGT.i18n.Notebook.Title)
  ShissuGT.Lib.SetVersionUI(SGT_Notebook_Version)
  ShissuGT.Lib.SetStdColor(SGT_Notebook_Line)
  
  -- Handler
  SGT_Notebook_NoteText:SetHandler("OnFocusGained", function(self) SGT.lastFocus = self end)
  SGT_Notebook_NoteTitleText:SetHandler("OnFocusGained", function(self) SGT.lastFocus = self end)
  SGT_Notebook_NoteText:SetHandler("OnTextChanged", SGT.NoteOnTextChanged)
  SGT_Notebook_New:SetHandler("OnClicked", SGT.NoteNew)
  SGT_Notebook_Delete:SetHandler("OnClicked", SGT.NoteDelete)
  SGT_Notebook_SendTo:SetHandler("OnMouseUp", SGT.SendTo)  
  SGT_Notebook_Undo:SetHandler("OnMouseUp", SGT.Undo) 
  SGT_Notebook_SlashText:SetHandler("OnEnter", function(self) self:LoseFocus() SGT.NoteSave() end)     
  SGT_Notebook_SlashText:SetHandler("OnTextChanged", SGT.SlashOnTextChanged)
     
  SGT.divider = ShissuGT.Lib.CreateBlueLine("SGT_Notebook_Divider", SGT_Notebook, SGT_Notebook_Line, 200)
  SGT.closeButton = ShissuGT.Lib.CreateCloseButton("SGT_Notebook_Close", SGT_Notebook, SGT.Toogle)

  -- ScrollContainer + UI
  SGT.indexPool = ZO_ObjectPool:New(SGT.createIndexButton, SGT.removeIndexButton) 
  SGT.list = ShissuGT.Lib.CreateUIList("SGT_Notebook_List", 185, SGT_Notebook, SGT_Notebook_Line, 10, 10, -10)
  
  SGT.selected = WINDOW_MANAGER:CreateControl(nil, SGT.list.scrollChild, CT_TEXTURE)
  SGT.selected:SetTexture("EsoUI\\Art\\Buttons\\generic_highlight.dds")
  ShissuGT.Lib.SetStdColor(SGT.selected)  
  SGT.selected:SetHidden(true)
  
  SGT.setControlToolTip(SGT_Notebook_NoteTitleText)
  SGT.setControlToolTip(SGT_Notebook_NoteText)
  
  -- ChatController CheckBox
  ZO_CheckButton_SetLabelText(SGT_Notebook_AutoStringEnabled, ShissuGT.Color[5] .. "Auto Post")
  ZO_CheckButton_SetToggleFunction(SGT_Notebook_AutoStringEnabled, function(control, checked) SGT.autoPost = checked end)
end

function SGT.Toogle()
  if SGT_Notebook:IsHidden() then
    SGT_Notebook:SetHidden(false)
  else
    SGT_Notebook:SetHidden(true)
  end
end

function SGT.NoteOnTextChanged()
  local control = SGT_Notebook_NoteLength
  local length = string.len(SGT_Notebook_NoteText:GetText())

  if length > 700 then control:SetText(ShissuGT.i18n.Notebook.MessagesLength .. ShissuGT.Color[7] .. length .. "|r/700")
  elseif length > 400 then control:SetText(ShissuGT.i18n.Notebook.MessagesLength .. ShissuGT.Color[6] .. length .. "|r/700") 
  elseif length > 350 then control:SetText(ShissuGT.i18n.Notebook.ChatLength .. ShissuGT.Color[6] .. length .. "|r/350")
  else control:SetText(ShissuGT.i18n.Notebook.ChatLength .. length .. "/350")
  end
end

-- Neue Notizen anlegen
function SGT.NoteNew() 
  SGT.ClearAllElements()
  SGT.cache.title = nil
  SGT.currentID = nil
  
  SGT_Notebook_NoteTitleText:SetText(":-)")
  SGT_Notebook_NoteTitleText:TakeFocus()
end  

-- Aktuelle Notiz löschen
function SGT.NoteDelete()
  if SGT.currentID ~= nil then
    ShissuGT.Lib.ShowDialog(ShissuGT.i18n.Notebook.ToolTipDelete, ShissuGT.i18n.Notebook.ConfirmNoteDelete, function()
      table.remove(SGT.Data, SGT.currentID)
      SGT.ClearAllElements()   
      SGT.FillScrollList()
    end, nil)
  end
end

function SGT.SendTo(self, button)
  if button == 1 then CHAT_SYSTEM:StartTextEntry(SGT_Notebook_NoteText:GetText()) 
  elseif button == 2 then SGT.NoteSave()
  elseif button == 3 then
    SCENE_MANAGER:Show('mailSend')
    ZO_MailSendBodyField:SetText(SGT_Notebook_NoteTitleText:GetText())
    ZO_MailSendSubjectField:SetText(SGT_Notebook_NoteText:GetText())
    ZO_MailSendBodyField:TakeFocus()  
  end
end

function SGT.NoteUndo()
  if SGT.cache.title ~= nil then
    SGT_Notebook_NoteTitleText:SetText(SGT.cache.title) 
    SGT_Notebook_NoteText:SetText(SGT.cache.text)
    SGT_Notebook_SlashText:SetText(SGT.cache.command) 
    SGT_Notebook_AutoStringText:SetText(SGT.cache.autoString) 
      
    if SGT.cache.autopost then ZO_CheckButton_SetChecked(SGT_Notebook_AutoStringEnabled)
    else ZO_CheckButton_SetUnchecked(SGT_Notebook_AutoStringEnabled) end
  end
end

function SGT.NoteSave()
  local noteTitle = SGT_Notebook_NoteTitleText:GetText()
  local noteText = SGT_Notebook_NoteText:GetText()
  local noteSlashCommand = SGT_Notebook_SlashText:GetText()
  local noteAutoPost = SGT_Notebook_AutoStringText:GetText()

  if SGT.currentID == nil then
    table.insert(SGT.Data, {["title"] = noteTitle, ["text"] = noteText, ["command"] = noteSlashCommand, ["autopost"]= SGT.autoPost, ["autostring"] = noteAutoPost})
    SGT.currentID = #SGT.Data
  else  
    SGT.Data[SGT.currentID].title = noteTitle
    SGT.Data[SGT.currentID].text = noteText
    SGT.Data[SGT.currentID].command = noteSlashCommand
    SGT.Data[SGT.currentID].autopost = SGT.autoPost
    SGT.Data[SGT.currentID].autostring = noteAutoPost 
  end
      
  SGT.FillScrollList()
end

function SGT.ClearAllElements()
  SGT_Notebook_NoteTitleText:Clear()
  SGT_Notebook_NoteText:Clear()
  SGT_Notebook_AutoStringText:Clear()
  SGT_Notebook_SlashText:Clear()
  ZO_CheckButton_SetUnchecked(SGT_Notebook_AutoStringEnabled)
end

function SGT.setControlToolTip(control)
  control:SetHandler("OnMouseEnter", function(self) 
    if control:GetText() ~= "" then ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, control:GetText()) end
  end)
  
  control:SetHandler("OnMouseExit", function(self) ZO_Tooltips_HideTextTooltip() end)
end

function SGT.setHandler(control, handler, func)
  control:SetHandler(handler, func)
end

function ShissuGT.Notebook.Color(color)
  local currentText = SGT.lastFocus:GetText()
  local addText = ""

  if color == "ANY" then
    EVENT_MANAGER:RegisterForUpdate("ShissuGT_COLORPICKER", 100, function()   
      if (ShissuGT.Lib.HexColor ~= nil) then 
        SGT.lastFocus:SetText(currentText.."|c" .. ShissuGT.Lib.HexColor .. "YOURTEXT|r")  
        ShissuGT.Lib.HexColor = nil
        EVENT_MANAGER:UnregisterForUpdate("ShissuGT_COLORPICKER")  
      end
    end)

    ShissuGT.Lib.ColorPicker() 
  else
    SGT.lastFocus:SetText(currentText .. ShissuGT.userColor[color] .. "YOURTEXT|r")
  end
end

-------------- EMAILS


function SGT.getGuildNote(memberId)
  local memberVar = {GetGuildMemberInfo(SGT.currentGuild, memberId)}
  
  if memberVar then
    return memberVar[2]
  end
  
  return false
end

function SGT.mailCreateIndexButton(indexPool)
  local control = ZO_ObjectPool_CreateControl("SGT_Notebook_MailIndex", indexPool, SGT.mailList.scrollChild)
  local anchorBtn = SGT.scrollMailItem == 1 and SGT.mailList.scrollChild or indexPool:AcquireObject(SGT.scrollMailItem-1)
  
  control:SetAnchor(TOPLEFT, anchorBtn, SGT.scrollMailItem == 1 and TOPLEFT or BOTTOMLEFT)
  control:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  control:SetWidth(140)
  control:SetHandler("OnMouseUp", function(self, button)
    if button == 2 then
      if SGT.guildList[self.index][2] == false then
        SGT.guildList[self.index] = {self.name, true} 
        control:SetText("|c333333" .. self.name)
      elseif SGT.guildList[self.index][2] == true then
        SGT.guildList[self.index] = {self.name, false}
        control:SetText(ShissuGT.Color[5] .. self.name)
      else
        SGT.guildList[self.index] = {self.name, true}
        control:SetText("|c333333" .. self.name)
      end
    else
      SGT_Notebook_MessagesRecipient_Choice:SetText(self.name)
      SGT.clickChoice = self.name
      SGT.clickIndex = self.index
    end
  end)
  
  control:SetHandler("OnMouseExit", function(self) ZO_Tooltips_HideTextTooltip() end) 
  control:SetHandler("OnMouseEnter", function(self) 
    if SGT.getGuildNote(self.id) and SGT.getGuildNote(self.id) ~= "" then
      ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, ShissuGT.Color[5] .. SGT.getGuildNote(self.id)) 
    end
  end)

  SGT.scrollMailItem = SGT.scrollMailItem  + 1
  
  return control
end

function SGT.buildGuildList()
  local numMembers = GetNumGuildMembers(SGT.currentGuild)
  local sortedMembers = {}
  local sortedData = {}
  local guildList = {}
  local count = 1
  
  for i = 1, numMembers do
    local memberVar = {GetGuildMemberInfo(SGT.currentGuild, i)}
    table.insert(sortedMembers, i, memberVar[1] .. "**shissu" ..i)
  end
  
  table.sort(sortedMembers)
  
  for i = 1, numMembers do
    local length = string.len(sortedMembers[i])
    local number = string.sub(sortedMembers[i], string.find(sortedMembers[i], "**shissu"), length)
    
    number = string.gsub(number, "**shissu", "")
    number = string.gsub(number, " ", "")
    number = tonumber(number)
   
    local memberVar = {GetGuildMemberInfo(SGT.currentGuild, number)}
   
    sortedData[i] = {}
    sortedData[i].name = memberVar[1]
    sortedData[i].id = number
  end
  
  for i = 1, #sortedData do
    local memberVar = {GetGuildMemberInfo(SGT.currentGuild, sortedData[i].id)}
    local charVar = {GetGuildMemberCharacterInfo(SGT.currentGuild, sortedData[i].id)}  
    local memberOfflineSince = math.floor(memberVar[5] / 86400)

    if (SGT.RecipientChoice.Aldmeri and charVar[5] == 1) 
      or (SGT.RecipientChoice.Ebonheart and charVar[5] == 2) 
      or (SGT.RecipientChoice.Daggerfall and charVar[5] == 3) then 

      if (SGT.RecipientChoice.Online and (memberVar[4] == 1 or memberVar[4] == 2 or memberVar[4] == 3)) 
        or (SGT.RecipientChoice.Offline and (memberVar[4] == 4)) then 

        if SGT.currentRank == 0 and memberOfflineSince >= SGT.offlineSince
          or memberVar[3] == SGT.currentRank and memberOfflineSince >= SGT.offlineSince then  
    
          guildList[count] = {}
          guildList[count].name = sortedData[i].name
          guildList[count].id = sortedData[i].id
          
          count = count + 1
        end
      end
    end                              
  end
  
  return guildList
end

function SGT.manuellMailList()
  SGT_Notebook_MessagesRecipient:SetWidth(410)
      
  SGT_Notebook_MessagesRecipient_GuildsLabel:ClearAnchors()
  SGT_Notebook_MessagesRecipient_GuildsLabel:SetAnchor(TOPLEFT, SGT_Notebook_MessagesRecipient_Line, TOPLEFT,  200, 15)
  SGT.divider3:ClearAnchors()
     
  SGT.divider3:SetAnchor(TOPLEFT, SGT_Notebook_MessagesRecipient_Line, TOPRIGHT, 180, 0)
  SGT.divider3:SetAnchor(BOTTOMLEFT, SGT_Notebook_MessagesRecipient, BOTTOMLEFT, 180, 0)
  SGT_Notebook_MessagesRecipient_Add:SetHidden(false)
  SGT_Notebook_MessagesRecipient_Delete:SetHidden(false)   
  SGT_Notebook_MessagesRecipient_BuildGroup:SetHidden(false)          
end

function SGT.autoMailList()
  SGT_Notebook_MessagesRecipient:SetWidth(385)
      
  SGT_Notebook_MessagesRecipient_GuildsLabel:ClearAnchors()
  SGT_Notebook_MessagesRecipient_GuildsLabel:SetAnchor(TOPLEFT, SGT_Notebook_MessagesRecipient_Line, TOPLEFT,  180, 15)
  SGT.divider3:ClearAnchors()
     
  SGT.divider3:SetAnchor(TOPLEFT, SGT_Notebook_MessagesRecipient_Line, TOPRIGHT, 160, 0)
  SGT.divider3:SetAnchor(BOTTOMLEFT, SGT_Notebook_MessagesRecipient, BOTTOMLEFT, 160, 0)
  SGT_Notebook_MessagesRecipient_Add:SetHidden(true)
  SGT_Notebook_MessagesRecipient_Delete:SetHidden(true)
  SGT_Notebook_MessagesRecipient_BuildGroup:SetHidden(true)            
end

-- Liste füllen
function SGT.MailFillScrollList()
  local guildList = SGT.buildGuildList()
  local numMembers = #guildList
  local done = 0
  
  SGT.guildList = {}

  --d(SGT.currentDropText)
  
  if SGT.currentDropText == ShissuGT.Color[2] .. "--|r " .. ShissuGT.Color[5] .. "Freunde" and done == 0 then
    numMembers = GetNumFriends()
    SGT.autoMailList()
    
    for i = 1, numMembers do
      local displayName, _ = GetFriendInfo(i)
      local control = SGT.mailIndexPool:AcquireObject(i)
      control.name = displayName
      control.id = i
      control.index = i
      control:SetText(ShissuGT.Color[5] .. displayName)
      control:SetHidden(false)      
      
      SGT.guildList[i] = {displayName, false}
    end      
    
    done = 1
  end
  
  --d("START2")
  
  for listName, listContent in pairs(SGT.customList) do
    --d(ShissuGT.Color[6] .. "--|r " .. ShissuGT.Color[5] .. listName .. "         -    " .. SGT.currentDropText)
    
    
    if ShissuGT.Color[6] .. "--|r " .. ShissuGT.Color[5] .. listName == SGT.currentDropText and done == 0 then
      -- Empfängeraussehen anpassen
      SGT.manuellMailList()
      
      SGT.currentList = listName
      numMembers = #SGT.customList[listName]
      
      for i = 1, numMembers do
        local displayName, _ = SGT.customList[listName][i]
        local control = SGT.mailIndexPool:AcquireObject(i)
        control.name = SGT.customList[listName][i]
        control.id = i
        control.index = i
        control:SetText(ShissuGT.Color[5] .. SGT.customList[listName][i])
        control:SetHidden(false)      
        
        SGT.guildList[i] = {SGT.customList[listName][i], false}
      end      
      
      done = 1
      break
    end
  end

  if done == 0 then
    SGT.autoMailList()
    
    for i = 1, numMembers do
      local control = SGT.mailIndexPool:AcquireObject(i)
      control.name = guildList[i].name
      control.id = guildList[i].id
      control.index = i
      control:SetText(ShissuGT.Color[5] .. guildList[i].name)
      control:SetHidden(false)      
      
      SGT.guildList[i] = {guildList[i].name, false}
    end              
  end                                                                 

  local activePages = SGT.mailIndexPool:GetActiveObjectCount()
  if activePages > numMembers then
    for i = numMembers+1, activePages do SGT.mailIndexPool:ReleaseObject(i) end
  end
end

function SGT.ProtocolFillScrollList()
  local numFull = #SGT.emailError.full
  local numIgnore = #SGT.emailError.ignore
      
  for i = 1, numFull do
    local control = SGT.protocolFullIndexPool:AcquireObject(i)
    control:SetText(ShissuGT.Color[5] .. SGT.emailError.full[i])
    control:SetHidden(false)      
  end                                                                               

  local activePages = SGT.protocolFullIndexPool:GetActiveObjectCount()
  if activePages > numFull then
    for i = numFull+1, activePages do SGT.protocolFullIndexPool:ReleaseObject(i) end
  end 
  
  for i = 1, numIgnore do
    local control = SGT.protocolIgnoreIndexPool:AcquireObject(i)
    control:SetText(ShissuGT.Color[5] .. SGT.emailError.ignore[i])
    control:SetHidden(false)      
  end                                                                               

  local activePages = SGT.protocolIgnoreIndexPool:GetActiveObjectCount()
  if activePages > numIgnore then
    for i = numIgnore+1, activePages do SGT.protocolIgnoreIndexPool:ReleaseObject(i) end
  end                
end


function SGT.GetOfflineDays(offlineString)
  local stringStart = ShissuGT.Color[6]
  local endString = ShissuGT.Color[5] .. ShissuGT.i18n.Notebook.MailDays
  local days = "0"
  
  if string.len(offlineString) > 3 then
    days = string.gsub(string.gsub(offlineString, stringStart, ""), endString, "")   
    days = tonumber(days)
  else
    days = tonumber(offlineString)
  end
  
  return days
end

-- Offline seit XYZ Tage
function SGT.ButtonOfflineSince(self, button)
  local stringStart = ShissuGT.Color[6]
  local endString = ShissuGT.Color[5] .. ShissuGT.i18n.Notebook.MailDays
  local control = SGT_Notebook_MessagesRecipient_OfflineSince
  local days = SGT.GetOfflineDays(control:GetText())

  if button == 1 then control:SetText(stringStart .. days + 1 .. endString)
  elseif button == 2 then if days ~= 0 then control:SetText(stringStart .. days -1 .. endString) end
  else control:SetText(stringStart .. days + 10 .. endString) end 
  
  SGT.offlineSince = days
  SGT.MailFillScrollList()
end

function SGT.CheckBox(control, var)  
  ShissuGT.Lib.CheckBox(control, var)
  
  ZO_CheckButton_SetToggleFunction(control, function(control, checked)
    SGT.RecipientChoice[var] = checked
    SGT.MailFillScrollList()
  end)
end


function SGT.mailButtons(all, kick)
  local sleepTime = 1600
  local guildId = SGT.currentGuild                      
  local recipient = {}
  local i = 1
  local waitCount = 0
  
  -- aktueller Titel (Betreff) + Text zwischenspeichern, damit aktiv weitergearbeitet werden kann im Notizbuch
  SGT.emailCache.title = SGT_Notebook_NoteTitleText:GetText()
  SGT.emailCache.text = SGT_Notebook_NoteText:GetText() .. "\n\nSent via |c779cffShissu's|r Guild Tools"
 
  if all == 1 then
    for i = 1, #SGT.guildList do
      if SGT.guildList[i][2] == false then
        table.insert(recipient, SGT.guildList[i][1])
      end
    end
  else
    table.insert(recipient, SGT_Notebook_MessagesRecipient_Choice:GetText()) 
  end
  
  if all == 3 and kick == 3 then
    all = SGT.emailAll
    kick = SGT.emailKick
  else
    SGT.emailKick = all
    SGT.emailAll = kick
  end         
  
  if SGT.mailKickChoice == 1 then sleepTime = 500 end
  
  SGT.emailIsSend = true
  if SGT.emailIsOpen == false then RequestOpenMailbox() end 
                      
  SGT_Notebook_MessagesRecipient_ChoiceLabel:SetText(ShissuGT.i18n.Notebook.MailSend)
  
  -- Splash Screen Text  
  SGT_Notebook_Splash_Subject:SetText(SGT.emailCache.title) 
                      
  if SGT.mailKickChoice == 1 and kick == 1 and not kick == 3 then
    SGT_Notebook_Splash_Title:SetText("E-Mail Kick")
  elseif kick == 1 and not kick == 3  then 
    SGT_Notebook_Splash_Title:SetText(ShissuGT.i18n.Notebook.ProgressKickTitle)
  elseif not kick == 3 then
    SGT_Notebook_Splash_Title:SetText(ShissuGT.i18n.Notebook.ProgressTitle)
  end                      
  
  SGT_Notebook_Splash:SetHidden(false)  
  SGT_Notebook:SetHidden(true)
  
  EVENT_MANAGER:RegisterForUpdate("SGT_EVENT_EMAIL", sleepTime, function()    
    if SGT.mailKickChoice == 1 or kick == 0 then
      if SGT.emailIsOpen == false then RequestOpenMailbox() end 
      
      if recipient[i] ~= nil then
        if SGT.emailIsOpen == true and SGT.emailIsSend == true then
          SGT.recipientName = recipient[i]
          SGT_Notebook_Splash_Recipient:SetText(ShissuGT.Color[6].. recipient[i])
          
          if waitCount == 0 then 
            SGT_Notebook_Splash_Waiting:SetText(ShissuGT.Color[3].. ShissuGT.i18n.Notebook.MailProgress) 
            waitCount = 1
          else
            SGT_Notebook_Splash_Waiting:SetText(ShissuGT.Color[5].. ShissuGT.i18n.Notebook.MailProgress) 
            waitCount = 0
          end
          
          QueueMoneyAttachment(0)
          --GuildDemote(1,recipient[i])
          SendMail(recipient[i], SGT.emailCache.title, SGT.emailCache.text)  
          if kick == 1 then GuildRemove(guildId, recipient[i]) end
                            
          i = i + 1
          SGT.emailIsSend = false
        end
      end
    else
      if kick == 1 then GuildRemove(guildId, recipient[i]) end
      i = i + 1
    end
    
    -- Splash Screen    
    if i == #SGT.guildList+1 or all == 0 then
      SGT_Notebook_MessagesRecipient_Choice:SetText(ShissuGT.Color[6] .. ShissuGT.i18n.Notebook.MailDoneL)
      SGT_Notebook_Splash_Progress:SetText(ShissuGT.Color[1] .. ShissuGT.i18n.Notebook.MailDoneL)
      SGT_Notebook_Splash_Waiting:SetText("")

      EVENT_MANAGER:UnregisterForUpdate("SGT_EVENT_EMAIL")    
      SGT.ProtocolFillScrollList()
    else
      SGT_Notebook_MessagesRecipient_Choice:SetText(ShissuGT.Color[6] .. i .. "/" .. ShissuGT.Color[5].. #recipient)
      SGT_Notebook_Splash_Progress:SetText(ShissuGT.Color[6] .. i .. "/" .. ShissuGT.Color[5].. #recipient)
    end
  end)
end

SGT.currentDropText = ""

function SGT.optionSelected(_, statusText, choiceNumber)
  SGT.currentDropText  = statusText
  
  for guildId = 1, GetNumGuilds() do
    if GetGuildName(guildId) == statusText then
      SGT.currentGuild = guildId
      
      SGT.dropDownRanks:ClearItems()
      SGT.dropDownRanks:AddItem(SGT.dropDownRanks:CreateItemEntry(ShissuGT.i18n.Notebook.All, SGT.optionSelected))
        
      for rankId = 1, GetNumGuildRanks(guildId) do
        SGT.dropDownRanks:AddItem(SGT.dropDownRanks:CreateItemEntry(GetFinalGuildRankName(guildId, rankId), SGT.optionSelected))
      end

      break
    end   
  end
  
  for rankId = 1, GetNumGuildRanks(SGT.currentGuild) do
    if GetFinalGuildRankName(SGT.currentGuild, rankId) == statusText then 
      SGT.currentRank = rankId 
      break 
    else
      SGT.currentRank = 0
    end
  end 

  SGT.MailFillScrollList()
end

-- LABEL Nachrichtenkick anpassen
function SGT.labelMailKick()
  if SGT.mailKickChoice == 1 then
    SGT.mailKickChoice = 0
    SGT_Notebook_MessagesRecipient_EMailKickLabeChoice:SetText(ShissuGT.Color[3] .. ShissuGT.i18n.Notebook.MailOff)
  else
    SGT.mailKickChoice = 1
    SGT_Notebook_MessagesRecipient_EMailKickLabeChoice:SetText(ShissuGT.Color[1] .. ShissuGT.i18n.Notebook.MailOn)
  end
end

function SGT.mailAbort()  
  EVENT_MANAGER:UnregisterForUpdate("SGT_EVENT_EMAIL") 
  SGT_Notebook_MessagesRecipient_Choice:SetText(ShissuGT.Color[3] .. ShissuGT.i18n.Notebook.MailDoneL)
  
  SGT_Notebook_Splash:SetHidden(true)  
end

function SGT.mailContinue()
   SGT.mailButtons(3, 3)
end

function SGT.mailProtocol()
  if SGT_MailProtocol:IsHidden() then
    SGT_MailProtocol:SetHidden(false)
    SGT.ProtocolFillScrollList()
  else
    SGT_MailProtocol:SetHidden(true)
  end  
end


function SGT.addPlayerToList(self, button)
  if button ~= 1 then return end

    ESO_Dialogs["SGT_EDIT"].title = {text = ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.Notebook.ListPlayerAdd),}
    ESO_Dialogs["SGT_EDIT"].mainText = {text = "Name?",}      
    ESO_Dialogs["SGT_EDIT"].buttons[1].callback = function(dialog) 
      local playerName = dialog:GetNamedChild("EditBox"):GetText()

      if playerName ~= nil or playerName ~= "" or playerName ~= " " then
        local guildSign = string.sub(playerName,1,1) 
        local guildId = string.sub(playerName,2,2) 

        if guildSign == "%" then
          guildId = GetGuildId(guildId)
          
          if guildId ~= 0 then
            for memberId=1, GetNumGuildMembers(guildId), 1 do
              local memberInfo = { GetGuildMemberInfo(guildId, memberId) }
              local found = 0
              
              for nameId = 1, #SGT.customList[SGT.currentList] do
                if SGT.customList[SGT.currentList][nameId] == memberInfo[1] then
                  found = 1
                end
              end

              if found == 0 then
                table.insert(SGT.customList[SGT.currentList], memberInfo[1]) 
              end 
            
            end
          end
        else
          table.insert(SGT.customList[SGT.currentList], playerName)        
        end
        
        SGT.MailFillScrollList()
      end
    end

    ZO_Dialogs_ShowDialog("SGT_EDIT")
end

function SGT.deletePlayerfromList(self, button)
  if button ~= 1 then return end
  
  local numPlayer = #SGT.customList[SGT.currentList]

  for i = 1, numPlayer do
    --d(SGT.customList[SGT.currentList][i] .. "       -  "  .. SGT.clickChoice)
    
    if SGT.customList[SGT.currentList][i] == SGT.clickChoice then
      --d("del")
      SGT.customList[SGT.currentList][i] = nil
      SGT.MailFillScrollList()
      return
    end
  end
end

function SGT.newList(self, button)
  if button == 1 then
    -- Neue Liste anlegen
    local listName = nil

    ESO_Dialogs["SGT_EDIT"].title = {text = "Neue Liste",}
    ESO_Dialogs["SGT_EDIT"].mainText = {text = "Listenname?",}      
    ESO_Dialogs["SGT_EDIT"].buttons[1].callback = function(dialog) 
      listName = dialog:GetNamedChild("EditBox"):GetText()

      if listName ~= nil or listName ~= "" or listName ~= " " then
        SGT.dropDownGuilds:AddItem(SGT.dropDownGuilds:CreateItemEntry(ShissuGT.Color[6] .. "--|r " .. ShissuGT.Color[5] .. listName, SGT.optionSelected))
        if SGT.customList[listName] == nil then SGT.customList[listName] = {} end        
      end
    end

    ZO_Dialogs_ShowDialog("SGT_EDIT")
  else
  -- Liste löschen
    for listName, listContent in pairs(SGT.customList) do
      if ShissuGT.Color[6] .. "--|r " .. ShissuGT.Color[5] .. listName == SGT.currentDropText then
        SGT.customList[listName] = nil
        SGT.buildMailList()
        return
      end
    end
  end
end

function SGT.buildGroupWithList()
  for i = 1, #SGT.guildList do
    if SGT.guildList[i][2] == false then
      d(ShissuGT.ColoredName .. ": Spieler einladen - " .. ShissuGT.Color[7] .. SGT.guildList[i][1])
      GroupInviteByName(SGT.guildList[i][1])
    end
  end
end

function SGT.buildMailList()
  SGT.dropDownGuilds:ClearItems()
  SGT.dropDownGuilds:AddItem(SGT.dropDownGuilds:CreateItemEntry(ShissuGT.Color[2] .. "--|r " .. ShissuGT.Color[5] .. "Freunde", SGT.optionSelected))
  
  for listName, listContent in pairs(SGT.customList) do
    if listContent ~= nil then
      SGT.dropDownGuilds:AddItem(SGT.dropDownGuilds:CreateItemEntry(ShissuGT.Color[6] .. "--|r " .. ShissuGT.Color[5] .. listName, SGT.optionSelected))
    end
  end
  
  for guildId = 1, GetNumGuilds() do
    SGT.dropDownGuilds:AddItem(SGT.dropDownGuilds:CreateItemEntry(GetGuildName(guildId), SGT.optionSelected))
  end
end

function SGT.MailUIElements()
  -- Allgemeine Formatierungen
  SGT_Notebook_MessagesRecipient_Title:SetText(ShissuGT.i18n.Notebook.MailTitle)
  SGT_Notebook_MessagesRecipient_ButtonChoice:SetText(ShissuGT.i18n.Notebook.MailChoice)
  SGT_Notebook_MessagesRecipient_ButtonAll:SetText(ShissuGT.i18n.Notebook.MailAll)
  SGT_Notebook_MessagesRecipient_ButtonKick:SetText(ShissuGT.i18n.Notebook.MailChoiceKick)
  SGT_Notebook_MessagesRecipient_ButtonAllKick:SetText(ShissuGT.i18n.Notebook.MailAllKick)  
  SGT_Notebook_MessagesRecipient_GuildsLabel:SetText(ShissuGT.i18n.Notebook.MailGuild)
  SGT_Notebook_MessagesRecipient_RanksLabel:SetText(ShissuGT.i18n.Notebook.MailRank)
  SGT_Notebook_MessagesRecipient_OfflineSinceLabel:SetText(ShissuGT.i18n.Notebook.MailOfflineSince)
  SGT_Notebook_MessagesRecipient_ChoiceLabel:SetText(ShissuGT.i18n.Notebook.MailChoiceL)
  SGT_Notebook_MessagesRecipient_ButtonChoice:SetText(ShissuGT.i18n.Notebook.Choice)
  SGT_Notebook_MessagesRecipient_ButtonAll:SetText(ShissuGT.i18n.Notebook.List)
  SGT_Notebook_MessagesRecipient_ButtonKick:SetText(ShissuGT.i18n.Notebook.Choice)
  SGT_Notebook_MessagesRecipient_ButtonAllKick:SetText(ShissuGT.i18n.Notebook.List)
  SGT_Notebook_MessagesRecipient_EMailKickLabeChoice:SetText(ShissuGT.Color[1] .. ShissuGT.i18n.Notebook.MailOn)
  SGT_Notebook_MessagesRecipient_EMailKickLabel:SetText(ShissuGT.i18n.Notebook.MailKick)
  SGT_Notebook_MessagesRecipient_FactionLabel:SetText(ShissuGT.i18n.Alliance)
                                                                         
  ShissuGT.Lib.SetVersionUI(SGT_Notebook_Splash_Version)
  ShissuGT.Lib.SetVersionUI(SGT_MailProtocol_Version)
  ShissuGT.Lib.SetSGTTitle(SGT_MailProtocol_Title, "Mail " .. ShissuGT.i18n.Notebook.Protocol)
  
  SGT_MailProtocol_Full:SetText(ShissuGT.i18n.Notebook.ProtocolFull)
  SGT_MailProtocol_Ignore:SetText(ShissuGT.i18n.Notebook.ProtocolIgnore)  
  
  SGT_Notebook_Splash_SubjectLabel:SetText(ShissuGT.i18n.Notebook.Subject .. ":")
  SGT_Notebook_Splash_ProgressLabel:SetText(ShissuGT.i18n.Notebook.Progress .. ":")

  ShissuGT.Lib.SetStdColor( SGT_Notebook_MessagesRecipient_Line)    
  ShissuGT.Lib.SetStdColor(SGT_Notebook_MessagesRecipient_Line2)  
  ShissuGT.Lib.SetStdColor(SGT_Notebook_MessagesRecipient_Line3)  
  ShissuGT.Lib.SetStdColor(SGT_Notebook_MessagesRecipient_Line4)  
  ShissuGT.Lib.SetStdColor(SGT_MailProtocol_Line)  
  ShissuGT.Lib.SetStdColor(SGT_Notebook_Splash_Line)  

  SGT.divider2 = ShissuGT.Lib.CreateBlueLine("SGT_ProtocolDivider", SGT_MailProtocol, SGT_MailProtocol_Line, 160)
  SGT.divider3 = ShissuGT.Lib.CreateBlueLine("SGT_RecipientDivider", SGT_Notebook_MessagesRecipient, SGT_Notebook_MessagesRecipient_Line, 160)
  
  -- Schließen Button NEU
  SGT.closeProtocolButton = ShissuGT.Lib.CreateCloseButton("SGT_MailProtocol_Close", SGT_MailProtocol, function() SGT_MailProtocol:SetHidden(true) end)
  SGT.closeSplashButton = ShissuGT.Lib.CreateCloseButton("SGT_Notebook_Splash_Close", SGT_Notebook_Splash, SGT.mailAbort)
  SGT.closeSplashButton:SetHandler("OnMouseEnter", function(self) 
    ShissuGT.Lib.SetStdColor(self)     
    ShissuGT.Lib.ToolTip(self,ShissuGT.i18n.Notebook.ToolTipAbort)
  end)
  SGT.closeSplashButton:SetHandler("OnMouseExit", function(self) 
    ZO_Tooltips_HideTextTooltip()
    self:SetColor(1,1,1,1)
  end)  
  SGT.closeSplashButton:SetHandler("OnMouseUp", SGT.mailAbort)  
          
  -- Checkboxen
  SGT.CheckBox(SGT_Notebook_MessagesRecipient_StatusOnline, "Online")
  SGT.CheckBox(SGT_Notebook_MessagesRecipient_StatusOffline, "Offline")
  SGT.CheckBox(SGT_Notebook_MessagesRecipient_FactionAldmeri, "Aldmeri")
  SGT.CheckBox(SGT_Notebook_MessagesRecipient_FactionEbonheart, "Ebonheart")
  SGT.CheckBox(SGT_Notebook_MessagesRecipient_FactionDaggerfall, "Daggerfall")  
  
  -- Handlers
  SGT_Notebook_MessagesRecipient_OfflineSince:SetHandler("OnMouseUp", SGT.ButtonOfflineSince)  
  SGT_Notebook_MessagesRecipient_ButtonChoice:SetHandler("OnClicked", function() SGT.mailButtons(0, 0) end)
  SGT_Notebook_MessagesRecipient_ButtonAll:SetHandler("OnClicked", function() SGT.mailButtons(1, 0) end)
  SGT_Notebook_MessagesRecipient_ButtonKick:SetHandler("OnClicked", function() ShissuGT.Lib.ShowDialog(GetString(SI_PROMPT_TITLE_GUILD_REMOVE_MEMBER), ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.Notebook.ConfirmEmailKick), function() SGT.mailButtons(0, 1) end, nil) end)
  SGT_Notebook_MessagesRecipient_ButtonAllKick:SetHandler("OnClicked", function() ShissuGT.Lib.ShowDialog(GetString(SI_PROMPT_TITLE_GUILD_REMOVE_MEMBER), ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.Notebook.ConfirmEmailKick), function() SGT.mailButtons(1, 1) end, nil) end)       
  SGT_Notebook_MessagesRecipient_EMailKickLabeChoice:SetHandler("OnMouseUp", SGT.labelMailKick) 
  SGT_Notebook_Splash_Continue:SetHandler("OnClicked", SGT.mailContinue)
  SGT_Notebook_Splash_Protocol:SetHandler("OnClicked", SGT.mailProtocol)
               
  -- DropDown Menü "Gilde" befüllen   
  SGT_Notebook_MessagesRecipient_Guilds:GetNamedChild("Dropdown"):SetWidth(120)
  SGT_Notebook_MessagesRecipient_Guilds:SetWidth(120)  
  
  SGT.dropDownGuilds = SGT_Notebook_MessagesRecipient_Guilds.dropdown
  SGT.dropDownGuilds:AddItem(SGT.dropDownGuilds:CreateItemEntry(ShissuGT.Color[2] .. "--|r " .. ShissuGT.Color[5] .. "Freunde", SGT.optionSelected))
  
  SGT.buildMailList()
  
  SGT_Notebook_MessagesRecipient_NewList:SetHandler("OnMouseUp", SGT.newList)
  SGT_Notebook_MessagesRecipient_Add:SetHandler("OnMouseUp", SGT.addPlayerToList)
  SGT_Notebook_MessagesRecipient_Delete:SetHandler("OnMouseUp", SGT.deletePlayerfromList)
  SGT_Notebook_MessagesRecipient_BuildGroup:SetHandler("OnMouseUp", SGT.buildGroupWithList)
  
  -- DropDown Menü "Rank" befüllen
  SGT_Notebook_MessagesRecipient_Ranks:GetNamedChild("Dropdown"):SetWidth(140)
  SGT_Notebook_MessagesRecipient_Ranks:SetWidth(140)  
           
  SGT.dropDownRanks  = SGT_Notebook_MessagesRecipient_Ranks.dropdown
  SGT.dropDownRanks:AddItem(SGT.dropDownRanks:CreateItemEntry(ShissuGT.i18n.Notebook.All, SGT.optionSelected))
  
  for rankId = 1, GetNumGuildRanks(SGT.currentGuild) do
    SGT.dropDownRanks:AddItem(SGT.dropDownRanks:CreateItemEntry(GetFinalGuildRankName(SGT.currentGuild, rankId), SGT.optionSelected))
  end  
  
  -- ScrollContainer + UI
  SGT.mailIndexPool = ZO_ObjectPool:New(SGT.mailCreateIndexButton, SGT.removeIndexButton)
  SGT.mailList = ShissuGT.Lib.CreateUIList("SGT_Notebook_EMailList", 145, SGT_Notebook_MessagesRecipient, SGT_Notebook_MessagesRecipient_Line, 10, 10, -10)  
  SGT.mailSelected = WINDOW_MANAGER:CreateControl(nil, SGT.mailList.scrollChild, CT_TEXTURE)
  SGT.mailSelected:SetTexture("EsoUI\\Art\\Buttons\\generic_highlight.dds")
  ShissuGT.Lib.SetStdColor(SGT.mailSelected)  
  SGT.mailSelected:SetHidden(true)
  
  -- Protocol ScrollContainer
  SGT.protocolFullIndexPool = ZO_ObjectPool:New(SGT.protocolCreateIndexButton, SGT.removeIndexButton)
  SGT.ProtocolList.Full = ShissuGT.Lib.CreateUIList("SGT_Notebook_FullList", 145, SGT_MailProtocol, SGT_MailProtocol_Line, 10, 40, -10)  
  SGT.protocolIgnoreIndexPool = ZO_ObjectPool:New(SGT.protocolCreateIndexButton, SGT.removeIndexButton)
  SGT.ProtocolList.Ignore = ShissuGT.Lib.CreateUIList("SGT_Notebook_IgnoreList", 145, SGT_MailProtocol, SGT_MailProtocol_Line, 175, 40, -10)  

  SGT.MailFillScrollList()
end

function SGT.protocolCreateIndexButton(indexPool)
  local var = "Full"
  
  if indexPool == SGT.protocolIgnoreIndexPool then var = "Ignore" end

  local control = ZO_ObjectPool_CreateControl("SGT_Notebook_MailProtocol" .. var .. "Index", indexPool, SGT.ProtocolList[var].scrollChild)
  local anchorBtn = SGT.Item[var] == 1 and SGT.ProtocolList[var].scrollChild or indexPool:AcquireObject(SGT.Item[var]-1)
  
  control:SetAnchor(TOPLEFT, anchorBtn, SGT.Item[var] == 1 and TOPLEFT or BOTTOMLEFT)
  control:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  control:SetWidth(140)

  SGT.Item[var] = SGT.Item[var] + 1
  
  return control
end

function ShissuGT.Notebook.Toggle()
  SGT.Toogle()
end

function ShissuGT.Notebook.Initialize()
  -- Gespeicherte Notizen laden
  shissuGT.Notes = shissuGT.Notes or {}
  SGT.Data = shissuGT.Notes
  
  shissuGT.mailList = shissuGT.mailList or {}
  SGT.customList = shissuGT.mailList
  
  local save = ShissuGT.Settings.Teleport
  
  -- UI Elemente
  SGT.NoteUIElements()
  SGT.FillScrollList()
  
  -- Anchors, Anchors Controls
  ShissuGT.Lib.MoveWindow(SGT_Notebook, "Notebook")
  ShissuGT.Lib.SetWindowPos(SGT_Notebook, "Notebook")
  
  ShissuGT.Lib.MoveWindow(SGT_Notebook_Splash, "Notebook", "Splash")
  ShissuGT.Lib.SetWindowPosDouble(SGT_Notebook_Splash, "Notebook", "Splash")
  
  ShissuGT.Lib.MoveWindow(SGT_Notebook_Splash, "Notebook", "Protocol")
  ShissuGT.Lib.SetWindowPosDouble(SGT_Notebook_Splash, "Notebook", "Protocol")

  ShissuGT.Notebook.Active = 1

  -- Mail-Empfänger Fenster initialisieren
  if ShissuGT.Settings.Notebook.EMail == true and ShissuGT.Notebook.MailActive ~= 1 then
    ShissuGT.Notebook.MailActive = 1
    SGT.MailUIElements()
  end
end

-- EVENT FUNCTIONS
function SGT.EVENT_MAIL_SEND_SUCCESS()
  SGT.recipientName = ""
  SGT.emailIsSend = true
end
                        
function SGT.EVENT_MAIL_SEND_FAILED(event, reason) 
  local CN = ShissuGT.ColoredName .. ": " .. ShissuGT.i18n.Setting.NewMail .. " - " .. ShissuGT.Color[7]
  local CT = ShissuGT.Color[7] .. " - "
  
  SGT.emailIsSend = true

  if reason == MAIL_SEND_RESULT_FAIL_INVALID_NAME or reason == MAIL_SEND_RESULT_RECIPIENT_NOT_FOUND then d(CN.. GetString(SI_SENDMAILRESULT2).. CT .. SGT.recipientName)
  elseif reason == MAIL_SEND_RESULT_FAIL_BLANK_MAIL then d(CN.. ShissuGT.i18n.Notebook.MailERR_FAIL_BLANK_MAIL)
  elseif reason == MAIL_SEND_RESULT_NOT_ENOUGH_MONEY then d(CN.. GetString(SI_SENDMAILRESULT5))
  elseif reason == MAIL_SEND_RESULT_FAIL_MAILBOX_FULL then 
    d(CN.. GetString(SI_SENDMAILRESULT3).. CT .. SGT.recipientName)
    table.insert(SGT.emailError.full, SGT.recipientName)
  elseif reason == MAIL_SEND_RESULT_FAIL_IGNORED then 
    d(CN.. GetString(SI_SENDMAILRESULT4).. CT .. SGT.recipientName) 
    table.insert(SGT.emailError.ignore, SGT.recipientName)
  elseif reason == MAIL_SEND_RESULT_FAIL_DB_ERROR or reason == MAIL_SEND_RESULT_FAIL_IN_PROGRESS then d(CN.. GetString(SI_SENDMAILRESULT1))    
  end 
end

function SGT.EVENT_MAIL_CLOSE_MAILBOX()
  SGT.emailIsOpen = false
end   

function SGT.EVENT_MAIL_OPEN_MAILBOX()
  SGT.emailIsOpen = true  
end    

-- EVENTS
EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_MAIL_CLOSE_MAILBOX, SGT.EVENT_MAIL_CLOSE_MAILBOX)
EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_MAIL_SEND_FAILED, SGT.EVENT_MAIL_SEND_FAILED)
EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_MAIL_SEND_SUCCESS, SGT.EVENT_MAIL_SEND_SUCCESS)
EVENT_MANAGER:RegisterForEvent(ShissuGT.Name, EVENT_MAIL_OPEN_MAILBOX, SGT.EVENT_MAIL_OPEN_MAILBOX)