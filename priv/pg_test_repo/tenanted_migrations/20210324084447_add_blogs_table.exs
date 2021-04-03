  defmodule ExTenant.Test.Support.TestRepo.TenantMigrations.AddBlogsTable do
    @moduledoc """
      
		 add :tenant_id, references(:tenants, column: :tenant_id), null: false
    """

    use Ecto.Migration
    def change do        
    end
  end
