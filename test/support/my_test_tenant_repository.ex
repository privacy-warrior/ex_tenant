defmodule ExTenant.Support.MyTestTenantRepository do
  alias ExTenant.Test.Support.Schemas.Mysql.{Tenant, Post, Comment}
  alias ExTenant.Test.Support.Schemas.Mysql.MyTestRepo

  # ----- TestRepo functions that DO NOT use the ex_tenant macros ------#

  def create_tenant(name) do
    %{"name" => name}
    |> Tenant.changeset()
    |> MyTestRepo.insert()
  end

  def create_post(name, body, tenant_id) do
    %{"name" => name, "body" => body, "tenant_id" => tenant_id}
    |> Post.changeset()
    |> MyTestRepo.insert()
  end

  def create_comment(name, body, post_id, tenant_id) do
    %{"name" => name, "body" => body, "post_id" => post_id, "tenant_id" => tenant_id}
    |> Comment.changeset()
    |> MyTestRepo.insert()
  end
end
