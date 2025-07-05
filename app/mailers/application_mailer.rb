class ApplicationMailer < ActionMailer::Base
  default from: 'renewals@email.sheffieldviking.org.uk', reply_to: 'membership@sheffieldviking.org.uk'
  layout 'mailer'

  def mail(headers = {}, &block)
    notification_type = headers.delete(:notification_type)
    return unless should_send?(notification_type: notification_type, headers: headers)

    super
    log_send(notification_type: notification_type, headers: headers)
  end

  private

  def should_send?(notification_type:, headers:)
    true
  end

  def log_send(notification_type:, headers:)
  end
end
