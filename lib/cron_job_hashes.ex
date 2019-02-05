defmodule CronJob.Helpers.Hashes do
  require Logger

  @moduledoc """
  This module provides the functions required to CronJob regarding file hashing
  """

  @doc """
  Function to retrieve from env path_to_backup
  """

  def get_path_to_backup, do: Application.get_env(:cron_job, :path_to_backup)

  @doc """
  Function to retrieve from env backup_path
  """

  def get_path_backup, do: Application.get_env(:cron_job, :backup_path)

  @doc """
  Function to get list of files and streams
  """

  def get_tuple_files(files) do
    files
    |> Enum.map(fn file ->
      case File.open(Path.expand("#{get_path_backup()}/#{file}")) do
        {:ok, _file} ->
          {file, File.stream!("#{get_path_backup()}/#{file}", [], 1024)}

        {:error, reason} ->
          Logger.warn("Couldn't open file: #{file} => #{reason}")
          {file, :delete}
      end
    end)
  end

  @doc """
  Function to set hash of files
  """

  def set_hash_files([]), do: []

  def set_hash_files(files) do
    get_tuple_files(files)
    |> Enum.map(fn {file, stream} ->
      case stream do
        :delete ->
          %{file => :delete}

        stream ->
          %{
            file =>
              stream
              |> Enum.reduce(:crypto.hash_init(:sha256), fn line, acc ->
                :crypto.hash_update(acc, line)
              end)
              |> :crypto.hash_final()
              |> Base.encode64()
          }
      end
    end)
  end

  @doc """
  Function to insert hash of the files into the GenServer
  """

  def set_hash_files_to_store([], store), do: store

  def set_hash_files_to_store(hash_files, store) do
    hash_files
    |> Enum.reduce(store, fn file_hash_map, acc ->
      case Map.keys(file_hash_map) do
        [key] ->
          case Map.get(file_hash_map, key) do
            :delete ->
              Map.delete(acc, key)

            value ->
              Map.put(acc, key, value)
          end
      end
    end)
  end

  @doc """
  Function to get the hashes from the backup location and store them
  """

  def get_hash_files_and_store(path, store) do
    case File.ls(path) do
      {:ok, files} ->
        set_hash_files(files)
        |> set_hash_files_to_store(store)

      {:error, reason} ->
        Logger.error("Couldn't list the #{path}: #{reason}")
        store
    end
  end
end
