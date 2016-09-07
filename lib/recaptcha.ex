defmodule Recaptcha do
  @moduledoc """
    A module for verifying reCAPTCHA version 2.0 response strings.

    See the [documentation](https://developers.google.com/recaptcha/docs/verify)
    for more details.
  """
  @http_client Application.get_env(:recaptcha, :http_client, Recaptcha.Http)

  @doc """
  Verifies a reCAPTCHA response string.

  ## Options

    * `:timeout` - the timeout for the request (defaults to 5000ms)
    * `:secret`  - the secret key used by recaptcha (defaults to the secret
      provided in application config)
    * `:remote_ip` - the IP address of the user (optional and not set by default)

  ## Example

    {:ok, api_response} = Recaptcha.verify("response_string")
  """
  @spec verify(String.t, [timeout: integer, secret: String.t,
                          remote_ip: String.t]) :: {:ok, Recaptcha.Response.t} |
                                                   {:error, [atom]}
  def verify(response, options \\ [])

  def verify(nil = _response, _) do
    {:error, [:invalid_input_response]}
  end

  def verify(response, options) do
    case @http_client.request_verification(
      request_body(response, options),
      Keyword.take(options, [:timeout])
    ) do
      {:error, errors} ->
        {:error, errors}
      {:ok, %{"success" => false, "error-codes" => errors}} ->
        {:error, Enum.map(errors, fn(error) -> atomise_api_error(error) end)}
      {:ok, %{"success" => true, "challenge_ts" => timestamp, "hostname" => host}} ->
        {:ok, %Recaptcha.Response{challenge_ts: timestamp, hostname: host}}
      {:ok, %{"success" => false, "challenge_ts" => _timestamp, "hostname" => _host}} ->
        {:error, [:challenge_failed]}
    end
  end

  defp request_body(response, options) do
    body_options = Keyword.take(options, [:remote_ip, :secret])
    application_options = [secret: Application.get_env(:recaptcha, :secret)]

    # override application secret with options secret if it exists
    application_options
    |> Keyword.merge(body_options)
    |> Keyword.put(:response, response)
    |> URI.encode_query
  end

  defp atomise_api_error(error) do
    error
    |> String.replace("-", "_")
    |> String.to_atom
  end
end
