# Recaptcha

![Build Status](https://travis-ci.org/samueljseay/recaptcha.svg?branch=master)

A simple Elixir package for implementing [reCAPTCHA] in Elixir applications.

[reCAPTCHA]: http://www.google.com/recaptcha

## Migration from 1.x

### Breaking Changes

1. Template functionality is now in a separate module: `Recaptcha.Template`. Please note: in future templating may move to a Phoenix specific package.
2. `verify` API has changed, see the code for documentation of the new API.

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

By default the public and private keys are loaded via the `RECAPTCHA_PUBLIC_KEY` and `RECAPTCHA_PRIVATE_KEY` environment variables.

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
  <%= raw Recaptcha.Template.display %>
  ...
</form>
```

`display` method accepts additional options as a keyword list, the options are:

Option                  | Action                                                 | Default
:---------------------- | :----------------------------------------------------- | :------------------------
`noscript`              | Renders default noscript code provided by google       | `false`
`public_key`            | Sets key to the `data-sitekey` reCaptcha div attribute | Public key from the config file


### Verify API

Recaptcha provides the `verify/2` method. Below is an example using a Phoenix controller action:

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

`{:error, errors}` -> `errors` contains atomised versions of the errors returned by the API, See the [error documentation](https://developers.google.com/recaptcha/docs/verify#error-code-reference) for more details. Errors caused by timeouts in HTTPoison or Poison encoding are also returned as atoms. If the recaptcha request succeeds but the challenge is failed, a ``:challenge_failed` error is returned.

`verify` method also accepts a keyword list as the third parameter with the following options:

Option                  | Action                                                 | Default
:---------------------- | :----------------------------------------------------- | :------------------------
`timeout`               | Time to wait before timeout                            | 5000 (ms)
`secret`                | Private key to send as a parameter of the API request  | Private key from the config file
`remote_ip`             | Optional. The user's IP address, used by reCaptcha     | no default

## Contributing

* Fork the project.
* Make your feature addition or bug fix. (If you're not sure raise an issue to discuss first)
* Commit
* Send me a pull request

## License

[MIT License](http://www.opensource.org/licenses/MIT).
