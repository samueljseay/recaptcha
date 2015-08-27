# Recaptcha

A simple Elixir package for implementing [ReCaptcha] v2 in [Phoenix] applications.

[ReCaptcha]: http://www.google.com/recaptcha
[Phoenix]: http://www.phoenixframework.org/

## Installation

Set as a dependency in the  and ensure it is running with your app:

1) Add as a dependency to the mix.exs file

```elixir
  defp deps do
    [
      # other deps
      {:recaptcha, "~> 0.0.1"},
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
      # other deps
    ]
  end
```

2) Add to your application list

```elixir
def application do
  [
    # ...
    applications: [:phoenix, :recaptcha]
    # ...
  ]
end
```

Get your project's dependencies:

```bash
$ mix deps.get
```

## Config

In your application's config.exs :

```elixir
config :recaptcha,
  api_config: %{ verify_url: "https://www.google.com/recaptcha/api/siteverify",
                 public_key: "YOUR_PUBLIC_KEY",
                 private_key: "YOUR_PRIVATE_KEY" }
```

## Usage

### View

In a template

```html
<form name="someform" method="post" action="/somewhere">
  ...
  <%= raw Recaptcha.display %>
  ...
</form>
```

Display method accepts a keyword list with 2 possible options:

* `noscript` -> Set to true to render noscript code
* `public_key` -> The key put in the `data-sitekey` reCaptcha div attribute, default is the public key set in the config file
 
Pass these parameters like this:

```elixir
...
<%= raw Recaptcha.display(noscript: true, public_key: "Public key") %>
...
```

### Controller

In a controller

```elixir

def create(conn, params) do
  # some code  
  case Recaptcha.verify(conn.remote_ip, params["g-recaptcha-response"]) do
    :ok -> do_something
    :error -> handle_error
  end
end

```

`verify` method also accepts a keyword list as the third parameter with also 2 possible options:

* `public_key` -> A key to use in the http request to the recaptcha api, default is the private key set in the config file
* `timeout` -> Time period in ms to wait for a response from google api, default is 3000
