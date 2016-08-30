defmodule Recaptcha.Template do
  require Elixir.EEx

  EEx.function_from_file :defp, :render_template, "lib/template.html.eex", [:assigns]

  @doc """
  Returns a string with reCAPTCHA code

  To convert the string to html code, use Phoenix.HTML.Raw/1 method
  """
  def display(options \\ []) do
    public_key = options[:public_key] || config.public_key
    render_template(public_key: public_key, options: options)
  end

  defp config do
    Application.get_env(:recaptcha, :config) || %{}
  end
end
