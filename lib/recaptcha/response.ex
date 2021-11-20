defmodule Recaptcha.Response do
  @moduledoc """
  A struct representing the successful recaptcha response from the reCAPTCHA API.
  """
  defstruct challenge_ts: "", hostname: "", action: "", score: 0.0

  @type t :: %__MODULE__{challenge_ts: String.t(), hostname: String.t(), action: String.t(), score: Float.t()}
end
