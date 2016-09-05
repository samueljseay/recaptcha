defmodule Recaptcha.Template do
  @moduledoc """
    Responsible for rendering boilerplate recaptcha HTML code, supports noscript fallback.

    [Some](https://developers.google.com/recaptcha/docs/display#explicit_render)
    functionality is not currently supported.

    In future this module may be separated out into a Phoenix specific library.
  """
  require Elixir.EEx

  EEx.function_from_file :defp, :render_template, "lib/template.html.eex", [:assigns]

  @doc """
  Returns a string with reCAPTCHA code

  To convert the string to html code, use Phoenix.HTML.Raw/1 method
  """
  def display(options \\ []) do
    public_key = options[:public_key] || Application.get_env(:recaptcha, :public_key)
    render_template(public_key: public_key, options: options)
  end
end
