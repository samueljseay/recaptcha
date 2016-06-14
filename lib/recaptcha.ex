defmodule Recaptcha do
  require Elixir.EEx

  @moduledoc """
  Simple Google reCAPTCHA plugin for Phoenix applications. 
  """

  @config Application.get_env(:recaptcha, :api_config)
  @script_src "https://www.google.com/recaptcha/api.js"

  @spec render_script(map | Keyword.t) :: {:safe, String.t}

  @doc """
  Renders reCAPTCHA script tag.

  Accepts parameters map or a keyword list that will be appended to
  the url. 

  Available parameters are:

    * `onload` - The name of your callback function to be executed once all the dependencies have loaded.

    * `render` - Whether to render the widget explicitly. 
      Defaults to onload, which will render the widget in the first g-recaptcha tag it finds.

    * `hl` - Forces the widget to render in a specific language. Auto-detects the user's language if unspecified.

  More detailed info can be found on the official site - https://developers.google.com/recaptcha/docs/display#js_param
  """
  def render_script(query) when is_map(query) or is_list(query) do
    script_src = @script_src <> "?" <> URI.encode_query(query)
    do_render_script(script_src)
  end

  def render_script do
    do_render_script(@script_src)
  end

  @spec render_widget(Keyword.t) :: {:safe, String.t}

  @doc """
  Renders reCAPTCHA widget.

  Available options: 

    * `sitekey` - Your sitekey. Defaults to the public key from the config.

    * `theme` - The color theme of the widget.

    * `type` - The type of CAPTCHA to serve.

    * `size` - The size of the widget.

    * `tabindex` - The tabindex of the widget and challenge.

    * `callback` - The name of your callback function to be executed when the user submits a successful CAPTCHA response.

    * `expired_callback` - The name of your callback function to be executed when the recaptcha 
      response expires and the user needs to solve a new CAPTCHA.

    * `noscript` - Whether to render or not the noscript content. Defaults to `false`.

  More detailed info can be found on the official site - https://developers.google.com/recaptcha/docs/display#render_param
  """
  def render_widget(options \\ []) do
    options = Keyword.put_new(options, :sitekey, @config.public_key)
    {:safe, do_render_widget(options: options)}
  end

  @spec verify(String.t, Keyword.t) :: map

  @doc """
  Verifies reCAPTCHA response. 
  
  Accepts two parameters, response to verify and options.

  Available options are:

    * `private_key` - Private key to use for verification. Defaults to the private key from the config.

    * `timeout` - Number of milliseconds until timeout. Defaults to `5000`.

    * `remote_ip` - The user's IP address. Defaults to `nil`
  
  Returns a map of the json response returned by the reCAPTCHA server.

  More detailed info can be found on the official site - https://developers.google.com/recaptcha/docs/verify#api-response
  """
  def verify(response, options \\ []) do
    private_key = Keyword.get(options, :private_key, @config.private_key)
    timeout = Keyword.get(options, :timeout, 5000)
    url = "https://www.google.com/recaptcha/api/siteverify"
    body = request_body(private_key, response, stringify_ip_address(options[:remote_ip]))
    headers = request_headers()

    HTTPoison.post!(url, body, headers, timeout: timeout).body |> Poison.decode!
  end

  @spec request_body(String.t, String.t, String.t | nil) :: String.t

  defp request_body(secret, response, remote_ip) do
    %{"secret" => secret, "response" => response}
    |> (&(if remote_ip, do: Map.put(&1, "remoteip", remote_ip), else: &1)).()
    |> URI.encode_query()
  end

  @spec request_headers() :: [{}]

  defp request_headers do
    [
      {"Content-type", "application/x-www-form-urlencoded"}, 
      {"Accept", "application/json"}
    ]
  end

  @spec stringify_ip_address(nil | tuple | String.t) :: nil | String.t

  defp stringify_ip_address(nil), do: nil

  defp stringify_ip_address(ip_address) when is_tuple(ip_address) do
    ip_address
    |> :inet_parse.ntoa()
    |> to_string()
  end

  defp stringify_ip_address(ip_address) when is_binary(ip_address), do: ip_address

  EEx.function_from_file :defp, :do_render_widget, "lib/recaptcha/templates/widget.html.eex", [:assigns]

  defp do_render_script(src) do
    {:safe, "<script src='#{src}' async defer></script>"}
  end
end
