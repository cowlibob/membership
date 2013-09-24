# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Membership::Application.config.secret_key_base = '4f909a519d2f45cd5e4c6dd6f4b2c58f5da72b5809280a5ab19b8e87fd78cbe547c55de4df28b3c8ece38020f6ed11523d2fe1a70ae7c0f131863acb46d18907'
