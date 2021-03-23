
use Mix.Config

#
# the repo used to create & test the db schemas without ex_tenant
#
config :ex_tenant, ExTenant.Test.Support.TestRepo,
  hostname: "192.168.98.117",
  database: "ex_tenant_test",
  username: "postgres",
  password: "postgres",
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox

#
# the repo used to create & test the db schemas using ex_tenant
#
config :ex_tenant, ExTenant.Repo,
  hostname: "192.168.98.117",
  database: "ex_tenant_test",
  username: "postgres",
  password: "postgres",
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn
