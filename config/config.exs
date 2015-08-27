use Mix.Config

config :recaptcha, :api_config,
                 %{ verify_url: "https://www.google.com/recaptcha/api/siteverify",
                    public_key: "YOUR_PUBLIC_KEY",
                    private_key: "YOUR_PRIVATE_KEY"
                  }
