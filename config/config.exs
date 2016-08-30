use Mix.Config

config :recaptcha,
  verify_url: "https://www.google.com/recaptcha/api/siteverify",
  timeout: 5000,
  public_key: System.get_env("RECAPTCHA_PUBLIC_KEY"),
  private_key: System.get_env("RECAPTCHA_PRIVATE_KEY")
