class ApplicationMailer < ActionMailer::Base
  default from: 'renewals@email.sheffieldviking.org.uk', reply_to: 'membership@sheffieldviking.org.uk'
  layout 'mailer'
end

