defmodule ExTenant.Test.Support.TestRepo do
  use Ecto.Repo, otp_app: :ex_tenant, adapter: Ecto.Adapters.Postgres, pool: Ecto.Adapters.SQL.Sandbox
end