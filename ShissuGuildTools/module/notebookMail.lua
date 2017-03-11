-- Shissu GuildTools Module File
--------------------------------
-- File: notebookMail.lua
-- Version: v2.0.1
-- Last Update: 04.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!

local _globals = Shissu_SuiteManager._globals
local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]
local green = _globals["color"]["green"]
local yellow = _globals["color"]["yellow"]
local red = _globals["color"]["red"]
local orange = _globals["color"]["orange"]

local _lib = Shissu_SuiteManager._lib
local _SGT = Shissu_SuiteManager._lib["SGT"]
local getString = _SGT.getString
local setDefaultColor = _SGT.setDefaultColor
local createBlueLine = _SGT.createBlueLine
local checkBoxLabel = _SGT.checkBoxLabel
local createScrollContainer = _SGT.createScrollContainer
local showDialog = _SGT.showDialog
local createCloseButton = _SGT.createCloseButton
local getWindowPosition = _SGT.getWindowPosition
local saveWindowPosition = _SGT.saveWindowPosition

local _addon = {}
_addon.Name	= "ShissuNotebookMail"
_addon.Version = "2.0.0"
_addon.core = {}
_addon.fN = _SGT["title"]("Notebook Mailer")
_addon.friends = "--|r " .. white .. getString(Shissu_friend) 

_addon.settings = {
  ["position_1"] = {},
  ["position_2"] = {},
}

local _mail = {}
_mail.cache = {}
_mail.dropDownGuilds = nil
_mail.dropDownRanks = nil
_mail.offlineSince = 0
_mail.currentGuild = 1
_mail.currentRank = 0
_mail.guildList = {}
_mail.currentList = {}
_mail.scrollItem = 1
_mail.indexPool = nil
_mail.list = nil
_mail.kickChoice = 1
_mail.protocolFullIndexPool = nil
_mail.protocolIgnoreIndexPool = nil
_mail.isSend = false
_mail.isOpen = false
_mail.kick = nil
_mail.all = nil
_mail.clickChoice = nil
_mail.clickIndex = nil

_mail.recipientName = ""
_mail.RecipientChoice = {
  Online = true,
  Offline = true,
  Aldmeri = true,
  Ebonheart = true,
  Daggerfall = true,
}   
_mail.Item = {
  Full = 1,
  Ignore = 1,
}
  
_mail.customList = nil 
  
_mail.ProtocolList = {
  Full = nil,
  Ignore = nil,
}    

_mail.emailError = {
   full = {},
   ignore = {},
}    

function _mail.removeIndexButton(control)
  control:SetHidden(true)
end

function _mail.getGuildNote(memberId)
  local memberVar = {GetGuildMemberInfo(_mail.currentGuild, memberId)}
  
  if memberVar then
    return memberVar[2]
  end
  
  return false
end

function _mail.createIndexButton(indexPool)
  local control = ZO_ObjectPool_CreateControl("SGT_Notebook_MailIndex", indexPool, _mail.list.scrollChild)
  local anchorBtn = _mail.scrollItem == 1 and _mail.list.scrollChild or indexPool:AcquireObject(_mail.scrollItem-1)
  
  control:SetAnchor(TOPLEFT, anchorBtn, _mail.scrollItem == 1 and TOPLEFT or BOTTOMLEFT)
  control:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  control:SetWidth(140)
  control:SetHandler("OnMouseUp", function(self, button)
    if button == 2 then
      if _mail.guildList[self.index][2] == false then
        _mail.guildList[self.index] = {self.name, true} 
        control:SetText(red .. self.name)
      elseif _mail.guildList[self.index][2] == true then
        _mail.guildList[self.index] = {self.name, false}
        control:SetText(white .. self.name)
      else
        _mail.guildList[self.index] = {self.name, true}
        control:SetText(red .. self.name)
      end
    else
      SGT_Notebook_MessagesRecipient_Choice:SetText(self.name)
      _mail.clickChoice = self.name
      _mail.clickIndex = self.index
    end
  end)
  
  control:SetHandler("OnMouseExit", function(self) ZO_Tooltips_HideTextTooltip() end) 
  control:SetHandler("OnMouseEnter", function(self) 
    if _mail.getGuildNote(self.id) and _mail.getGuildNote(self.id) ~= "" then
      ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, white .. _mail.getGuildNote(self.id)) 
    end
  end)

  _mail.scrollItem = _mail.scrollItem  + 1
  
  return control
end

function _mail.buildGuildList()
  local numMembers = GetNumGuildMembers(_mail.currentGuild)
  local sortedMembers = {}
  local sortedData = {}
  local guildList = {}
  local count = 1
  
  for i = 1, numMembers do
    local memberVar = {GetGuildMemberInfo(_mail.currentGuild, i)}
    table.insert(sortedMembers, i, memberVar[1] .. "**shissu" ..i)
  end
  
  table.sort(sortedMembers)
  
  for i = 1, numMembers do
    local length = string.len(sortedMembers[i])
    local number = string.sub(sortedMembers[i], string.find(sortedMembers[i], "**shissu"), length)
    
    number = string.gsub(number, "**shissu", "")
    number = string.gsub(number, " ", "")
    number = tonumber(number)
   
    local memberVar = {GetGuildMemberInfo(_mail.currentGuild, number)}
   
    sortedData[i] = {}
    sortedData[i].name = memberVar[1]
    sortedData[i].id = number
  end
  
  for i = 1, #sortedData do
    local memberVar = {GetGuildMemberInfo(_mail.currentGuild, sortedData[i].id)}
    local charVar = {GetGuildMemberCharacterInfo(_mail.currentGuild, sortedData[i].id)}  
    local memberOfflineSince = math.floor(memberVar[5] / 86400)

    if (_mail.RecipientChoice.Aldmeri and charVar[5] == 1) 
      or (_mail.RecipientChoice.Ebonheart and charVar[5] == 2) 
      or (_mail.RecipientChoice.Daggerfall and charVar[5] == 3) then 

      if (_mail.RecipientChoice.Online and (memberVar[4] == 1 or memberVar[4] == 2 or memberVar[4] == 3)) 
        or (_mail.RecipientChoice.Offline and (memberVar[4] == 4)) then 

        if _mail.currentRank == 0 and memberOfflineSince >= _mail.offlineSince
          or memberVar[3] == _mail.currentRank and memberOfflineSince >= _mail.offlineSince then  
    
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

function _mail.manuellMailList()
  SGT_Notebook_MessagesRecipient:SetWidth(410)
      
  SGT_Notebook_MessagesRecipient_GuildsLabel:ClearAnchors()
  SGT_Notebook_MessagesRecipient_GuildsLabel:SetAnchor(TOPLEFT, SGT_Notebook_MessagesRecipient_Line, TOPLEFT,  200, 15)
  _mail.divider3:ClearAnchors()
     
  _mail.divider3:SetAnchor(TOPLEFT, SGT_Notebook_MessagesRecipient_Line, TOPRIGHT, 180, 0)
  _mail.divider3:SetAnchor(BOTTOMLEFT, SGT_Notebook_MessagesRecipient, BOTTOMLEFT, 180, 0)
  SGT_Notebook_MessagesRecipient_Add:SetHidden(false)
  SGT_Notebook_MessagesRecipient_Delete:SetHidden(false)   
  SGT_Notebook_MessagesRecipient_BuildGroup:SetHidden(false)          
end

function _mail.autoMailList()
  SGT_Notebook_MessagesRecipient:SetWidth(385)
      
  SGT_Notebook_MessagesRecipient_GuildsLabel:ClearAnchors()
  SGT_Notebook_MessagesRecipient_GuildsLabel:SetAnchor(TOPLEFT, SGT_Notebook_MessagesRecipient_Line, TOPLEFT,  180, 15)
  _mail.divider3:ClearAnchors()
     
  _mail.divider3:SetAnchor(TOPLEFT, SGT_Notebook_MessagesRecipient_Line, TOPRIGHT, 160, 0)
  _mail.divider3:SetAnchor(BOTTOMLEFT, SGT_Notebook_MessagesRecipient, BOTTOMLEFT, 160, 0)
  SGT_Notebook_MessagesRecipient_Add:SetHidden(true)
  SGT_Notebook_MessagesRecipient_Delete:SetHidden(true)
  SGT_Notebook_MessagesRecipient_BuildGroup:SetHidden(true)            
end

-- Liste füllen
function _mail.fillScrollList()
  local guildList = _mail.buildGuildList()
  local numMembers = #guildList
  local done = 0
  
  _mail.guildList = {}

  --d(_mail.currentDropText)
  
  if _mail.currentDropText == yellow .. "--|r " .. white .. getString(Shissu_friend) and done == 0 then
    numMembers = GetNumFriends()
    _mail.autoMailList()
    
    for i = 1, numMembers do
      local displayName, _ = GetFriendInfo(i)
      local control = _mail.indexPool:AcquireObject(i)
      control.name = displayName
      control.id = i
      control.index = i
      control:SetText(white .. displayName)
      control:SetHidden(false)      
      
      _mail.guildList[i] = {displayName, false}
    end      
    
    done = 1
  end
  
  --d("START2")
  
  for listName, listContent in pairs(_mail.customList) do
    --d(ShissuGT.Color[6] .. "--|r " .. ShissuGT.Color[5] .. listName .. "         -    " .. _mail.currentDropText)
    
    
    if blue .. "--|r " .. white .. listName == _mail.currentDropText and done == 0 then
      -- Empfängeraussehen anpassen
      _mail.manuellMailList()
      
      _mail.currentList = listName
      numMembers = #_mail.customList[listName]
      
      for i = 1, numMembers do
        local displayName, _ = _mail.customList[listName][i]
        local control = _mail.indexPool:AcquireObject(i)
        control.name = _mail.customList[listName][i]
        control.id = i
        control.index = i
        control:SetText(white .. _mail.customList[listName][i])
        control:SetHidden(false)      
        
        _mail.guildList[i] = {_mail.customList[listName][i], false}
      end      
      
      done = 1
      break
    end
  end

  if done == 0 then
    _mail.autoMailList()
    
    for i = 1, numMembers do
      local control = _mail.indexPool:AcquireObject(i)
      control.name = guildList[i].name
      control.id = guildList[i].id
      control.index = i
      control:SetText(white .. guildList[i].name)
      control:SetHidden(false)      
      
      _mail.guildList[i] = {guildList[i].name, false}
    end              
  end                                                                 

  local activePages = _mail.indexPool:GetActiveObjectCount()
  if activePages > numMembers then
    for i = numMembers+1, activePages do _mail.indexPool:ReleaseObject(i) end
  end
end

function _mail.ProtocolFillScrollList()
  local numFull = #_mail.emailError.full
  local numIgnore = #_mail.emailError.ignore
      
  for i = 1, numFull do
    local control = _mail.protocolFullIndexPool:AcquireObject(i)
    control:SetText(white .. _mail.emailError.full[i])
    control:SetHidden(false)      
  end                                                                               

  local activePages = _mail.protocolFullIndexPool:GetActiveObjectCount()
  if activePages > numFull then
    for i = numFull+1, activePages do _mail.protocolFullIndexPool:ReleaseObject(i) end
  end 
  
  for i = 1, numIgnore do
    local control = _mail.protocolIgnoreIndexPool:AcquireObject(i)
    control:SetText(white .. _mail.emailError.ignore[i])
    control:SetHidden(false)      
  end                                                                               

  local activePages = _mail.protocolIgnoreIndexPool:GetActiveObjectCount()
  if activePages > numIgnore then
    for i = numIgnore+1, activePages do _mail.protocolIgnoreIndexPool:ReleaseObject(i) end
  end                
end


function _mail.GetOfflineDays(offlineString)
  local stringStart = blue
  local endString = white .. " " .. getString(ShissuNotebookMail_days)
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
function _mail.ButtonOfflineSince(self, button)
  local stringStart = blue
  local endString = white .. " " .. getString(ShissuNotebookMail_days)
  local control = SGT_Notebook_MessagesRecipient_OfflineSince
  local days = _mail.GetOfflineDays(control:GetText())

  if button == 1 then control:SetText(stringStart .. days + 1 .. endString)
  elseif button == 2 then if days ~= 0 then control:SetText(stringStart .. days -1 .. endString) end
  else control:SetText(stringStart .. days + 10 .. endString) end 
  
  _mail.offlineSince = days
  _mail.fillScrollList()
end

function _mail.checkBox(control, var)  
  ZO_CheckButton_SetToggleFunction(control, function(control, checked)
    _mail.RecipientChoice[var] = checked
    _mail.fillScrollList()
  end)
end


function _mail.mailButtons(all, kick)
  local sleepTime = 1600
  local guildId = _mail.currentGuild                      
  local recipient = {}
  local i = 1
  local waitCount = 0
  
  -- aktueller Titel (Betreff) + Text zwischenspeichern, damit aktiv weitergearbeitet werden kann im Notizbuch
  _mail.cache.title = SGT_Notebook_NoteTitleText:GetText()
  _mail.cache.text = SGT_Notebook_NoteText:GetText() .. "\n\nSent via |c779cffShissu's|r GuildTools 3"
 
  if all == 1 then
    for i = 1, #_mail.guildList do
      if _mail.guildList[i][2] == false then
        table.insert(recipient, _mail.guildList[i][1])
      end
    end
  else
    table.insert(recipient, SGT_Notebook_MessagesRecipient_Choice:GetText()) 
  end
  
  if all == 3 and kick == 3 then
    all = _mail.all
    kick = _mail.kick
  else
    _mail.kick = all
    _mail.all = kick
  end         
  
  if _mail.kickChoice == 1 then sleepTime = 500 end
  
  _mail.isSend = true
  if _mail.isOpen == false then RequestOpenMailbox() end 
                      
  SGT_Notebook_MessagesRecipient_ChoiceLabel:SetText(getString(ShissuNotebookMail_send))
  
  -- Splash Screen Text  
  SGT_Notebook_Splash_Subject:SetText(_mail.cache.title) 
                      
  if _mail.kickChoice == 1 and kick == 1 and not kick == 3 then
    SGT_Notebook_Splash_Title:SetText("E-Mail Kick")
  elseif kick == 1 and not kick == 3  then 
    SGT_Notebook_Splash_Title:SetText(getString(ShissuNotebookMail_progressKickTitle))
  elseif not kick == 3 then
    SGT_Notebook_Splash_Title:SetText(getString(ShissuNotebookMail_progressTitle))
  end                      
  
  SGT_Notebook_Splash:SetHidden(false)  
  SGT_Notebook:SetHidden(true)
  
  EVENT_MANAGER:RegisterForUpdate("SGT_EVENT_EMAIL", sleepTime, function()    
    d(_mail.kickChoice)
    
    if _mail.kickChoice == 1 or kick == 0 then
      if _mail.emailIsOpen == false then RequestOpenMailbox() end 
      
      if recipient[i] ~= nil then
        if _mail.emailIsOpen == true and _mail.isSend == true then
          _mail.recipientName = recipient[i]
          SGT_Notebook_Splash_Recipient:SetText(blue.. recipient[i])
          
          if waitCount == 0 then 
            SGT_Notebook_Splash_Waiting:SetText(red .. getString(ShissuNotebookMail_mailProgress)) 
            waitCount = 1
          else
            SGT_Notebook_Splash_Waiting:SetText(white .. getString(ShissuNotebookMail_mailProgress)) 
            waitCount = 0
          end
          
          QueueMoneyAttachment(0)
          --GuildDemote(1,recipient[i])
          SendMail(recipient[i], _mail.cache.title, _mail.cache.text)  
          if kick == 1 then GuildRemove(guildId, recipient[i]) end
                            
          i = i + 1
          _mail.isSend = false
        end
      end
    else
      if kick == 1 then GuildRemove(guildId, recipient[i]) end
      i = i + 1
    end

    -- Splash Screen    
    if i == #_mail.guildList+1 or all == 0 then
      SGT_Notebook_MessagesRecipient_Choice:SetText(blue .. getString(ShissuNotebookMail_doneL))
      SGT_Notebook_Splash_Progress:SetText(green .. getString(ShissuNotebookMail_doneL))
      SGT_Notebook_Splash_Waiting:SetText("")

      EVENT_MANAGER:UnregisterForUpdate("SGT_EVENT_EMAIL")    
      _mail.ProtocolFillScrollList()
    else
      SGT_Notebook_MessagesRecipient_Choice:SetText(blue .. i .. "/" .. white .. #recipient)
      SGT_Notebook_Splash_Progress:SetText(blue .. i .. "/" .. white .. #recipient)
    end
  end)
end

_mail.currentDropText = ""

function _mail.optionSelected(_, statusText, choiceNumber)
  _mail.currentDropText = statusText
  
  for guildId = 1, GetNumGuilds() do
    if GetGuildName(guildId) == statusText then
      _mail.currentGuild = guildId
      
      _mail.dropDownRanks:ClearItems()
      _mail.dropDownRanks:AddItem(_mail.dropDownRanks:CreateItemEntry(yellow .. "-- " .. white .. getString(ShissuNotebookMail_all2), _addon.core.optionSelected))
  
        
      for rankId = 1, GetNumGuildRanks(guildId) do
        _mail.dropDownRanks:AddItem(_mail.dropDownRanks:CreateItemEntry(GetFinalGuildRankName(guildId, rankId), _mail.optionSelected))
      end

      break
    end   
  end
  
  for rankId = 1, GetNumGuildRanks(_mail.currentGuild) do
    if (string.find(statusText, GetFinalGuildRankName(_mail.currentGuild, rankId))) then 
      _mail.currentRank = rankId 
      break 
    else
      _mail.currentRank = 0
    end
  end 

  _mail.fillScrollList()
end

-- LABEL Nachrichtenkick anpassen
function _mail.labelMailKick()
  if _mail.kickChoice == 1 then
    _mail.kickChoice = 0
    SGT_Notebook_MessagesRecipient_EMailKickLabeChoice:SetText(green .. getString(ShissuNotebookMail_mailOff))
  else
    _mail.kickChoice = 1
    SGT_Notebook_MessagesRecipient_EMailKickLabeChoice:SetText(red .. getString(ShissuNotebookMail_mailOn))
  end
end

function _mail.mailAbort()  
  EVENT_MANAGER:UnregisterForUpdate("SGT_EVENT_EMAIL") 
  SGT_Notebook_MessagesRecipient_Choice:SetText(red .. getString(ShissuNotebookMail_doneL))
  
  SGT_Notebook_Splash:SetHidden(true)  
end

function _mail.mailContinue()
   _mail.mailButtons(3, 3)
end

function _mail.mailProtocol()
  if SGT_MailProtocol:IsHidden() then
    SGT_MailProtocol:SetHidden(false)
    _mail.ProtocolFillScrollList()
  else
    SGT_MailProtocol:SetHidden(true)
  end  
end

function _mail.addPlayerToList(self, button)
  if button ~= 1 then return end

    ESO_Dialogs["SGT_EDIT"].title = {text = getString(ShissuNotebookMail_listPlayerAdd),}
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
              
              for nameId = 1, #_mail.customList[_mail.currentList] do
                if _mail.customList[_mail.currentList][nameId] == memberInfo[1] then
                  found = 1
                end
              end

              if found == 0 then
                table.insert(_mail.customList[_mail.currentList], memberInfo[1]) 
              end 
            
            end
          end
        else
          table.insert(_mail.customList[_mail.currentList], playerName)        
        end
        
        _mail.fillScrollList()
      end
    end

    ZO_Dialogs_ShowDialog("SGT_EDIT")
end

function _mail.deletePlayerfromList(self, button)
  if button ~= 1 then return end
  
  local numPlayer = #_mail.customList[_mail.currentList]

  for i = 1, numPlayer do
    --d(_mail.customList[_mail.currentList][i] .. "       -  "  .. _mail.clickChoice)
    
    if _mail.customList[_mail.currentList][i] == _mail.clickChoice then
      --d("del")
      _mail.customList[_mail.currentList][i] = nil
      _mail.fillScrollList()
      return
    end
  end
end

function _mail.buildGroupWithList()
  for i = 1, #_mail.guildList do
    if _mail.guildList[i][2] == false then
      d(blue .. getString(ShissuNotebookMail_invite) .." - " .. white .. _mail.guildList[i][1])
      GroupInviteByName(_mail.guildList[i][1])
    end
  end
end

function _mail.buildMailList()
  _mail.dropDownGuilds:ClearItems()
  _mail.dropDownGuilds:AddItem(_mail.dropDownGuilds:CreateItemEntry(yellow .. "--|r " .. white .. getString(Shissu_friend), _mail.optionSelected))
  
  for listName, listContent in pairs(_mail.customList) do
    if listContent ~= nil then
      _mail.dropDownGuilds:AddItem(_mail.dropDownGuilds:CreateItemEntry(blue .. "--|r " .. white .. listName, _mail.optionSelected))
    end
  end
  
  for guildId = 1, GetNumGuilds() do
    _mail.dropDownGuilds:AddItem(_mail.dropDownGuilds:CreateItemEntry(GetGuildName(guildId), _mail.optionSelected))
  end
end

function _addon.core.offlineSince()
  ESO_Dialogs["SGT_EDIT"].title = {text = getString(ShissuNotebookMail_offlineSince),}
  ESO_Dialogs["SGT_EDIT"].mainText = {text = getString(ShissuNotebookMail_days) .. "?",}  
  ESO_Dialogs["SGT_EDIT"].buttons[1] = {text = "OK",}     
  ESO_Dialogs["SGT_EDIT"].buttons[1].callback = function(dialog) 
    local days = dialog:GetNamedChild("EditBox"):GetText()
    days = tonumber(days)
      
    if (days ~= nil) then
      if (type(days) == "number") then
        SGT_Notebook_MessagesRecipient_OfflineSince:SetText(blue .. days)
        _mail.offlineSince = days
        _mail.fillScrollList()
      end
    end
  end

  ZO_Dialogs_ShowDialog("SGT_EDIT")
end

function _mail.protocolCreateIndexButton(indexPool)
  local var = "Full"
  
  if indexPool == _mail.protocolIgnoreIndexPool then var = "Ignore" end

  local control = ZO_ObjectPool_CreateControl("SGT_Notebook_MailProtocol" .. var .. "Index", indexPool, _mail.ProtocolList[var].scrollChild)
  local anchorBtn = _mail.Item[var] == 1 and _mail.ProtocolList[var].scrollChild or indexPool:AcquireObject(_mail.Item[var]-1)
  
  control:SetAnchor(TOPLEFT, anchorBtn, _mail.Item[var] == 1 and TOPLEFT or BOTTOMLEFT)
  control:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  control:SetWidth(140)

  _mail.Item[var] = _mail.Item[var] + 1
  
  return control
end

function _addon.core.newList(self, button)
  if button == 1 then
    local listName = nil

    ESO_Dialogs["SGT_EDIT"].title = {text = getString(ShissuNotebookMail_newList),}
    ESO_Dialogs["SGT_EDIT"].mainText = {text = getString(ShissuNotebookMail_listName),}      
    ESO_Dialogs["SGT_EDIT"].buttons[1].callback = function(dialog) 
      listName = dialog:GetNamedChild("EditBox"):GetText()

      if listName ~= nil or listName ~= "" or listName ~= " " then
        _mail.dropDownGuilds:AddItem(_mail.dropDownGuilds:CreateItemEntry(blue .. "--|r " .. white .. listName, _mail.optionSelected))
        if _mail.customList[listName] == nil then _mail.customList[listName] = {} end        
      end
    end

    ZO_Dialogs_ShowDialog("SGT_EDIT")
  else
    _mail.customList[_mail.currentList] = nil
    _mail.buildMailList()
  end
end
  
function _addon.core.mail()
  -- Mailer
  SGT_Notebook_MessagesRecipient_Title:SetText(getString(ShissuNotebookMail_title))
  SGT_Notebook_MessagesRecipient_ButtonChoice:SetText(getString(ShissuNotebookMail_choice))
  SGT_Notebook_MessagesRecipient_ButtonAll:SetText(getString(ShissuNotebookMail_list))
  SGT_Notebook_MessagesRecipient_ButtonKick:SetText(getString(ShissuNotebookMail_choice))
  SGT_Notebook_MessagesRecipient_ButtonAllKick:SetText(getString(ShissuNotebookMail_list))  
  SGT_Notebook_MessagesRecipient_GuildsLabel:SetText(getString(Shissu_guild))
  SGT_Notebook_MessagesRecipient_RanksLabel:SetText(getString(Shissu_rank))
  SGT_Notebook_MessagesRecipient_OfflineSinceLabel:SetText(getString(ShissuNotebookMail_offlineSince))
  SGT_Notebook_MessagesRecipient_ChoiceLabel:SetText(getString(ShissuNotebookMail_choice))
  SGT_Notebook_MessagesRecipient_ButtonChoice:SetText(getString(ShissuNotebookMail_choice))
  SGT_Notebook_MessagesRecipient_ButtonAll:SetText(getString(ShissuNotebookMail_list))
  SGT_Notebook_MessagesRecipient_ButtonKick:SetText(getString(ShissuNotebookMail_choice))
  SGT_Notebook_MessagesRecipient_ButtonAllKick:SetText(getString(ShissuNotebookMail_list))
  SGT_Notebook_MessagesRecipient_EMailKickLabeChoice:SetText(green .. getString(ShissuNotebookMail_mailOn))
  SGT_Notebook_MessagesRecipient_EMailKickLabel:SetText(getString(ShissuNotebookMail_mailKick))
  SGT_Notebook_MessagesRecipient_FactionLabel:SetText(getString(ShissuNotebookMail_alliance))
  
  SGT_Notebook_Version:SetText(_addon.fN .. " " .. _addon.Version)
  SGT_MailProtocol_Version:SetText(_addon.fN .. " " .. _addon.Version)
  SGT_Notebook_Splash_Version:SetText(_addon.fN .. " " .. _addon.Version)
    
  setDefaultColor(SGT_Notebook_MessagesRecipient_Line)    
  setDefaultColor(SGT_Notebook_MessagesRecipient_Line2)  
  setDefaultColor(SGT_Notebook_MessagesRecipient_Line3)  
  setDefaultColor(SGT_Notebook_MessagesRecipient_Line4)  
  
  _mail.divider3 = createBlueLine("SGT_RecipientDivider", SGT_Notebook_MessagesRecipient, SGT_Notebook_MessagesRecipient_Line, 160)

  SGT_Notebook_MessagesRecipient_Add:SetHandler("OnMouseEnter", function() _addon.core.toolTip(self, ShissuNotebookMail_listPlayerAdd) end)
  SGT_Notebook_MessagesRecipient_Delete:SetHandler("OnMouseEnter", function() _addon.core.toolTip(self, ShissuNotebookMail_listPlayerRemove) end)
  SGT_Notebook_MessagesRecipient_BuildGroup:SetHandler("OnMouseEnter", function() _addon.core.toolTip(self, ShissuNotebookMail_listPlayerBuildGroup) end)
  SGT_Notebook_MessagesRecipient_NewList:SetHandler("OnMouseEnter", function() _addon.core.toolTip(self, ShissuNotebookMail_listAddRemove) end)
  SGT_Notebook_MessagesRecipient_StatusOnline:SetHandler("OnMouseEnter", function() _addon.core.toolTip(self, ShissuNotebookMail_online) end)
  SGT_Notebook_MessagesRecipient_StatusOffline:SetHandler("OnMouseEnter", function() _addon.core.toolTip(self, ShissuNotebookMail_offlineSince) end)
  SGT_Notebook_MessagesRecipient_ButtonChoice:SetHandler("OnMouseEnter", function() _addon.core.toolTip(self, ShissuNotebookMail_ttEMail) end)
  SGT_Notebook_MessagesRecipient_ButtonAll:SetHandler("OnMouseEnter", function() _addon.core.toolTip(self, ShissuNotebookMail_ttEMailList) end)
  SGT_Notebook_MessagesRecipient_EMailKickLabeChoice:SetHandler("OnMouseEnter", function() _addon.core.toolTip(self, ShissuNotebookMail_ttEMailKick) end)
  SGT_Notebook_MessagesRecipient_ButtonKick:SetHandler("OnMouseEnter", function() _addon.core.toolTip(self, ShissuNotebookMail_ttKick) end)
  SGT_Notebook_MessagesRecipient_ButtonAllKick:SetHandler("OnMouseEnter", function() _addon.core.toolTip(self, ShissuNotebookMail_ttKickList) end)
  SGT_MailProtocol_Ignore:SetHandler("OnMouseEnter", function() _addon.core.toolTip(self, ShissuNotebookMail_protocolIgnoreTT) end)
  SGT_Notebook_Splash_Continue:SetHandler("OnMouseEnter", function() _addon.core.toolTip(self, ShissuNotebookMail_ttContin) end)
  SGT_Notebook_Splash_Protocol:SetHandler("OnMouseEnter", function() _addon.core.toolTip(self, ShissuNotebookMail_protocolTT) end)  
                                                                       
  checkBoxLabel(SGT_Notebook_MessagesRecipient_StatusOnline, "Online")
  checkBoxLabel(SGT_Notebook_MessagesRecipient_StatusOffline, "Offline")
  checkBoxLabel(SGT_Notebook_MessagesRecipient_FactionAldmeri, "Aldmeri")
  checkBoxLabel(SGT_Notebook_MessagesRecipient_FactionEbonheart, "Ebonheart")
  checkBoxLabel(SGT_Notebook_MessagesRecipient_FactionDaggerfall, "Daggerfall")   
    
  _mail.checkBox(SGT_Notebook_MessagesRecipient_StatusOnline, "Online")
  _mail.checkBox(SGT_Notebook_MessagesRecipient_StatusOffline, "Offline") 
  _mail.checkBox(SGT_Notebook_MessagesRecipient_FactionAldmeri, "Aldmeri") 
  _mail.checkBox(SGT_Notebook_MessagesRecipient_FactionEbonheart, "Ebonheart") 
  _mail.checkBox(SGT_Notebook_MessagesRecipient_FactionDaggerfall, "Daggerfall") 

  SGT_Notebook_MessagesRecipient_EMailKickLabeChoice:SetHandler("OnMouseUp", _mail.labelMailKick)
  SGT_Notebook_MessagesRecipient_OfflineSince:SetHandler("OnMouseUp", _addon.core.offlineSince)
    
  SGT_Notebook_MessagesRecipient_NewList:SetHandler("OnMouseUp", _addon.core.newList)
  SGT_Notebook_MessagesRecipient_Add:SetHandler("OnMouseUp", _mail.addPlayerToList)
  SGT_Notebook_MessagesRecipient_Delete:SetHandler("OnMouseUp", _mail.deletePlayerfromList)
  SGT_Notebook_MessagesRecipient_BuildGroup:SetHandler("OnMouseUp", _mail.buildGroupWithList)  
  
  SGT_Notebook_MessagesRecipient_ButtonChoice:SetHandler("OnClicked", function() _mail.mailButtons(0, 0) end)
  SGT_Notebook_MessagesRecipient_ButtonAll:SetHandler("OnClicked", function() _mail.mailButtons(1, 0) end)
  SGT_Notebook_MessagesRecipient_ButtonKick:SetHandler("OnClicked", function() showDialog(GetString(SI_PROMPT_TITLE_GUILD_REMOVE_MEMBER), getString(ShissuNotebookMail_confirmKick), function() _mail.mailButtons(0, 1) end, nil) end)
  SGT_Notebook_MessagesRecipient_ButtonAllKick:SetHandler("OnClicked", function() showDialog(GetString(SI_PROMPT_TITLE_GUILD_REMOVE_MEMBER), getString(ShissuNotebookMail_confirmKick), function() _mail.mailButtons(1, 1) end, nil) end)

  
  -- DropDown Menü "Rank" befüllen
  SGT_Notebook_MessagesRecipient_Ranks:GetNamedChild("Dropdown"):SetWidth(140)
  SGT_Notebook_MessagesRecipient_Ranks:SetWidth(140)  
           
  _mail.dropDownRanks  = SGT_Notebook_MessagesRecipient_Ranks.dropdown
  _mail.dropDownRanks:SetSortsItems(false) 
  _mail.dropDownRanks:AddItem(_mail.dropDownRanks:CreateItemEntry(yellow .. "-- " .. white .. getString(ShissuNotebookMail_all2), _addon.core.optionSelected))
  
  for rankId = 1, GetNumGuildRanks(_mail.currentGuild) do
    _mail.dropDownRanks:AddItem(_mail.dropDownRanks:CreateItemEntry(white .. GetFinalGuildRankName(_mail.currentGuild, rankId), _mail.optionSelected))
  end  
  
  -- DropDown Menü "Gilde" befüllen   
  SGT_Notebook_MessagesRecipient_Guilds:GetNamedChild("Dropdown"):SetWidth(120)
  SGT_Notebook_MessagesRecipient_Guilds:SetWidth(120)  
  
  _mail.dropDownGuilds = SGT_Notebook_MessagesRecipient_Guilds.dropdown
  _mail.dropDownGuilds:SetSortsItems(false) 
  _mail.dropDownGuilds:AddItem(_mail.dropDownGuilds:CreateItemEntry(yellow .. _addon.friends, _mail.optionSelected))

  for guildId = 1, GetNumGuilds() do
    _mail.dropDownGuilds:AddItem(_mail.dropDownGuilds:CreateItemEntry(white .. GetGuildName(guildId), _mail.optionSelected))
  end  
  
  -- EmpfängerListe
  -- ScrollContainer + UI
  _mail.buildMailList()
  _mail.indexPool = ZO_ObjectPool:New(_mail.createIndexButton, _mail.removeIndexButton)
  _mail.list = createScrollContainer("SGT_Notebook_EMailList", 145, SGT_Notebook_MessagesRecipient, SGT_Notebook_MessagesRecipient_Line, 10, 10, -10)  
  _mail.selected = WINDOW_MANAGER:CreateControl(nil, _mail.list.scrollChild, CT_TEXTURE)
  _mail.selected:SetTexture("EsoUI\\Art\\Buttons\\generic_highlight.dds")
  setDefaultColor(_mail.selected)  
  _mail.selected:SetHidden(true)
  _mail.fillScrollList() 
   
  --Protocol Splash 
  SGT_MailProtocol_Version:SetText(_addon.fN .. " " .. _addon.Version)
  SGT_MailProtocol_Title:SetText(getString(ShissuNotebookMail_protocol))
  
  setDefaultColor(SGT_MailProtocol_Line)  
  setDefaultColor(SGT_Notebook_Splash_Line) 
                                      
  SGT_MailProtocol_Full:SetText(getString(ShissuNotebookMail_protocolFull))
  SGT_MailProtocol_Ignore:SetText(getString(ShissuNotebookMail_protocolIgnore))  
  
  SGT_Notebook_Splash_SubjectLabel:SetText(getString(ShissuNotebookMail_splashSubject) .. ":")
  SGT_Notebook_Splash_ProgressLabel:SetText(getString(ShissuNotebookMail_splashProgress) .. ":")

  SGT_Notebook_Splash_Continue:SetHandler("OnClicked", _mail.mailContinue)
  SGT_Notebook_Splash_Protocol:SetHandler("OnClicked", _mail.mailProtocol)

  _mail.divider2 = createBlueLine("SGT_ProtocolDivider", SGT_MailProtocol, SGT_MailProtocol_Line, 160)

  -- Schließen Button NEU
  _mail.closeProtocolButton = createCloseButton("SGT_MailProtocol_Close", SGT_MailProtocol, function() SGT_MailProtocol:SetHidden(true) end)
  _mail.closeSplashButton = createCloseButton("SGT_Notebook_Splash_Close", SGT_Notebook_Splash, _mail.mailAbort)
  _mail.closeSplashButton:SetHandler("OnMouseEnter", function(self) 
    setDefaultColor(self)     
    _addon.core.toolTip(SGT_Notebook_Splash_Close, ShissuNotebookMail_mailAbort)
  end)
  _mail.closeSplashButton:SetHandler("OnMouseExit", function(self) 
    ZO_Tooltips_HideTextTooltip()
    self:SetColor(1,1,1,1)
  end)  
  _mail.closeSplashButton:SetHandler("OnMouseUp", _mail.mailAbort)  

  -- Protocol ScrollContainer
  _mail.protocolFullIndexPool = ZO_ObjectPool:New(_mail.protocolCreateIndexButton, _mail.removeIndexButton)
  _mail.ProtocolList.Full = createScrollContainer("SGT_Notebook_FullList", 145, SGT_MailProtocol, SGT_MailProtocol_Line, 10, 40, -10)  
  _mail.protocolIgnoreIndexPool = ZO_ObjectPool:New(_mail.protocolCreateIndexButton, _mail.removeIndexButton)
  _mail.ProtocolList.Ignore = createScrollContainer("SGT_Notebook_IgnoreList", 145, SGT_MailProtocol, SGT_MailProtocol_Line, 175, 40, -10)  

  SGT_Notebook_MessagesRecipient:SetHidden(false) 
end

function _addon.core.toolTip(control, text)
  ZO_Tooltips_ShowTextTooltip(control, TOPRIGHT, white .. getString(text))
end
             
function _addon.core.getGuildNote(memberId)
  local memberVar = { GetGuildMemberInfo(_ui.currentGuild, memberId) }
  
  if memberVar then 
    return memberVar[2]
  end
  
  return false
end
                                               
-- Initialisierung
function _addon.core.initialized()                          
  shissuGT.mailList = shissuGT.mailList or {}
  _mail.customList = shissuGT.mailList

  if (_addon.settings["position_1"] == nil) then
    _addon.settings["position_1"] = {}
  end
  
  if (_addon.settings["position_2"] == nil) then
    _addon.settings["position_2"] = {}
  end
    
  saveWindowPosition(SGT_MailProtocol, _addon.settings["position_1"])
  getWindowPosition(SGT_MailProtocol, _addon.settings["position_1"])
  
  saveWindowPosition(SGT_Notebook_Splash, _addon.settings["position_2"])
  getWindowPosition(SGT_Notebook_Splash, _addon.settings["position_2"])

  zo_callLater(_addon.core.mail, 5000)
end            

-- EVENT FUNCTIONS
function _mail.EVENT_MAIL_SEND_SUCCESS()
  _mail.recipientName = ""
  _mail.isSend = true
end
                        
function _mail.EVENT_MAIL_SEND_FAILED(event, reason) 
  local CN = _addon.fN .. ": " .. getString(ShissuNotebookMail_newMail) .. " - " .. orange
  local CT = orange.. " - "
  
  _mail.isSend = true

  if reason == MAIL_SEND_RESULT_FAIL_INVALID_NAME or reason == MAIL_SEND_RESULT_RECIPIENT_NOT_FOUND then d(CN .. GetString(SI_SENDMAILRESULT2).. CT .. _mail.recipientName)
  elseif reason == MAIL_SEND_RESULT_FAIL_BLANK_MAIL then d(CN.. getString(ShissuNotebookMail_ERR_FAIL_BLANK_MAIL))
  elseif reason == MAIL_SEND_RESULT_NOT_ENOUGH_MONEY then d(CN.. GetString(SI_SENDMAILRESULT5))
  elseif reason == MAIL_SEND_RESULT_FAIL_MAILBOX_FULL then 
    d(CN.. GetString(SI_SENDMAILRESULT3).. CT .. _mail.recipientName)
    table.insert(_mail.emailError.full, _mail.recipientName)
  elseif reason == MAIL_SEND_RESULT_FAIL_IGNORED then 
    d(CN.. GetString(SI_SENDMAILRESULT4).. CT .. _mail.recipientName) 
    table.insert(_mail.emailError.ignore, _mail.recipientName)
  elseif reason == MAIL_SEND_RESULT_FAIL_DB_ERROR or reason == MAIL_SEND_RESULT_FAIL_IN_PROGRESS then d(CN.. GetString(SI_SENDMAILRESULT1))    
  end 
end

function _mail.EVENT_MAIL_CLOSE_MAILBOX()
  _mail.emailIsOpen = false
end   

function _mail.EVENT_MAIL_OPEN_MAILBOX()
  _mail.emailIsOpen = true  
end    

-- EVENTS
EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_MAIL_CLOSE_MAILBOX, _mail.EVENT_MAIL_CLOSE_MAILBOX)
EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_MAIL_SEND_FAILED, _mail.EVENT_MAIL_SEND_FAILED)
EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_MAIL_SEND_SUCCESS, _mail.EVENT_MAIL_SEND_SUCCESS)
EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_MAIL_OPEN_MAILBOX, _mail.EVENT_MAIL_OPEN_MAILBOX)                   
 
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized    
