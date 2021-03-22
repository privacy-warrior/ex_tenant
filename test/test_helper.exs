ExUnit.start()

Code.compiler_options(ignore_module_conflict: true)

Mix.Task.run "ecto.drop", ["quiet", "-r", "ExTenant.Support.TestRepo"]
Mix.Task.run "ecto.create", ["quiet", "-r", "ExTenant.Support.TestRepo"]

ExTenant.Support.TestRepo.start_link

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(ExTenant.Support.TestRepo, :manual)