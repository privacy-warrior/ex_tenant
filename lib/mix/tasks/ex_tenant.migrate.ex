defmodule Mix.Tasks.ExTenant.Migrate do
  @moduledoc """
    Run the tenanted migrations
  """
  use Mix.Task
  import Mix.Ecto
  import IO.ANSI, only: [yellow: 0, green: 0]
  import ExTenant.PathHelper

  @aliases [
    n: :step,
    r: :repo
  ]

  @switches [
    all: :boolean,
    step: :integer,
    to: :integer,
    quiet: :boolean,
    prefix: :string,
    pool_size: :integer,
    log_sql: :boolean,
    strict_version_order: :boolean,
    repo: [:keep, :string],
    no_compile: :boolean,
    no_deps_check: :boolean,
    migrations_path: :keep
  ]

  @doc """
    Apply tenant migrations to a tenant with given strategy, in given direction.

  A direction can be given, as the third parameter, which defaults to `:up`
  A strategy can be given as an option, and defaults to `:all`

  ## Paramaters

    - *direction*: defaults to `:up`

  ## Options

    * `:all` - runs all available if `true`
    * `:step` - runs the specific number of migrations
    * `:to` - runs all until the supplied version is reached
    * `:log` - the level to use for logging. Defaults to `:info`.
      Can be any of `Logger.level/0` values or `false`.

  """

  @impl true
  def run(args) do
    repos = parse_repo(args)

    {opts, _} = OptionParser.parse!(args, strict: @switches, aliases: @aliases)

    opts =
      if opts[:to] || opts[:step] || opts[:all],
        do: opts,
        else: Keyword.put(opts, :all, true)

    opts =
      if opts[:quiet],
        do: Keyword.merge(opts, log: false, log_sql: false),
        else: opts

    # Start ecto_sql explicitly before as we don't need
    # to restart those apps if migrated.
    {:ok, _} = Application.ensure_all_started(:ecto_sql)

    # Mix.Task.run("app.start", [])
    Mix.shell().info(yellow() <> "Running Tenanted Migrations")

    for repo <- repos do
      ensure_repo(repo, args)
      # paths = ensure_migrations_paths(repo, opts)

      paths = [tenanted_migrations_path(repo)]

      pool = repo.config[:pool]

      ExTenant.Migrator.run_tenanted_migrations(repo, pool, opts, paths)
    end

    Mix.shell().info(green() <> "Completed Tenanted Migrations")

    :ok
  end

  # --- private functions --- #
end
