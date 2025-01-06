Pay.setup do |config|
  config.default_product_name = "Sailing Club Membership"
  config.enabled_processors = [:stripe]

  # Use credentials from your encrypted credentials file
  # config.stripe.secret_key = Rails.application.credentials.dig(:stripe, :private_key)
  # config.stripe.public_key = Rails.application.credentials.dig(:stripe, :public_key)

  # Set default currency to GBP
  # config.currency = "gbp"
end