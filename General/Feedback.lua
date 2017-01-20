-- File: Bindings.lua
-- Zuletzt geändert: 01. September 2015

function ShissuGT.SendFeeback(Gold)
  SGT_Feedback:SetHidden(true)
  SCENE_MANAGER:Show('mailSend')
  ZO_MailSendToField:SetText("@Shissu")
  ZO_MailSendBodyField:SetText(ShissuGT.Lib.ReplaceCharacter(ShissuGT.i18n.Feedback[1]))
  ZO_MailSendSubjectField:SetText("Shissu's Guild Tools")
  QueueMoneyAttachment(Gold)
  ZO_MailSendBodyField:TakeFocus()  
end
