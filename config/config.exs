use Mix.Config

config :recaptcha, :api_config,
                 %{ verify_url: "https://www.google.com/recaptcha/api/siteverify",
                    public_key: "YOUR PUBLIC KEY",
                    private_key: "YOUR PRIVATE KEY"
                  }
