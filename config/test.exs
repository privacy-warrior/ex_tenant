use Mix.Config
#
# since we are not in a module an anonymous function will do.. (we need a fallback empty string)
#
database_url_env = fn url ->
  env =
    url
    |> System.get_env()

  env || ""
end

# Configure the database_url
pg_database_url =
  "PG_DATABASE_URL"
  |> database_url_env.()
  |> String.replace("?", "#{Mix.env()}")

#
# the repo used to create & test the db schemas without any of our code
#
config :ex_tenant, ExTenant.Test.Support.Schemas.PgTestRepo,
  url: pg_database_url,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox

#
# the repo used to create & test the db schemas without any of our code
#
config :ex_tenant, ExTenant.Test.Support.Schemas.PgTestRepo,
  url: pg_database_url,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox

#
# the repo used to create & test the db schemas using ex_tenant - the code that handles multi tenancy without a macro
#
config :ex_tenant, ExTenant.Test.Support.PgTestManualRepo,
  url: pg_database_url,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox

#
# the repo used to create & test the db schemas using ex_tenant - for testing the macro version
#
config :ex_tenant, ExTenant.Test.Support.PgTestRepo,
  url: pg_database_url,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn
