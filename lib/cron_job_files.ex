defmodule CronJob.Helpers.Files do
  import CronJob.Helpers.Hashes
  require Logger

  @moduledoc """
  This module provides the functions required to CronJob regarding file transfer
  """

  @doc """
  Function to create backup path
  """

  def create_backup_path? do
    Logger.info("Creating path to backup: '#{get_path_to_backup()}'")

    if not File.exists?(get_path_to_backup()) do
      case File.mkdir(get_path_to_backup()) do
        :ok ->
          Logger.info("Created path for backup.")

        {:error, reason} ->
          Logger.error("Coulnd't create a path for backup: #{reason}.")
      end
    else
      Logger.error("Path '#{get_path_to_backup()}' already exists.")
    end
  end

  @doc """
  Function to copy all the files from backup folder into the backup destination folder
  """

  def copy_all_files_to_backup_location do
    Logger.info(
      "Copying all the files from: '#{get_path_backup()}' into: '#{get_path_to_backup()}'..."
    )

    case File.cp_r(get_path_backup(), get_path_to_backup()) do
      {:ok, list_files} ->
        [_file_location | list] = Enum.reverse(list_files)
        Enum.each(list, fn file -> Logger.info("Copyed the file: '#{file}'") end)

      {:error, error, reason} ->
        Logger.error("Couldn't copy files: #{error} => #{reason}")
    end
  end

  @doc """
  Function to copy the file into the path
  """

  def copy_file_to_backup_location(file, path) do
    Logger.info("The copying '#{file}'...")

    case File.cp(Path.expand("#{get_path_backup()}/#{file}"), "#{path}/#{file}") do
      :ok ->
        Logger.info("The copy of: '#{file}' was done successfully.")

      {:error, reason} ->
        Logger.info("The copy of: '#{file}' couldn't be done: '#{reason}'.")
    end
  end

  @doc """
  Function to compare files from the path from the store (%{})
  """
  def compare_files(_path, store) when map_size(store) == 0,
    do: copy_all_files_to_backup_location()

  def compare_files(path, store) do
    backup_store = get_hash_files_and_store(path, %{})

    cond do
      map_size(backup_store) == 0 ->
        copy_all_files_to_backup_location()

      map_size(backup_store) > 0 ->
        for {k, v} <- store do
          case Map.has_key?(backup_store, k) do
            true ->
              cond do
                v === Map.get(backup_store, k) ->
                  Logger.info("The file: '#{k}' hasn't changed.")

                v !== Map.get(backup_store, k) ->
                  copy_file_to_backup_location(k, get_path_to_backup())
              end

            false ->
              if File.exists?(Path.expand("#{get_path_backup()}/#{k}")) do
                copy_file_to_backup_location(k, get_path_to_backup())
              end
          end
        end
    end
  end
end
