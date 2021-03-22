defmodule ExTenant.Test.Support.Post do
  use Ecto.Schema
  import Ecto.Changeset
  
  schema "posts" do
    field(:name, :string)
    field(:body, :string)

    belongs_to(:tenant, ExTenant.Test.Support.Tenant)

    has_many(:comments, ExTenant.Test.Support.Comment)
  end

  def changeset(params \\ :empty) do
    %__MODULE__{}
    |> cast(params, [:name, :body, :tenant_id])
  end  
end