defmodule Recaptcha.Http.MockClient do
  @moduledoc """
    A mock HTTP client used for testing.
  """

  def request_verification(body, options \\ [])

  def request_verification("response=valid_response&secret=6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe" = body, options) do
    send self(), {:request_verification, body, options}
    {:ok, %{"success" => true, "challenge_ts" => "timestamp", "hostname" => "localhost"}}
  end

  # every other match is a pass through to the real client
  def request_verification(body, options) do
    send self(), {:request_verification, body, options}
    Recaptcha.Http.request_verification(body, options)
  end
end
