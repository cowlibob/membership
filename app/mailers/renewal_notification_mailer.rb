class RenewalNotificationMailer < ApplicationMailer
  def new_renewal_member(renewal)
    @renewal = renewal
    mail to: @renewal.primary_member.email, subject: 'Your SVSC Member Renewal',
         notification_type: 'new_renewal_member', bcc: ['membership@sheffieldviking.org.uk', 'svscrenewals@cowlibob.co.uk']
  end

  def new_renewal_admin(renewal)
    @renewal = renewal
    mail to: ['membership@sheffieldviking.org.uk'], subject: 'SVSC - New Member Renewal',
         notification_type: 'new_renewal_admin', bcc: ['svscrenewals@cowlibob.co.uk']
  end

  def renewal_payment_pending(renewal)
    @renewal = renewal
    mail to: @renewal.primary_member.email, subject: 'SVSC Member Renewal - Payment Pending',
         notification_type: 'renewal_payment_pending', bcc: ['membership@sheffieldviking.org.uk', 'svscrenewals@cowlibob.co.uk']
  end

  def renewal_paid_by_bank_transfer(renewal)
    @renewal = renewal
    mail to: @renewal.primary_member.email, subject: 'SVSC Member Renewal - Paid by Bank Transfer',
         notification_type: 'renewal_paid_by_bank_transfer', bcc: ['membership@sheffieldviking.org.uk', 'svscrenewals@cowlibob.co.uk']
  end

  def renewal_payment_confirmation(renewal)
    @renewal = renewal
    mail to: @renewal.primary_member.email, subject: 'SVSC Member Renewal - Payment Confirmation',
         notification_type: 'renewal_payment_confirmation', bcc: ['membership@sheffieldviking.org.uk', 'svscrenewals@cowlibob.co.uk']
  end

  def renewal_reminder(renewal)
    @renewal = renewal
    mail to: @renewal.primary_member.email, subject: 'Your SVSC Member Renewal - Continue Where You Left Off',
         notification_type: 'renewal_reminder', bcc: ['membership@sheffieldviking.org.uk', 'svscrenewals@cowlibob.co.uk']
  end

  private

  def should_send?(notification_type:, headers:)
    log = NotificationLog.find_by(recipient: headers[:to], notification_type: notification_type,
                                  renewal_id: @renewal.id)
    if log.nil?
      Rails.logger.info "Email not previously sent: #{notification_type} to #{headers[:to]}"
      true
    else
      Rails.logger.info "Email previously sent: #{notification_type} to #{headers[:to]}"
      false
    end
  end

  def log_send(notification_type:, headers:)
    NotificationLog.create!(recipient: headers[:to], notification_type: notification_type,
                            subject: headers[:subject], sent_at: Time.now.utc, renewal_id: @renewal.id)
  end
end
