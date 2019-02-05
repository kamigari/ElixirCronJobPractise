defmodule CronJob.Helpers do
  @moduledoc """
  This module provides the functions required to CronJob
  """

  @doc """
  Function providing the desired imports
  """
  def helper do
    quote do
      import CronJob.Helpers.Hashes
      import CronJob.Helpers.Files
    end
  end

  @doc """
  Function provides the use macro
  """
  defmacro __using__(:helper = which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
