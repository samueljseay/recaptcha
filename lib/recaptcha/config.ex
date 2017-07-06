defmodule Recaptcha.Config do
  @moduledoc """
  Provides application/system environment variable lookup at runtime
  """

  @doc """
  Returns the requested variable
  """
  @spec get_env(atom, atom, any) :: any
  def get_env(application, key, default \\ nil) do
    application
    |> Application.get_env(key, default)
    |> _get_env()
  end

  defp _get_env({:system, env_variable}), do: System.get_env(env_variable)
  defp _get_env(value), do: value

end
