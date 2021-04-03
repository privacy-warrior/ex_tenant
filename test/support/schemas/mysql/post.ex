defmodule ExTenant.Test.Support.Schemas.Mysql.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:name, :string)
    field(:body, :string)

    belongs_to(:tenant, ExTenant.Test.Support.Schemas.Mysql.Tenant, references: :tenant_id)

    has_many(:comments, ExTenant.Test.Support.Schemas.Mysql.Comment)
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
    |> cast(params, [:name, :body, :tenant_id])
  end
end
