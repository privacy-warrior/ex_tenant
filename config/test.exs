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

# Configure the database_url for postgres
pg_database_url =
  "PG_DATABASE_URL"
  |> database_url_env.()
  |> String.replace("?", "#{Mix.env()}")

# Configure the database_url for mysql
my_database_url =
  "MY_DATABASE_URL"
  |> database_url_env.()
  |> String.replace("?", "#{Mix.env()}")

# ---------- POSTGRES ---------- #

#
# PG: the repo used to create & test the db schemas without any of our code
#
config :ex_tenant, ExTenant.Test.Support.Schemas.Postgres.PgTestRepo,
  url: pg_database_url,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox

#
# PG: the repo used to create & test the db schemas using ex_tenant - the code that handles multi tenancy without a macro
#
config :ex_tenant, ExTenant.Test.Support.Repos.PgTestManualRepo,
  url: pg_database_url,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox

#
# PG: the repo used to create & test the db schemas using ex_tenant - for testing the macro version
#
config :ex_tenant, ExTenant.Test.Support.Repos.PgTestRepo,
  url: pg_database_url,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox

# ---------- MYSQL ---------- #

#
# MySQL: the repo used to create & test the db schemas without any of our code
#
config :ex_tenant, ExTenant.Test.Support.Schemas.Mysql.MyTestRepo,
  url: my_database_url,
  adapter: Ecto.Adapters.MyXQL,
  pool: Ecto.Adapters.SQL.Sandbox

#
# PG: the repo used to create & test the db schemas using ex_tenant - the code that handles multi tenancy without a macro
#
config :ex_tenant, ExTenant.Test.Support.Repos.MyTestManualRepo,
  url: my_database_url,
  adapter: Ecto.Adapters.MyXQL,
  pool: Ecto.Adapters.SQL.Sandbox

#
# PG: the repo used to create & test the db schemas using ex_tenant - for testing the macro version
#
config :ex_tenant, ExTenant.Test.Support.Repos.MyTestRepo,
  url: my_database_url,
  adapter: Ecto.Adapters.MyXQL,
  pool: Ecto.Adapters.SQL.Sandbox

#
# TODO add this into the DOCU - i.e. the config of the Repo!
#
# AND we also need to doc and fix the `tenanted_field` from here!
#
config :ex_tenant,
  tenant_repo: ExTenant.Test.Support.Repos.PgTestRepo,
  tenanted_field: "tenant_id",
  get_tenant_from_subdomain_func: &ExTenant.TenantUtils.get_tenant_from_subdomain/1

config :logger, level: :warn
