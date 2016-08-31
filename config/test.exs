use Mix.Config

config :recaptcha,
  http_client: Recaptcha.Http.MockClient,
  secret: "test_secret",
  public_key: "test_public_key"
