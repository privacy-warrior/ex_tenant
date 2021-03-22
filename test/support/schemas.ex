defmodule ExTenant.Test.Support.Tenant do
  use Ecto.Schema
  import Ecto.Changeset
  
  schema "tenants" do
    field(:name, :string)   
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name))
  end  
end

defmodule ExTenant.Test.Support.Post do
  use Ecto.Schema
  import Ecto.Changeset
  
  schema "posts" do
    field(:name, :string)
    field(:body, :string)

    belongs_to(:tenant, ExTenant.Test.Support.Tenant)

    has_many(:comments, ExTenant.Test.Support.Comment)
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name, body))
  end  
end

defmodule ExTenant.Test.Support.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  
  schema "comments" do
    field(:name, :string)
    field(:body, :string)

    belongs_to(:tenant, ExTenant.Test.Support.Tenant)

    belongs_to(:post, ExTenant.Test.Support.Post)
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name, body))
  end  

end
