defmodule ExTenantRepoTest do
  use ExUnit.Case

  alias ExTenant.Support.TestTenantRepository, as: TenantRepo
  alias ExTenant.Test.Support.TestManualRepo, as: Repo
  alias ExTenant.Test.Support.Schemas.{Tenant, Post, Comment}

  setup do
    {:ok, tenant} = TenantRepo.create_tenant("foo")
    {:ok, post} = TenantRepo.create_post("p1", "pb1", tenant.tenant_id)
    {:ok, comment} = TenantRepo.create_comment("c1", "cb1", post.id, tenant.tenant_id)

    {:ok, tenant: tenant, post: post, comment: comment}
  end

  describe "test the schema - by injecting the tenant_id" do
    test "get the post", %{post: post, tenant: tenant} do
      retrieved_post = Repo.get(Post, post.id, tenant_id: tenant.tenant_id)
      assert retrieved_post.id == post.id
      assert retrieved_post.tenant_id == tenant.tenant_id
    end

    test "attempts to get the post without the tenant_id", %{post: post} do
      assert_raise ExTenant.TenantNotSetError, fn ->
        Repo.get(Post, post.id)
      end      
    end

    test "get the comment", %{comment: comment, post: post, tenant: tenant} do
      retrieved_comment = Repo.get(Comment, comment.id, tenant_id: tenant.tenant_id)
      assert retrieved_comment.id == comment.id
      assert retrieved_comment.post_id == post.id
      assert retrieved_comment.tenant_id == tenant.tenant_id
    end

    test "attempts to get the comment without the tenant_id", %{comment: comment} do
      assert_raise ExTenant.TenantNotSetError, fn ->
        Repo.get(Comment, comment.id)
      end      
    end
  end

  describe "test the schema - getting tenants by skipping the tenant_id" do
    test "retrieves all tenants" do
      tenant_count = Tenant
      |> Repo.all(skip_tenant_id: true) 
      |> Enum.count()

      assert tenant_count > 0
    end

    test "retrieves the tenant when skip is set", %{tenant: tenant} do
      retrieved_tenant = Repo.get(Tenant, tenant.tenant_id, skip_tenant_id: true)

      assert retrieved_tenant.tenant_id == tenant.tenant_id
      assert retrieved_tenant.name == tenant.name
    end

    test "retrieves the tenant - when skip is not set due to the new pkey", %{tenant: tenant} do
      retrieved_tenant = Repo.get(Tenant, tenant.tenant_id, tenant_id: tenant.tenant_id)

      assert retrieved_tenant.tenant_id == tenant.tenant_id
      assert retrieved_tenant.name == tenant.name
    end

  end
end
