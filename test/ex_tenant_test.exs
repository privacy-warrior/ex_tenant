defmodule ExTenantTest do
  use ExUnit.Case

  alias ExTenant.Test.Support.{Tenant, Post, Comment}
  alias ExTenant.Support.TestRepo
  
  @migration_version 20_210_111_111_101
  @repos [TestRepo]
  @tenant "foo"

  setup do
    #for repo <- @repos do
      #Ecto.Adapters.SQL.Sandbox.mode(repo, :auto)
      #drop_tenants = fn ->
      #  drop("foo", repo)
      #end
      #drop_tenants.()
      #on_exit(drop_tenants)
    #end

    :ok
  end



  test "greets the world" do
    assert ExTenant.hello() == :world
  end
end
