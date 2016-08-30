defmodule Recaptcha do

  @headers [{"Content-type", "application/x-www-form-urlencoded"}, {"Accept", "application/json"}]

  @url Application.get_env(:recaptcha, :verify_url)
  @timeout Application.get_env(:recaptcha, :timeout, 5000)

  def verify(response, options \\ []) do
    case make_request(response, options) do
      %{"success" => false, "error-codes" => errors} -> {:error, errors}
      %{"success" => true, "challenge_ts" => timestamp, "hostname" => host} -> {:ok, %{challenge_ts: timestamp, hostname: host}}
    end
  end

  defp make_request(response, options) do
    HTTPoison.post!(@url, request_body(response, options), @headers, timeout: options[:timeout] || @timeout).body
    |> Poison.decode!
  end

  @doc false
  def request_body(response, options) do
    # valid options are remote_ip, secret
    options_map =
      options
      |> Enum.into(%{})

    # override application config with options if they exist
    config
    |> Map.merge(options_map)
    |> Map.put(:response, response)
    |> URI.encode_query
  end

  defp config do
    case Application.get_env(:recaptcha, :private_key) do
      nil -> %{}
      "" -> %{}
      key -> %{secret: key}
    end
  end
end
