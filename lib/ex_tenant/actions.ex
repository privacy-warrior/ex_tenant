defmodule ExTenant.Actions do
  import ExTenant.PathHelper

  @doc """
    Apply tenant migrations to a tenant with given strategy, in given direction.

  A direction can be given, as the third parameter, which defaults to `:up`
  A strategy can be given as an option, and defaults to `:all`

  ## Options

    * `:all` - runs all available if `true`
    * `:step` - runs the specific number of migrations
    * `:to` - runs all until the supplied version is reached
    * `:log` - the level to use for logging. Defaults to `:info`.
      Can be any of `Logger.level/0` values or `false`.

  """
  def migrate_tenanted(repo, direction \\ :up, opts \\ []) do
    opts =
      if opts[:to] || opts[:step] || opts[:all],
        do: opts,
        else: Keyword.put(opts, :all, true)

    migrate_and_return_status(repo, direction, opts)
  end

  # ------ private functions ------ #

  defp migrate_and_return_status(repo, direction, opts) do
    {status, versions} = handle_database_exceptions fn ->
      Ecto.Migrator.run(
        repo,
        tenanted_migrations_path(repo),
        direction,
        opts
      )
    end

    {status, versions}
  end

  defp handle_database_exceptions(fun) do
    try do
      {:ok, fun.()}
    rescue
      e in Postgrex.Error ->
        {:error, Postgrex.Error.message(e)}
      #e in Mariaex.Error ->
      #  {:error, Mariaex.Error.message(e)}
    end
  end
end
