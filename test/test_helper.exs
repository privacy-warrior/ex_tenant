Code.compiler_options(ignore_module_conflict: true)

# postgres
Mix.Task.run("ecto.drop", ["quiet", "-r", "ExTenant.Test.Support.Schemas.Postgres.PgTestRepo"])
Mix.Task.run("ecto.create", ["quiet", "-r", "ExTenant.Test.Support.Schemas.Postgres.PgTestRepo"])
Mix.Task.run("ecto.migrate", ["quiet", "-r", "ExTenant.Test.Support.Schemas.Postgres.PgTestRepo"])

# mysql
Mix.Task.run("ecto.drop", ["quiet", "-r", "ExTenant.Test.Support.Schemas.Mysql.MyTestRepo"])
Mix.Task.run("ecto.create", ["quiet", "-r", "ExTenant.Test.Support.Schemas.Mysql.MyTestRepo"])
Mix.Task.run("ecto.migrate", ["quiet", "-r", "ExTenant.Test.Support.Schemas.Mysql.MyTestRepo"])

#
# PG --- START
#
# start the repo that just uses Ecto
ExTenant.Test.Support.Schemas.Postgres.PgTestRepo.start_link()

# start the repo that uses ecto & multi-tenancy code
ExTenant.Test.Support.PgTestManualRepo.start_link()

# start the repo that uses ecto & multi-tenancy code - via the ExTenant macro
ExTenant.Test.Support.PgTestRepo.start_link()
#
# PG --- DONE
#

#
# MY --- START
#
# start the repo that just uses Ecto
ExTenant.Test.Support.Schemas.Mysql.MyTestRepo.start_link()

#
# MY --- DONE
#

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(
  ExTenant.Test.Support.Schemas.Postgres.PgTestRepo,
  {:shared, self()}
)
