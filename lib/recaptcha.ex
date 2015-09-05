defmodule Recaptcha do
  require Elixir.EEx

  @secret_key_errors ~w(missing-input-secret invalid-input-secret)

  EEx.function_from_file :defp, :render_template, "lib/template.html.eex", [:assigns]

  @doc """
  Returns a string with reCAPTCHA code

  To convert the string to html code, use Phoenix.HTML.Raw/1 method
  """
  def display(options \\ []) do
    public_key = options[:public_key] || config.public_key
    render_template(public_key: public_key, options: options)
  end

  @doc """
  Verifies reCAPTCHA response string.

  The function returns :ok or :error, depending on the verification's result

  :ok is returned when the response code was successfully verified

  :error is returned when the response is nil or if the reCAPTCHA server returned
  a missing-input-response or invalid-input-response code

  The function raises RuntimeError if the server returned a missing-input-secret or invalid-input-secret
  code
  """
  def verify(remote_ip, response, options \\ [])

  def verify(remote_ip, response, options) when is_tuple(remote_ip) do
    verify(:inet_parse.ntoa(remote_ip), response, options)
  end

  def verify(_remote_ip, nil = _response, _options), do: :error

  def verify(remote_ip, response, options) do
    case api_response(remote_ip, response, options)  do
      %{"success" => true} ->
        :ok
      %{"success" => false, "error-codes" => error_codes} ->
        handle_error_codes(error_codes)
      %{"success" => false} ->
        :error
    end
  end

  defp api_response(remote_ip, response, options) do
    private_key = options[:private_key] || config.private_key
    timeout = options[:timeout] || 3000
    body_content = URI.encode_query(%{"remoteip"  => to_string(remote_ip),
                                      "response"  => response,
                                      "secret" => private_key})
    headers = ["Content-type": "application/x-www-form-urlencoded"]
    options = [body: body_content, headers: headers, timeout: timeout]
    HTTPotion.post(config.verify_url, options).body |> Poison.decode!
  end

  defp config do
    Application.get_env(:recaptcha, :api_config)
  end

  defp handle_error_codes(error_codes) do
    if Enum.any?(error_codes, fn(code) -> Enum.member?(@secret_key_errors, code) end) do
      raise RuntimeError,
        message: "reCaptcha API has declined the private key. Please make sure you've set the correct private key"
    else
      :error
    end
  end

end
