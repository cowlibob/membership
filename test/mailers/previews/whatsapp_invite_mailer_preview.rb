# Preview all emails at http://localhost:3000/rails/mailers/whatsapp_invite_mailer
class WhatsappInviteMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/whatsapp_invite_mailer/invite_member
  def invite_member
    WhatsappInviteMailer.invite_member
  end
end
