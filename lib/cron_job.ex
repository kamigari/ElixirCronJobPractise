defmodule CronJob do
  use GenServer, restart: :transient, shutdown: 30_000
  use CronJob.Helpers, :helper
  @interval 3_600_000

  @moduledoc """
  This module provides a backup for the files stored in the config backup origin into the config backup destination
  """

  @doc """
  Callback function when the GenServer is started
  """
  @impl true
  def init(store) do
    set_cron_job()
    {:ok, store}
  end

  @doc """
  Callback for the GenServer to handle the refresh message
  """
  @impl true
  def handle_info(:refresh, store) do
    new_store = get_hash_files_and_store(get_path_backup(), store)
    compare_files(get_path_to_backup(), new_store)
    schedule_cron_job()
    {:noreply, new_store}
  end

  @doc """
  Starts the GenServer
  """
  def start_link(_) do
    create_backup_path?()
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  _ = """
  Function to send the message to refresh
  """

  defp set_cron_job, do: Process.send(self(), :refresh, [])

  _ = """
  Function to schedule a refresh message
  """

  defp schedule_cron_job, do: Process.send_after(self(), :refresh, @interval)
end
