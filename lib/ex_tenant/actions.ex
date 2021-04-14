defmodule ExTenant.Actions do
  @moduledoc """
    Run the tenanted migrations
  """
  import ExTenant.PathHelper
  alias Ecto.Migrator
  alias Mix.Ecto
  alias Logger.App

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
  def migrate_tenanted(args, direction) do
    repo =
      args
      |> Ecto.parse_repo()
      |> List.first()

    # for now!
    opts = []

    opts =
      if opts[:to] || opts[:step] || opts[:all],
        do: opts,
        else: Keyword.put(opts, :all, true)

    migrate_and_return_status(repo, args, direction, opts)
  end

  # ------ private functions ------ #

  defp migrate_and_return_status(repo, args, direction, opts) do
    Ecto.ensure_repo(repo, args)

    {:ok, pid, apps} = ensure_started(repo, opts)

    {status, versions} =
      handle_database_exceptions(fn ->
        Migrator.run(
          repo,
          tenanted_migrations_path(repo),
          direction,
          opts
        )
      end)

    pid && repo.stop()
    restart_apps_if_migrated(apps)

    {status, versions}
  end

  @spec ensure_started(Ecto.Repo.t(), Keyword.t()) :: {:ok, pid | nil, [atom]}
  def ensure_started(repo, opts) do
    {:ok, started} = Application.ensure_all_started(:ecto_sql)

    # If we starting EctoSQL just now, assume
    # logger has not been properly booted yet.
    if :ecto_sql in started && Process.whereis(Logger) do
      backends = Application.get_env(:logger, :backends, [])

      try do
        App.stop()
        Application.put_env(:logger, :backends, [:console])
        :ok = App.start()
      after
        Application.put_env(:logger, :backends, backends)
      end
    end

    config = repo.config()
    adapter = repo.__adapter__()

    {:ok, apps} = adapter.ensure_all_started(config, :temporary)
    pool_size = Keyword.get(opts, :pool_size, 2)

    case repo.start_link(pool_size: pool_size) do
      {:ok, pid} ->
        {:ok, pid, apps}

      {:error, {:already_started, _pid}} ->
        {:ok, nil, apps}

      {:error, error} ->
        Mix.raise("Could not start repo #{inspect(repo)}, error: #{inspect(error)}")
    end
  end

  @doc """
  Restarts the app if there was any migration command.
  """
  @spec restart_apps_if_migrated([atom]) :: :ok
  def restart_apps_if_migrated(apps) do
    # Silence the logger to avoid application down messages.
    Logger.remove_backend(:console)

    for app <- Enum.reverse(apps) do
      Application.stop(app)
    end

    for app <- apps do
      Application.ensure_all_started(app)
    end

    :ok
  after
    Logger.add_backend(:console, flush: true)
  end

  defp handle_database_exceptions(fun) do
    try do
      {:ok, fun.()}
    rescue
      e in Postgrex.Error ->
        {:error, Postgrex.Error.message(e)}

      e in Mariaex.Error ->
        {:error, MyXQL.Error.message(e)}
    end
  end
end
