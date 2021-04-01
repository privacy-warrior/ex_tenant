
use Mix.Config
#
# the repo used to create & test the db schemas without any of our code
#
database_url = "DATABASE_URL"
|> System.get_env()
|> String.replace("?", "#{Mix.env()}")

# Configure your database
config :ex_tenant, ExTenant.Test.Support.Schemas.TestRepo,
  url: database_url,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox

#
# the repo used to create & test the db schemas using ex_tenant - the code that handles multi tenancy without a macro
#
config :ex_tenant, ExTenant.Test.Support.TestManualRepo,
  url: database_url,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox

#
# the repo used to create & test the db schemas using ex_tenant - for testing the macro version
#
config :ex_tenant, ExTenant.Test.Support.TestRepo,
  url: database_url,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn
