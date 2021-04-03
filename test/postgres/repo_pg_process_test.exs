defmodule ExTenantRepoPgProcessTest do
  use ExUnit.Case

  alias ExTenant.Support.PgTestTenantRepository, as: TenantRepo
  alias ExTenant.Test.Support.PgTestManualRepo, as: Repo
  alias ExTenant.Test.Support.Schemas.Postgres.{Post, Comment}

  setup do
    {:ok, tenant} = TenantRepo.create_tenant("foo")
    {:ok, bar_tenant} = TenantRepo.create_tenant("bar")

    #
    # this normally would be handled by a plug in PHX..
    #
    Repo.put_tenant_id(tenant.tenant_id)

    {:ok, post} = TenantRepo.create_post("p1", "pb1", tenant.tenant_id)
    {:ok, comment} = TenantRepo.create_comment("c1", "cb1", post.id, tenant.tenant_id)

    {:ok, post: post, comment: comment, tenant: tenant, bar_tenant: bar_tenant}
  end

  describe "test the schema - tenant_id is in the process" do
    test "get the post", %{post: post, tenant: tenant} do
      retrieved_post = Repo.get(Post, post.id, tenant_id: tenant.tenant_id)
      assert retrieved_post.id == post.id
      assert retrieved_post.tenant_id == tenant.tenant_id
    end

    test "get the post - will also check the tenant_id in the process", %{
      post: post,
      tenant: tenant
    } do
      retrieved_post = Repo.get(Post, post.id)
      assert retrieved_post.id == post.id
      assert retrieved_post.tenant_id == post.tenant_id
      assert retrieved_post.tenant_id == tenant.tenant_id
    end

    test "get the comment - will also check the tenant_id in the process", %{
      comment: comment,
      post: post,
      tenant: tenant
    } do
      retrieved_comment = Repo.get(Comment, comment.id)
      assert retrieved_comment.id == comment.id
      assert retrieved_comment.post_id == post.id
      assert retrieved_comment.tenant_id == comment.tenant_id
      assert retrieved_comment.tenant_id == tenant.tenant_id
    end

    test "attempt to add a comment on tenant-a to a post on tenant-b - raises an exception", %{
      bar_tenant: bar_tenant,
      post: post
    } do
      assert_raise Ecto.ConstraintError, fn ->
        TenantRepo.create_comment("bar_c1", "bar_cb1", post.id, bar_tenant.tenant_id)
      end
    end
  end
end
