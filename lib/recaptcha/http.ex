defmodule Recaptcha.Http do
  @moduledoc """
   Responsible for managing HTTP requests to the reCAPTCHA API
  """
  @headers [{"Content-type", "application/x-www-form-urlencoded"}, {"Accept", "application/json"}]
  @url Application.get_env(:recaptcha, :verify_url)
  @timeout Application.get_env(:recaptcha, :timeout, 5000)

  @doc """
  Sends an HTTP request to the reCAPTCHA version 2.0 API.

  See the [documentation](https://developers.google.com/recaptcha/docs/verify#api-response) for more details on the API response.

  ## Options

    * `:timeout` - the timeout for the request (defaults to 5000ms)

  ## Example

    %{ "success" => success,
       "challenge_ts" => ts,
       "hostname" => host,
       "error-codes" => errors
     } = Recaptcha.Http.request_verification(%{ secret: "secret", response: "response", remote_ip: "remote_ip"})
  """
  @spec request_verification(map, [timeout: integer]) :: map
  def request_verification(body, options \\ []) do
    HTTPoison.post!(@url, body, @headers, timeout: options[:timeout] || @timeout).body
    |> Poison.decode!
  end
end
