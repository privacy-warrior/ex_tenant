
Code.compiler_options(ignore_module_conflict: true)

Mix.Task.run "ecto.drop", ["quiet", "-r", "ExTenant.Test.Support.TestRepo"]
Mix.Task.run "ecto.create", ["quiet", "-r", "ExTenant.Test.Support.TestRepo"]
Mix.Task.run "ecto.migrate", ["quiet", "-r", "ExTenant.Test.Support.TestRepo"]

ExTenant.Test.Support.TestRepo.start_link
ExTenant.Repo.start_link

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(ExTenant.Test.Support.TestRepo, {:shared, self()})