Pay.setup do |config|
  config.default_product_name = 'Sailing Club Membership'
  config.enabled_processors = [:stripe]
  config.application_name = 'Sheffield Viking Sailing Club'
  config.support_email = 'membership@sheffieldviking.org.uk'

  # Use credentials from your encrypted credentials file
  # config.stripe.secret_key = Rails.application.credentials.dig(:stripe, :private_key)
  # config.stripe.public_key = Rails.application.credentials.dig(:stripe, :public_key)

  # Set default currency to GBP
  # config.currency = "gbp"
  #

  # Customize mail() arguments. By default, only includes { to: }. Useful when you want to add cc, bcc, customize the mail subject, etc.
  # config.mail_arguments = lambda { |mailer, params|
  #   {
  #     to: Pay.mail_recipients.call(mailer, params),
  #     bcc: ['membership@sheffieldviking.org.uk', 'svscrenewals@cowlibob.co.uk']
  #   }
  # }
end

ActiveSupport.on_load(:pay) do
  Pay::Webhooks.delegator.subscribe 'stripe.charge.succeeded', ChargeSucceededProcessor.new
end
