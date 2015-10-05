# Recaptcha

A simple Elixir package for implementing [reCAPTCHA] in [Phoenix] applications.

[reCAPTCHA]: http://www.google.com/recaptcha
[Phoenix]: http://www.phoenixframework.org/

## Installation

1. Add recaptcha to your `mix.exs` dependencies

```elixir
  defp deps do
    [
      {:recaptcha, "~> 1.1.0"},      
    ]
  end
```

2. List `:recaptcha` as an application dependency

```elixir
  def application do
    [ applications: [:phoenix, :recaptcha] ]
  end
```

3. Run `mix do deps.get, compile`

## Config

Set default public and private keys in your application's config.exs

```elixir
  config :recaptcha,
    api_config: %{ verify_url: "https://www.google.com/recaptcha/api/siteverify",
                 public_key: "YOUR_PUBLIC_KEY",
                 private_key: "YOUR_PRIVATE_KEY" }
```

## Usage

### View

Use `raw` and `Recaptcha.display` methods to render the captcha

```html
<form name="someform" method="post" action="/somewhere">
  ...
  <%= raw Recaptcha.display %>
  ...
</form>
```

`display` method accepts additional options as a keyword list, the options are:

Option                  | Action                                                 | Default
:---------------------- | :----------------------------------------------------- | :------------------------
`noscript`              | Renders default noscript code provided by google       | `false`
`public_key`            | Sets key to the `data-sitekey` reCaptcha div attribute | Public key from the config file



### Controller

Recaptcha provides `verify` method, that can be used like this:

```elixir
  def create(conn, params) do
    # some code  
    case Recaptcha.verify(conn.remote_ip, params["g-recaptcha-response"]) do
      :ok -> do_something
      :error -> handle_error
    end
  end
```

`verify` method sends a `POST` request to the reCAPTCHA API and returns 2 possible values:

`:ok` -> The captcha is valid

`:error` -> Server returned `missing-input-response` or `invalid-input-response` error codes

If the server returns `missing-input-secret` or `invalid-input-secret`, `RuntimeError` is raised


`verify` method also accepts a keyword list as the third parameter with the following options:

Option                  | Action                                                 | Default
:---------------------- | :----------------------------------------------------- | :------------------------
`timeout`               | Time to wait before timeout                            | 3000 (ms)
`private_key`           | Private key to send as a parameter of the API request  | Private key from the config file

## Contributing

* Fork the project.
* Make your feature addition or bug fix.
* Commit
* Send me a pull request

## License

[MIT License](http://www.opensource.org/licenses/MIT).
