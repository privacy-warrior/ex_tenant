defmodule ExTenantRepoProcessTest do
  use ExUnit.Case

  alias ExTenant.Support.TenantRepo
  alias ExTenant.Repo, as: Repo
  alias ExTenant.Test.Support.{Post, Comment}

  setup do
    {:ok, tenant} = TenantRepo.create_tenant("foo")

    #
    # this normally would be handled by a plug in PHX..
    #
    Repo.put_tenant_id(tenant.tenant_id)

    {:ok, post} = TenantRepo.create_post("p1", "pb1", tenant.tenant_id)
    {:ok, comment} = TenantRepo.create_comment("c1", "cb1", post.id, tenant.tenant_id)

    {:ok, post: post, comment: comment, tenant: tenant}
  end

  describe "test the schema - tenant_id is in the process" do
    test "get the post", %{post: post, tenant: tenant} do
      retrieved_post = Repo.get(Post, post.id, tenant_id: tenant.tenant_id)
      assert retrieved_post.id == post.id
      assert retrieved_post.tenant_id == tenant.tenant_id
    end

    test "get the post - will also check the tenant_id in the process", %{post: post, tenant: tenant} do
      retrieved_post = Repo.get(Post, post.id)
      assert retrieved_post.id == post.id
      assert retrieved_post.tenant_id == post.tenant_id
      assert retrieved_post.tenant_id == tenant.tenant_id
    end

    test "get the comment - will also check the tenant_id in the process", %{comment: comment, post: post, tenant: tenant} do
      retrieved_comment = Repo.get(Comment, comment.id)
      assert retrieved_comment.id == comment.id
      assert retrieved_comment.post_id == post.id
      assert retrieved_comment.tenant_id == comment.tenant_id
      assert retrieved_comment.tenant_id == tenant.tenant_id
    end    
  end
end
