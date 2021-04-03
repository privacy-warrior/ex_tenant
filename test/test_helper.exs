Code.compiler_options(ignore_module_conflict: true)

Mix.Task.run("ecto.drop", ["quiet", "-r", "ExTenant.Test.Support.Schemas.PgTestRepo"])
Mix.Task.run("ecto.create", ["quiet", "-r", "ExTenant.Test.Support.Schemas.PgTestRepo"])
Mix.Task.run("ecto.migrate", ["quiet", "-r", "ExTenant.Test.Support.Schemas.PgTestRepo"])

# start the repo that just uses Ecto
ExTenant.Test.Support.Schemas.PgTestRepo.start_link()

# start the repo that uses ecto & multi-tenancy code
ExTenant.Test.Support.PgTestManualRepo.start_link()

# start the repo that uses ecto & multi-tenancy code - via the ExTenant macro
ExTenant.Test.Support.PgTestRepo.start_link()

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(ExTenant.Test.Support.Schemas.PgTestRepo, {:shared, self()})
