defmodule ExTenant.Support.TestRepo do
  use Ecto.Repo, otp_app: :ex_tenant, adapter: Ecto.Adapters.Postgres
end