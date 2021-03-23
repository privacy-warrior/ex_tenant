defmodule ExTenant.Test.Support.Tenant do
  use Ecto.Schema
  import Ecto.Changeset
  
  @primary_key {:tenant_id, :id, autogenerate: true}
  schema "tenants" do
    field(:name, :string)   
  end

  def changeset(params \\ :empty) do
    %__MODULE__{}
    |> cast(params, [:name])
  end
end
