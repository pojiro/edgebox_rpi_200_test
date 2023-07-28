defmodule EdgeboxRpi200Test.MixProject do
  use Mix.Project

  @app :edgebox_rpi_200_test
  @version "0.1.0"
  @all_targets [:edgebox_rpi_200]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.11",
      archives: [nerves_bootstrap: "~> 1.11"],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {EdgeboxRpi200Test.Application, []},
      extra_applications: [:logger, :runtime_tools, :inets, :ssl]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.10", runtime: false},
      {:shoehorn, "~> 0.9.1"},
      {:ring_logger, "~> 0.9.0"},
      {:toolshed, "~> 0.3.0"},
      {:circuits_gpio, "~> 1.0"},
      {:circuits_uart, "~> 1.3"},
      {:circuits_i2c, "~> 1.0"},
      {:nerves_time_rtc_nxp, "~> 0.2.0"},
      {:vintage_net_qmi, "~> 0.3.2"},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.13.0", targets: @all_targets},
      {:nerves_pack, "~> 0.7.0", targets: @all_targets},

      # Dependencies for specific targets
      # NOTE: It's generally low risk and recommended to follow minor version
      # bumps to Nerves systems. Since these include Linux kernel and Erlang
      # version updates, please review their release notes in case
      # changes to your application are needed.
      {
        :edgebox_rpi_200,
        git: "https://github.com/pojiro/custom_rpi4_for_edgebox_rpi_200.git",
        tag: "v1.23.0+edgebox",
        runtime: false,
        targets: :edgebox_rpi_200
        # path: "../custom_rpi4_for_edgebox_rpi_200",
        # runtime: false,
        # targets: :edgebox_rpi_200,
        # nerves: [compile: true]
      }
    ]
  end

  def release do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end
end
