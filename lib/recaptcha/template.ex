defmodule Recaptcha.Template do
  @moduledoc """
  Responsible for rendering boilerplate recaptcha HTML code, supports noscript fallback.

  [Some](https://developers.google.com/recaptcha/docs/display#explicit_render)
  functionality is not currently supported.

  In future this module may be separated out into a Phoenix specific library.
  """
  require Elixir.EEx
  alias Recaptcha.Config

  EEx.function_from_file(:defp, :render_template, "lib/template.html.eex", [
    :assigns
  ])

  @doc """
  Returns a string with reCAPTCHA code.

  To convert the string to html code, use `Phoenix.HTML.Raw/1` method.
  """
  def display(options \\ []) do
    public_key =
      options[:public_key] || Config.get_env(:recaptcha, :public_key)

    callback =
      if options[:size] == "invisible" && is_nil(options[:callback]) do
        "recaptchaCallback"
      else
        options[:callback]
      end

    onload =
      if options[:onload] do
        "onload=#{options[:onload]}&"
      else
        ""
      end

    options_dict = Keyword.put(options, :onload, onload)

    render_template(%{
      public_key: public_key,
      callback: callback,
      options: options_dict
    })
  end
end
