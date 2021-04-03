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
    # here we see an additional way of allowing postgres to use composite foreign
    # keys to ensure a comment in one tenant cannot be added to a post in another tenant!
    #    
    create table(:comments) do
      add :name, :string
      add :body, :string
      #add :post_id, references(:posts), null: false
      #add :tenant_id, references(:tenants, column: :tenant_id), null: false

      add :tenant_id, :integer, null: false
      add :post_id, references(:posts, with: [tenant_id: :tenant_id], match: :full), null: false
    end
  end
end