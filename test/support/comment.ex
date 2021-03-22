
defmodule ExTenant.Test.Support.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  
  schema "comments" do
    field(:name, :string)
    field(:body, :string)

    belongs_to(:tenant, ExTenant.Test.Support.Tenant)

    belongs_to(:post, ExTenant.Test.Support.Post)
  end

  def changeset(params \\ :empty) do
    %__MODULE__{}
    |> cast(params, [:name, :body, :post_id, :tenant_id])
  end
end