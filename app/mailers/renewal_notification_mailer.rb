class RenewalNotificationMailer < ApplicationMailer

  def new_renewal_member(renewal)
    @renewal = renewal
    mail to: @renewal.primary_member.email, subject: "Your SVSC Member Renewal"
  end

  def renewal_payment_confirmation(renewal)
    @renewal = renewal
    mail to: @renewal.primary_member.email, subject: "SVSC Member Renewal Payment Confirmation"
  end

  def new_renewal_admin(renewal)
    @renewal = renewal
    mail to: ['james@cowlibob.co.uk', 'membership@sheffieldviking.org.uk'], subject: "SVSC - New Member Renewal"
  end

end
