defmodule ExTenant.TestRepo.Migrations.CreateTestSchemas do
  @moduledoc """
    a simple database schema consisting of tenants, posts and comments each witha a tenant FK
  """

  use Ecto.Migration

  def change do
    create table(:tenants, primary_key: false) do
      add :tenant_id, :bigserial, primary_key: true
      add :name, :string
    end

    create table(:posts) do
      add :name, :string
      add :body, :string

      add :tenant_id, references(:tenants, column: :tenant_id), null: false
    end

    create unique_index(:posts, [:id, :tenant_id])

    #
    # Mysql does not support the complex foreign keys using match the way postgres does
    #
    create table(:comments) do
      add :name, :string
      add :body, :string
      add :post_id, references(:posts), null: false
      add :tenant_id, references(:tenants, column: :tenant_id), null: false
    end
  end
end
