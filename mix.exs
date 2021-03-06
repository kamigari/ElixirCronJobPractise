defmodule CronJob.MixProject do
  use Mix.Project

  def project do
    [
      app: :cron_job,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {CronJob.Application, []}
    ]
  end

  defp deps do
    [{:distillery, "~> 2.0"}]
  end
end
