defmodule ExTenant.Test.Support.Repos.PgTestRepo do
  @moduledoc """
    testing the `use` macro to ensure we create a properly functional repo

    alias ExTenant.Test.Support.TestRepo

    TestRepo.put_tenant_id(9)
    TestRepo.get_tenant_id()

    TestRepo.inject_tenant_id(%{"name" => "Joe"})
  """

  use ExTenant,
    config: [
      otp_app: :ex_tenant,
      adapter: Ecto.Adapters.Postgres,
      tenanted_field: "tenant_id"
    ]
end
