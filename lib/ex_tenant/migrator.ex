defmodule ExTenant.Migrator do
  @moduledoc false

  def run_tenanted_migrations(repo, pool, opts, paths) do
    migrator = &Ecto.Migrator.run/4

    fun =
      if Code.ensure_loaded?(pool) and function_exported?(pool, :unboxed_run, 2) do
        &pool.unboxed_run(&1, fn -> migrator.(&1, paths, :up, opts) end)
      else
        &migrator.(&1, paths, :up, opts)
      end

    case Ecto.Migrator.with_repo(repo, fun, [mode: :temporary] ++ opts) do
      {:ok, _migrated, _apps} ->
        :ok

      {:error, error} ->
        Mix.raise("Could not start repo #{inspect(repo)}, error: #{inspect(error)}")
    end
  end
end
