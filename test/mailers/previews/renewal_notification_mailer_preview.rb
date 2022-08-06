# Preview all emails at http://localhost:3000/rails/mailers/renewal_notification_mailer
class RenewalNotificationMailerPreview < ActionMailer::Preview
  def new_renewal_admin
    RenewalNotificationMailer.new_renewal_admin(Renewal.last)
  end

  def new_renewal_member
    RenewalNotificationMailer.new_renewal_member(Renewal.last)
  end

end
