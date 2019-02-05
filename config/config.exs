use Mix.Config

config :cron_job,
  backup_path: Path.expand("#{File.cwd() |> elem(1)}/backup"),
  path_to_backup: Path.expand("~/backup")
