defmodule ExTenant.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_tenant,
      version: "0.2.4",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      elixirc_options: [warnings_as_errors: true],
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      # Documentation
      name: "ExTenant",
      source_url: project_url(),
      homepage_url: project_url(),
      docs: [
        # The main page in the docs
        main: "ExTenant",
        extras: ["README.md"]
      ]
    ]
  end

  defp project_url, do: "https://github.com/privacy-warrior/ex_tenant"

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Privacy Warrior"],
      licenses: ["Apache License 2.0"],
      links: %{"GitHub" => "https://github.com/privacy-warrior/ex_tenant"}
    ]
  end

  defp description do
    """
    Foreign key based multi-tenancy, allowing all the tenanted data to live in the
    same database.
    """
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.9.4"},
      {:postgrex, "~> 0.16.5", only: :test},
      {:ecto_sql, "~> 3.9.2"},
      {:myxql, "~> 0.6.3", only: :test},
      {:ex_doc, "~> 0.29.1", only: :dev, runtime: false}
    ]
  end
end
