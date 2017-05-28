-- Shissu GuildTools Module File
--------------------------------
-- File: notebook.lua
-- Version: v2.1.5
-- Last Update: 10.03.2017
-- Written by Christian Flory (@Shissu) - esoui@flory.one
-- Distribution without license is prohibited!

-- AutoPost BugFix

local _globals = Shissu_SuiteManager._globals
local white = _globals["color"]["white"]
local blue = _globals["color"]["blue"]
local orange = _globals["color"]["orange"]

local _lib = Shissu_SuiteManager._lib
local _SGT = Shissu_SuiteManager._lib["SGT"]
local cutStringAtLetter = _lib.cutStringAtLetter
local setDefaultColor = _SGT.setDefaultColor
local RGBtoHex = _SGT.RGBtoHex
local createBlueLine = _SGT.createBlueLine
local createCloseButton = _SGT.createCloseButton
local createScrollContainer = _SGT.createScrollContainer
local showDialog = _SGT.showDialog
local getString = _SGT.getString
local getWindowPosition = _SGT.getWindowPosition
local saveWindowPosition = _SGT.saveWindowPosition

local _addon = {}
_addon.Name	= "ShissuNotebook"
_addon.Version = "2.1.5"
_addon.core = {}
_addon.fN = _SGT["title"](getString(ShissuNotebook))
_addon.hexColorPicker = nil

_addon.settings = {
  ["position"] = {},
}        

local _color = { 
  "|ceeeeee",
  "|ceeeeee", 
  "|ceeeeee",
  "|ceeeeee",
  "|ceeeeee",
  ["W"] = "|ceeeeee",
}

local _ui = {}

local _note = {}
_note.scrollItem = 1
_note.indexPool = nil
_note.list = nil
_note.lastFocus = nil
_note.currentID = nil
_note.data = nil
_note.cache = {}
_note.autoPost = false
_note.command = ""

-- Notebook
function _note.setControlToolTip(control)
  control:SetHandler("OnMouseEnter", function(self) 
    if control:GetText() ~= "" then ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, control:GetText()) end
  end)
  
  control:SetHandler("OnMouseExit", function(self) ZO_Tooltips_HideTextTooltip() end)
end

function _note.createIndexButton(indexPool)
  local control = ZO_ObjectPool_CreateControl("SGT_Notebook_Index", indexPool, _note.list.scrollChild)
  local anchorBtn = _note.scrollItem == 1 and _note.list.scrollChild or indexPool:AcquireObject(_note.scrollItem-1)
  
  control:SetAnchor(TOPLEFT, anchorBtn, _note.scrollItem == 1 and TOPLEFT or BOTTOMLEFT)
  control:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
  control:SetWidth(180)
  control:SetHandler("OnMouseUp", function(self, button)
    _note.selected:SetHidden(false)
    _note.selected:ClearAnchors()
    _note.selected:SetAnchorFill(self)      
    _note.currentID = self.ID

    SGT_Notebook_NoteTitleText:SetText(self.noteTitle) 
    SGT_Notebook_NoteText:SetText(self.text)
    SGT_Notebook_SlashText:SetText(self.command) 
    SGT_Notebook_AutoStringText:SetText(self.autoString)

    if self.autopost then ZO_CheckButton_SetChecked(SGT_Notebook_AutoStringEnabled)
    else ZO_CheckButton_SetUnchecked(SGT_Notebook_AutoStringEnabled) end

    -- Rückgängig machen - Cache
    _note.cache.title = self.noteTitle
    _note.cache.text = self.text
    _note.cache.autoString = self.autoString
    if (_note.cache.autoPost) then
      _note.cache.autoPost = _note.autoPost
    end
    
    _note.cache.command = _note.command
    
    if button == 2 then
      --SGT.NoteDelete()
    end
  end)
  
  control:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, white .. self.noteTitle) end)
  control:SetHandler("OnMouseExit", function(self) ZO_Tooltips_HideTextTooltip() end)  

  _note.scrollItem = _note.scrollItem  + 1
  
  return control
end

function _note.removeIndexButton(control)
  control:SetHidden(true)
end

function _note.fillScrollList()
  local numPages = #_note.data
  local sortedTitle = {}
  local sortedData = {}
  _addon.core.getColor()
  for i = 1, numPages do
    table.insert(sortedTitle, i, _note.data[i].title .. "**shissu" ..i)
  end
  
  table.sort(sortedTitle)
  
  for i = 1, numPages do
    local length = string.len(sortedTitle[i])
    local number = string.sub(sortedTitle[i], string.find(sortedTitle[i], "**shissu"), length)
    
    number = string.gsub(number, "**shissu", "")
    number = string.gsub(number, " ", "")
    number = tonumber(number)

    sortedData[i] = {}
    sortedData[i].title = _note.data[number].title
    sortedData[i].text = _note.data[number].text
    sortedData[i].autoString = _note.data[number].autostring
    sortedData[i].autopost = _note.data[number].autopost
    sortedData[i].command = _note.data[number].command
    sortedData[i].number = number
  end

  for i = 1, numPages do
    local control = _note.indexPool:AcquireObject(i)
    control.noteTitle = sortedData[i].title
    control.text = sortedData[i].text
    control.ID = sortedData[i].number
    control.autoString = sortedData[i].autoString
    control.autopost = sortedData[i].autopost
    control.command = sortedData[i].command
    control:SetText(white .. sortedData[i].title)
    control:SetHidden(false)
  end
  
  local activePages = _note.indexPool:GetActiveObjectCount()
  if activePages > numPages then
    for i = numPages+1, activePages do _note.indexPool:ReleaseObject(i) end
  end
end

function _addon.core.selectColor(color)
  if (_note.lastFocus ~= nil) then
    local currentText = _note.lastFocus:GetText()
    local addText = ""
  
    if color == "ANY" then
      local htmlString
  
      local function ColorPickerCallback(r, g, b, a)
        htmlString = RGBtoHex(r,g,b)
      end    
      
      local ZOS_BUTTON = ESO_Dialogs.COLOR_PICKER["buttons"][1].callback
     
      ESO_Dialogs.COLOR_PICKER["buttons"][1].callback = function() 
        local cache = SGT_Notebook_NoteText:GetText()
        _note.lastFocus:SetText(currentText .. "|c" .. htmlString .. getString(Shissu_yourText) .. "|r")
        
        ESO_Dialogs.COLOR_PICKER["buttons"][1].callback = ZOS_BUTTON
      end
      
      COLOR_PICKER:Show(ColorPickerCallback, r, g, b, a, "Farbe")
    else
      _note.lastFocus:SetText(currentText .. _color[color] .. getString(Shissu_yourText) .. "|r")
    end
  end
end

function _note.onTextChanged()
  local control = SGT_Notebook_NoteLength
  local length = string.len(SGT_Notebook_NoteText:GetText())

  if length > 700 then control:SetText(getString(Shissu_mail) .. " " .. orange .. length .. "|r/700")
  elseif length > 400 then control:SetText(getString(Shissu_chat) .. " " .. blue .. length .. "|r/700") 
  elseif length > 350 then control:SetText(getString(Shissu_chat) .. " " .. blue .. length .. "|r/350")
  else control:SetText(getString(Shissu_chat) .. " " .. length .. "/350")
  end
end

function _note.new() 
  _note.clearAllElements()
  _note.cache.title = nil
  _note.currentID = nil
  
  SGT_Notebook_NoteTitleText:SetText(":-)")
  SGT_Notebook_NoteTitleText:TakeFocus()
end  

function _note.clearAllElements()
  SGT_Notebook_NoteTitleText:Clear()
  SGT_Notebook_NoteText:Clear()
  SGT_Notebook_AutoStringText:Clear()
  SGT_Notebook_SlashText:Clear()
  ZO_CheckButton_SetUnchecked(SGT_Notebook_AutoStringEnabled)
end

function _note.delete()
  if _note.currentID ~= nil then
    showDialog(getString(ShissuNotebook_ttDelete), getString(ShissuNotebook_ttDelete) .. ": " .. _note.data[_note.currentID].title, function()
      table.remove(_note.data, _note.currentID)
      _note.clearAllElements()   
      _note.fillScrollList()
    end, nil)
  end
end

function _note.sendTo(self, button)
  if button == 1 then CHAT_SYSTEM:StartTextEntry(SGT_Notebook_NoteText:GetText()) 
  elseif button == 2 then _note.save()
  elseif button == 3 then
    SCENE_MANAGER:Show('mailSend')
    ZO_MailSendBodyField:SetText(SGT_Notebook_NoteText:GetText())
    ZO_MailSendSubjectField:SetText(SGT_Notebook_NoteTitleText:GetText())
    ZO_MailSendBodyField:TakeFocus()  
  end
end

function _note.save()
  local noteTitle = SGT_Notebook_NoteTitleText:GetText()
  local noteText = SGT_Notebook_NoteText:GetText()
  local noteSlashCommand = SGT_Notebook_SlashText:GetText()
  local noteAutoPost = SGT_Notebook_AutoStringText:GetText()

  if _note.currentID == nil then
    table.insert(_note.data, {["title"] = noteTitle, ["text"] = noteText, ["command"] = noteSlashCommand, ["autopost"]= _note.autoPost, ["autostring"] = noteAutoPost})
    _note.currentID = #_note.data
  else
    if (_note.data[_note.currentID] ~= nil) then  
      _note.data[_note.currentID].title = noteTitle
      _note.data[_note.currentID].text = noteText
      _note.data[_note.currentID].command = noteSlashCommand
      _note.data[_note.currentID].autopost = _note.autoPost
      _note.data[_note.currentID].autostring = noteAutoPost 
    end
  end
      
  _note.fillScrollList()
end

function _note.undo()
  if _note.cache.title ~= nil then
    SGT_Notebook_NoteTitleText:SetText(_note.cache.title) 
    SGT_Notebook_NoteText:SetText(_note.cache.text)
    SGT_Notebook_SlashText:SetText(_note.cache.command) 
    SGT_Notebook_AutoStringText:SetText(_note.cache.autoString) 
      
    if _note.cache.autopost then ZO_CheckButton_SetChecked(SGT_Notebook_AutoStringEnabled)
    else ZO_CheckButton_SetUnchecked(SGT_Notebook_AutoStringEnabled) end
  end
end

function _addon.core.createBackdropBackground(mainParent, mainParent2, dimensions, tex)
  if (tex == nil) then tex = "" end
  
  local control = CreateControl(mainParent .. "_BG", mainParent2, CT_TEXTURE)
	control:SetTexture("ShissuGuildTools/textures/backdrop" .. tex .. ".dds")
	control:SetDimensions(dimensions[1], dimensions[2])  
	control:SetAnchor(TOPLEFT, mainParent2, TOPLEFT, 0, 0)
	control:SetDrawLayer(1)
	--control:SetExcludeFromResizeToFitExtents(true)        
end

function _addon.core.getColor()
  if (shissuGT["ShissuColor"] ~= nil) then
    for i = 1, 5 do
      if (shissuGT["ShissuColor"]["c" .. i] ~= nil) then
        _color[i] = "|c" .. RGBtoHex(shissuGT["ShissuColor"]["c" .. i][1], shissuGT["ShissuColor"]["c" .. i][2], shissuGT["ShissuColor"]["c" .. i][3]) 
      end
    end
  end
end

-- Notebook UI
function _addon.core.notebook()
  _SGT.createFlatWindow(
    "SGT_Notebook",
    SGT_Notebook,  
    {640, 480}, 
    function() 
      SGT_Notebook:SetHidden(true) 
      
      if (SGT_Notebook_MessagesRecipient) then
        SGT_Notebook_MessagesRecipient:SetHidden(true)
     end
    end,
    
    getString(ShissuNotebook)
  ) 
  
  _ui.divider = _SGT.createLine("Divider", {400, 1}, "SGT_Notebook", SGT_Notebook,  TOPLEFT, 200, 50, {BOTTOMLEFT, 200, -20}, {0.49019607901573, 0.74117648601532, 1}, true)
  _ui.background1 = _addon.core.createBackdropBackground("SGT_Notebook_NoteTitle", SGT_Notebook_NoteTitle, {290, 30})
  _ui.background2 = _addon.core.createBackdropBackground("SGT_Notebook_Note", SGT_Notebook_Note, {420, 230}, 2)
  _ui.background3 = _addon.core.createBackdropBackground("SGT_Notebook_AutoString", SGT_Notebook_AutoString, {290, 30})
  _ui.background4 = _addon.core.createBackdropBackground("SGT_Notebook_Slash", SGT_Notebook_Slash, {290, 30})

  -- ScrollContainer + UI
  _note.indexPool = ZO_ObjectPool:New(_note.createIndexButton, _note.removeIndexButton) 
  _note.list = createScrollContainer("SGT_Notebook_List", 185, SGT_Notebook, SGT_Notebook_Line2, 10, 10, -10)

  _note.selected = WINDOW_MANAGER:CreateControl(nil, _note.list.scrollChild, CT_TEXTURE)
  _note.selected:SetTexture("EsoUI\\Art\\Buttons\\generic_highlight.dds")
  _note.selected:SetHidden(true)
  setDefaultColor(_note.selected)
  
  -- Allgemeine Formatierungen
  SGT_Notebook_NoteText:SetMaxInputChars(30000)
  SGT_Notebook_SlashText:SetMaxInputChars(24)
  SGT_Notebook_SlashInfo:SetText(getString(ShissuNotebook_slash))
  SGT_Notebook_Version:SetText(_addon.fN .. " " .. _addon.Version)
  
  _addon.core.getColor()

  local color = {}
    
  SGT_Notebook_NoteText:SetHandler("OnFocusGained", function(self) _note.lastFocus = self end)
  SGT_Notebook_NoteTitleText:SetHandler("OnFocusGained", function(self) _note.lastFocus = self end)
  SGT_Notebook_NoteText:SetHandler("OnTextChanged",_note.onTextChanged)
  SGT_Notebook_New:SetHandler("OnClicked", _note.new)
  SGT_Notebook_New:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, getString(ShissuNotebook_ttNew)) end)
  SGT_Notebook_Delete:SetHandler("OnClicked", _note.delete)
  SGT_Notebook_Delete:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, getString(ShissuNotebook_ttDelete)) end)
  SGT_Notebook_SendTo:SetHandler("OnMouseUp", _note.sendTo) 
  SGT_Notebook_SendTo:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, getString(ShissuNotebook_ttSendTo)) end)
  SGT_Notebook_Undo:SetHandler("OnMouseUp", _note.undo) 
  SGT_Notebook_Undo:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, TOPRIGHT, getString(ShissuNotebook_ttUndo)) end)

  SGT_Notebook_SlashText:SetHandler("OnEnter", function(self) self:LoseFocus() _note.save() end)     
  SGT_Notebook_SlashText:SetHandler("OnTextChanged", function() 
    local text = SGT_Notebook_SlashText:GetText()
    
    if (string.len(text) > 0) then
      ZO_Tooltips_ShowTextTooltip(self, BOTTOMRIGHT, blue .. "/note " .. white .. text)
    else
      ZO_Tooltips_HideTextTooltip()
    end
    
    _note.onTextChanged()
  end) 

  ZO_CheckButton_SetLabelText(SGT_Notebook_AutoStringEnabled, white .. "Auto Post")
  ZO_CheckButton_SetToggleFunction(SGT_Notebook_AutoStringEnabled, function(control, checked) _note.autoPost = checked end)
  
  
  _note.setControlToolTip(SGT_Notebook_NoteTitleText)                                                                                    
  _note.setControlToolTip(SGT_Notebook_NoteText) 
  
  _note.fillScrollList()
end

function _addon.core.autoPost(_, channelType, fromName, text, isCustomerService, fromDisplayName)
  if text == nil then return false end
  
  local currentText = CHAT_SYSTEM.textEntry:GetText()
  local channelInfo = ZO_ChatSystem_GetChannelInfo()[channelType]
  
  if (channelInfo.switches ~= nil) then
    local channelString  = string.sub(channelInfo.switches, 1, string.find(channelInfo.switches, " "))

    if string.len(currentText) < 1 then
      local pages = #_note.data
    
      for i = 1, pages do
        local note = _note.data[i]
        
        if note.autopost then   
          if (note.autostring ~= nil) then
            if (string.len(note.autostring) > 1) then
              -- Mehrere getrennte Wörter in den jeweiligen Strings
              if string.find (note.autostring, " ") or string.find (text, " ")  then
                for singleString in string.gmatch(note.autostring, "%a+") do 
                  for singleString2 in string.gmatch(text, "%a+") do 
                    if string.lower(singleString) == string.lower(singleString2) then
                      CHAT_SYSTEM:StartTextEntry(channelString .. "")
                      CHAT_SYSTEM:StartTextEntry(note.text)
                      return true
                    end
                  end
                end
                
              else
                if string.lower(text) == string.lower(note.autostring) then  
                  CHAT_SYSTEM:StartTextEntry(channelString .. "")
                  CHAT_SYSTEM:StartTextEntry(note.text)
                  return true
                end
              end              
            end
          end
        end 
      end
    end
  end
end

function _addon.core.cmdSlash(cmd)
  if (cmd == nil) then return end
  if ( _note.data == nil ) then return end

  local pages = #_note.data
                     
  for i = 1, pages do
    local note = _note.data[i]
           
    if string.lower(cmd) == string.lower(note.command) then
      if string.len(note.text) > 1 then
        CHAT_SYSTEM:StartTextEntry(note.text)
      else
        d(getString(ShissuNotebook_noSlash))
      end
      return true
    end 
  end
end
                                             
-- Initialisierung
function _addon.core.initialized()
  shissuGT[_addon.Name] = shissuGT[_addon.Name] or _addon.settings
  _addon.settings = shissuGT[_addon.Name]
  
  shissuGT.Notes = shissuGT.Notes or {}
  _note.data = shissuGT.Notes
                               
  _addon.core.notebook()
  EVENT_MANAGER:RegisterForEvent(_addon.Name, EVENT_CHAT_MESSAGE_CHANNEL, _addon.core.autoPost)
  
  if (_addon.settings["position"] == nil) then
    _addon.settings["position"] = {}
  end
  
  saveWindowPosition(SGT_Notebook, _addon.settings["position"])
  getWindowPosition(SGT_Notebook, _addon.settings["position"])
    
  -- Slash Command                                                                 
  Shissu_SuiteManager._commands[_addon.Name] = {} 
  table.insert(Shissu_SuiteManager._commands[_addon.Name], { "note" , _addon.core.cmdSlash })
  table.insert(Shissu_SuiteManager._commands[_addon.Name], { "no" , _addon.core.cmdSlash })  
  table.insert(Shissu_SuiteManager._commands[_addon.Name], { "notebook" , function() 
   -- SGT_Notebook:SetHidden(false) 
    
  --  if SGT_Notebook_MessagesRecipient then
   --   SGT_Notebook_MessagesRecipient:SetHidden(false)
  --  end
  end })            
end                               
 
Shissu_SuiteManager._init[_addon.Name] = _addon.core.initialized