defmodule ExTenant.Repo do
  @moduledoc """
    testing the `use` macro to ensure we create a properly functional repo

    alias ExTenant.Repo

    Repo.put_tenant_id(9)
    Repo.get_tenant_id()

    Repo.inject_tenant_id(%{"name" => "Joe"})
  """
  
  use ExTenant.RepoBuilder, config: [
    otp_app: :ex_tenant, 
    adapter: Ecto.Adapters.Postgres,
    tenanted_field: "tenant_id"
  ]
end