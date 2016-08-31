defmodule Recaptcha do
  @moduledoc """
    A module for verifying reCAPTCHA version 2.0 response strings.

    See the [documentation](https://developers.google.com/recaptcha/docs/verify) for more details.
  """
  @secret Application.get_env(:recaptcha, :secret)
  @http_client Application.get_env(:recaptcha, :http_client, Recaptcha.Http)

  @doc """
  Verifies a reCAPTCHA response string.

  ## Options

    * `:timeout` - the timeout for the request (defaults to 5000ms)
    * `:secret`  - the secret key used by recaptcha (defaults to the secret provided in application config)
    * `:remote_ip` - the IP address of the user (optional and not set by default)

  ## Example

    {:ok, api_response} = Recaptcha.verify("response_string")
  """
  @spec verify(String.t, [timeout: integer, secret: String.t, remote_ip: String.t]) :: {:ok, map} | {:error, [String.t]}
  def verify(response, options \\ [])

  def verify(nil = _response, _) do
    {:error, ["invalid-input-response"]}
  end

  def verify(response, options) do
    case @http_client.request_verification(request_body(response, options), Keyword.take(options, [:timeout])) do
      %{"success" => false, "error-codes" => errors} -> {:error, errors}
      %{"success" => true, "challenge_ts" => timestamp, "hostname" => host} -> {:ok, %{challenge_ts: timestamp, hostname: host}}
    end
  end

  @doc false
  def request_body(response, options) do
    body_options = Keyword.take(options, [:remote_ip, :secret])
    application_options = [secret: @secret]

    # override application secret with options secret if it exists
    application_options
    |> Keyword.merge(body_options)
    |> Keyword.put(:response, response)
    |> Enum.into(%{})
    |> URI.encode_query
  end
end
