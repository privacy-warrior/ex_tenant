defmodule ExTenant.TestRepo.Migrations.CreateTestSchemas do
  use Ecto.Migration

  def change do
    create table(:tenants) do
      add :name, :string
    end

    create table(:posts) do
      add :name, :string
      add :body, :string

      add :tenant_id, references(:tenants), null: false
    end

    create table(:comments) do
      add :name, :string
      add :body, :string
      add :post_id, references(:posts), null: false

      add :tenant_id, references(:tenants), null: false
    end
  end
end