defmodule ExTenant.PathHelper do
  @moduledoc """
    retrieve the tenanted migrations path using a default fallback
  """

  @migrations_folder Application.get_env(:ex_tenant, :migrations_folder) || "tenanted_migrations"

  @doc """
    ## Parameters

      - *repo*: the repository th retrieve the path for

  """
  def tenanted_migrations_path(repo) do
    Path.join(priv_path_for(repo), @migrations_folder)
  end

  # ------ private functions ------#

  defp priv_path_for(repo) do
    app = Keyword.get(repo.config, :otp_app)

    repo_underscore = repo |> Module.split() |> List.last() |> Macro.underscore()

    Path.join([priv_dir(app), repo_underscore])
  end

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"
end
