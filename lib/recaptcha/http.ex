defmodule Recaptcha.Http do
  @moduledoc """
  Responsible for managing HTTP requests to the reCAPTCHA API.
  """

  alias Recaptcha.Config

  @headers [
    {"Content-type", "application/x-www-form-urlencoded"},
    {"Accept", "application/json"}
  ]

  @default_verify_url "https://www.google.com/recaptcha/api/siteverify"

  @doc """
  Sends an HTTP request to the reCAPTCHA version 2.0 API.

  See the [docs](https://developers.google.com/recaptcha/docs/verify#api-response)
  for more details on the API response.

  ## Options

    * `:timeout` - the timeout for the request (defaults to 5000ms)

  ## Examples

      {:ok, %{
        "success" => success,
        "challenge_ts" => ts,
        "hostname" => host,
        "error-codes" => errors
      }} = Recaptcha.Http.request_verification(%{
        secret: "secret",
        response: "response",
        remote_ip: "remote_ip"
      })

  """
  @spec request_verification(binary, Keyword.t()) ::
          {:ok, map} | {:error, [atom]}
  def request_verification(body, options \\ []) do
    timeout = options[:timeout] || Config.get_env(:recaptcha, :timeout, 5000)
    url = Config.get_env(:recaptcha, :verify_url, @default_verify_url)
    json = Application.get_env(:recaptcha, :json_library, Jason)

    opts = [{:timeout, timeout} | options]

    result =
      with {:ok, response} <-
             HTTPoison.post(url, body, @headers, opts),
           {:ok, data} <- json.decode(response.body) do
        {:ok, data}
      end

    case result do
      {:ok, data} -> {:ok, data}
      {:error, :invalid} -> {:error, [:invalid_api_response]}
      {:error, {:invalid, _reason}} -> {:error, [:invalid_api_response]}
      {:error, %{reason: reason}} -> {:error, [reason]}
    end
  end
end
