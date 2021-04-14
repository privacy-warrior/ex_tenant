defmodule Mix.Tasks.ExTenant.Migrate do
  use Mix.Task

  @shortdoc "Runs the repository tenanted migrations"

  alias ExTenant.Actions

  @impl true
  def run(args, migrator \\ &Actions.migrate_tenanted/2) do
    migrator.(args, :up)
  end
end
