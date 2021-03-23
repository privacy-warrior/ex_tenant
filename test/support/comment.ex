
defmodule ExTenant.Test.Support.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias ExTenant.Repo
  
  schema "comments" do
    field(:name, :string)
    field(:body, :string)

    belongs_to(:tenant, ExTenant.Test.Support.Tenant, references: :tenant_id)

    belongs_to(:post, ExTenant.Test.Support.Post)
  end

  def changeset(params \\ :empty) do
    params
    |> default_changeset()
  end

  def changeset_with_tenant_id_from_process(params \\ :empty) do
    params 
    |> Repo.inject_tenant_id()
    |> default_changeset()
  end

  defp default_changeset(params) do
    %__MODULE__{}
    |> cast(params, [:name, :body, :post_id, :tenant_id])
  end
end