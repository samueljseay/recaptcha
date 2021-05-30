defmodule Recaptcha.Response do
  @moduledoc """
  A struct representing the successful recaptcha response from the reCAPTCHA API.
  """
  defstruct challenge_ts: "", hostname: ""

  @type t :: %__MODULE__{challenge_ts: String.t(), hostname: String.t()}
end
