# Recaptcha

A simple Elixir package for implementing [reCAPTCHA] in [Elixir] applications.

[reCAPTCHA]: http://www.google.com/recaptcha

## Migration from 1.x

There are several breaking changes in recaptcha version 2.

The 2 most obvious are that templating is now in a separate module: `Recaptcha.Template` the `display/1` API however, has not changed. In future templating may be moved to a Phoenix specific package.

The `verify` API has changed now to only accept a recaptcha response string and a set of options. (see the verify documentation for supported options). The `remote_ip` that was once passed as the first argument is now an optional argument.

Most other questions about 2.x should be answered by looking over the documentation and the code. Please raise an issue
if you have any problems with migrating.

## Installation

1. Add recaptcha to your `mix.exs` dependencies

```elixir
  defp deps do
    [
      {:recaptcha, "~> 2.0"},      
    ]
  end
```

2. List `:recaptcha` as an application dependency

```elixir
  def application do
    [ applications: [:recaptcha] ]
  end
```

3. Run `mix do deps.get, compile`

## Config

By default the public and private keys are loaded via the `RECAPTCHA_PUBLIC_KEY` and `RECAPTCHA_PRIVATE_KEY` environment variables. Part of the reason for doing this is to encourage best practice (specifically not committing your reCAPTCHA secret key to your code base). You can of course override them in your own config any way that you like.

```elixir
  config :recaptcha,
    public_key: System.get_env("RECAPTCHA_PUBLIC_KEY"),
    secret: System.get_env("RECAPTCHA_PRIVATE_KEY")
```

## Usage

### Render the Widget

Use `raw` (if you're using Phoenix.HTML) and `Recaptcha.Template.display/1` methods to render the captcha widget.

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


### Verify API

Recaptcha provides the `verify/2` method, that can be used like this:

```elixir
  def create(conn, params) do
    # some code  
    case Recaptcha.verify(params["g-recaptcha-response"]) do
      {:ok, response} -> do_something
      {:error, errors} -> handle_error
    end
  end
```

`verify` method sends a `POST` request to the reCAPTCHA API and returns 2 possible values:

`{:ok, %Recaptcha.Response{challenge_ts: timestamp, hostname: host}}` -> The captcha is valid, see the [documentation](https://developers.google.com/recaptcha/docs/verify#api-response) for more details.

`{:error, errors}` -> Any possible errors will be available in `errors`, See the [error documentation](https://developers.google.com/recaptcha/docs/verify#error-code-reference) for more details.

`verify` method also accepts a keyword list as the third parameter with the following options:

Option                  | Action                                                 | Default
:---------------------- | :----------------------------------------------------- | :------------------------
`timeout`               | Time to wait before timeout                            | 5000 (ms)
`secret`                | Private key to send as a parameter of the API request  | Private key from the config file
`remote_ip`             | Optional. The user's IP address, used by reCaptcha     | no default

## Contributing

* Fork the project.
* Make your feature addition or bug fix.
* Commit
* Send me a pull request

## License

[MIT License](http://www.opensource.org/licenses/MIT).
