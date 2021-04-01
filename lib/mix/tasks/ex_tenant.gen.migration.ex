defmodule Mix.Tasks.ExTenant.Gen.Migration do
  @moduledoc """
    Generates a migration.

    The repository must be set under `:ecto_repos` in the current app configuration or given via the `-r` option.

    ## Examples
        mix ex_tenant.gen.migration add_posts_table
        mix ex_tenant.gen.migration add_posts_table -r Custom.Repo

    By default, the migration will be generated to the "priv/YOUR_REPO/tenant_migrations" 
    directory of the current application. 
    
    It can be configured to be any subdirectory of `priv` by
    specifying the `:priv` key under the repository configuration.

      ## Command line options
        * `-r`, `--repo` - the repo to generate migration for

  """
  use Mix.Task

  import Macro, only: [camelize: 1, underscore: 1]
  import Mix.Generator
  import Mix.Ecto
  import ExTenant.PathHelper

  @shortdoc "Generates a new migration for tenants"

  @switches [change: :string]

  @doc false
  def run(args) do
    no_umbrella!("ex_tenant.gen.migration")
    repos = parse_repo(args)

    Enum.each repos, fn repo ->
      case OptionParser.parse(args, switches: @switches) do
        {opts, [name], _} ->
          ensure_repo(repo, args)
          path = Path.relative_to(tenanted_migrations_path(repo), Mix.Project.app_path())
          file = Path.join(path, "#{timestamp()}_#{underscore(name)}.exs")
          create_directory path

          tenant_field = :tenant_id
          doc = tenant_assoc(tenant_field)

          assigns = [mod: Module.concat([repo, TenantMigrations, camelize(name)]),
                     change: opts[:change], doc: doc]

          create_file file, migration_template(assigns)
        {_, _, _} ->
          Mix.raise "expected ex_tenant.gen.migration arg = migration-file-name, " <>
                    "got: #{inspect Enum.join(args, " ")}"
      end
    end
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: << ?0, ?0 + i >>
  defp pad(i), do: to_string(i)

  defp tenant_assoc(field) do
    "\n\t\t add :#{field}, references(:tenants, column: :#{field}), null: false"
  end

  embed_template :migration, """
    defmodule <%= inspect @mod %> do
      @moduledoc \"""
        <%= @doc %>
      \"""

      use Ecto.Migration
      def change do        
      end
    end
  """

end