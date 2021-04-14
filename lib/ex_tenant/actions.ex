defmodule ExTenant.Actions do
  @moduledoc """
    Run the tenanted migrations
  """
  import ExTenant.PathHelper
  alias Mix.Ecto

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

    {status, versions} =
      handle_database_exceptions(fn ->
        Ecto.Migrator.run(
          repo,
          tenanted_migrations_path(repo),
          direction,
          opts
        )
      end)

    {status, versions}
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
