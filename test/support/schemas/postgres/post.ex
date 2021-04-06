defmodule ExTenant.Test.Support.Schemas.Postgres.Post do
  use ExTenant.Schema

  import Ecto.Changeset

  tenanted_schema "posts" do
    field(:name, :string)
    field(:body, :string)

    tenanted()

    has_many(:comments, ExTenant.Test.Support.Schemas.Postgres.Comment)
  end

  def changeset(params \\ :empty) do
    params
    |> default_changeset()
  end

  def changeset_without_tenant_id(params \\ :empty) do
    params
    |> default_changeset_without_tenant_id()
  end

  def changeset_with_tenant_id_from_process(params, repo) do
    params
    |> repo.inject_tenant_id()
    |> default_changeset()
  end

  def changeset_with_tenant_id_from_process_but_not_cast(params, repo) do
    params
    |> repo.inject_tenant_id()
    |> default_changeset_without_tenant_id()
  end

  defp default_changeset(params) do
    %__MODULE__{}
    |> cast(params, [:name, :body, :tenant_id])
  end

  defp default_changeset_without_tenant_id(params) do
    %__MODULE__{}
    |> cast(params, [:name, :body])
  end
end
