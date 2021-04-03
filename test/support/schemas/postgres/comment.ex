defmodule ExTenant.Test.Support.Schemas.Postgres.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field(:name, :string)
    field(:body, :string)

    belongs_to(:tenant, ExTenant.Test.Support.Schemas.Postgres.Tenant, references: :tenant_id)

    belongs_to(:post, ExTenant.Test.Support.Schemas.Postgres.Post)
  end

  def changeset(params \\ :empty) do
    params
    |> default_changeset()
  end

  def changeset_with_tenant_id_from_process(params, repo) do
    params
    |> repo.inject_tenant_id()
    |> default_changeset()
  end

  defp default_changeset(params) do
    %__MODULE__{}
    |> cast(params, [:name, :body, :post_id, :tenant_id])
  end
end
