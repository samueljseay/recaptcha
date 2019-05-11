use Mix.Config

config :recaptcha,
  verify_url: "https://www.google.com/recaptcha/api/siteverify",
  timeout: 5000,
  public_key: {:system, "RECAPTCHA_PUBLIC_KEY"},
  secret: {:system, "RECAPTCHA_PRIVATE_KEY"}

  config :recaptcha, :json_library, Poison

import_config "#{Mix.env()}.exs"
