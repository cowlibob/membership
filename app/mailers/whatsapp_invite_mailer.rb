class WhatsappInviteMailer < ApplicationMailer
  def invite_member(member)
    @member = member
    @whatsapp_url = "https://chat.whatsapp.com/EITBA95mLOtDuRMtHbyTFM"

    mail(
      to: @member.email,
      subject: "Welcome to Sheffield Viking Sailing Club - Join our WhatsApp Group!"
    )
  end
end
