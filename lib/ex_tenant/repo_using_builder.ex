defmodule ExTenant.RepoUsingBuilder do
  @moduledoc """
    testing the `use` macro to ensure we create a properly functional repo

    alias ExTenant.RepoUsingBuilder

    RepoUsingBuilder.put_tenant_id(9)
    RepoUsingBuilder.get_tenant_id()

    RepoUsingBuilder.inject_tenant_id(%{"name" => "Joe"})
  """
  
  use ExTenant.Builder, config: [
    otp_app: :ex_tenant, 
    adapter: Ecto.Adapters.Postgres,
    schema: "tenants", 
    field: "tenant_id"
  ]
end