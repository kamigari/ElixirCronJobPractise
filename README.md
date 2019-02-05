# CronJob

This is a practise project to get more knowledge from GenServer from Elixir.

## Installation

  * Install dependencies and compile them with `mix do deps.get, compile`
  * Run without deployment:
  ```
  $ mix run --no-halt
  or
  $ iex -S mix
  ```
  * Run with deployment:
  ```
  $ mix release.init
  $ mix release
  To start the release you have built, you can use one of the following tasks:
  # start a shell, like 'iex -S mix'
  $ _build/dev/rel/cron_job/bin/cron_job.sh console
  # start in the foreground, like 'mix run --no-halt'
  $ _build/dev/rel/cron_job/bin/cron_job.sh foreground
  # start in the background, must be stopped with the 'stop' command
  $ _build/dev/rel/cron_job/bin/cron_job.sh start
  If you started a release elsewhere, and wish to connect to it:
  # connects a local shell to the running node
  $ _build/dev/rel/cron_job/bin/cron_job.sh remote_console
  # connects directly to the running node's console
  $ _build/dev/rel/cron_job/bin/cron_job.sh attach
  For a complete listing of commands and their use:
  $ _build/dev/rel/cron_job/bin/cron_job.sh help
  ```

#### Configuration

In `config/config.exs`, change to your origin and destination folders:

```
config :cron_job,
  backup_path: Path.expand("~/path"),
  path_to_backup: Path.expand("~/path")
```  

Or manually at runtime:

```
elixir
  CronJob.Application.configure([path_to_backup: Path.expand("~/path")])
```

#### Functionalities

* This is a practise in Elixir for a mainstream cron job. The application backs-up all the files from the origin folder into the destination folder every hour.

* TODO: Better support for deleting files from the origin folder and comparison into the destination folder.

#### Persistence

The data persistence its held in the GenServer. The GenServer holds the files and the regarding hashed by sha256 encoded in 64 to make the afterwards comparison. The decision to choose GenServer over Agent its the refresh rate to simulate a cron job.

## Prerequisites

  * To run this project you need:
    * Erlang: The programming language http://www.erlang.org/
    * Elixir: The programming language https://elixir-lang.org/

## Built within

* Elixir: The programming language https://elixir-lang.org/

## Authors

* **Alberto Revuelta Arribas** - *initial work* [kamigari](https://github.com/kamigari)

## License

* This project is licensed under the License - see the [LICENSE.md](LICENSE.md) file for details.
