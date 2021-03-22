
use Mix.Config

config :ex_tenant, ExTenant.Test.Support.TestRepo,
  hostname: "192.168.98.117",
  database: "ex_tenant_test",
  username: "postgres",
  password: "postgres",
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn