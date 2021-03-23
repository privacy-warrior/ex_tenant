defmodule ExTenant.Support.TestTenantRepository do

  alias ExTenant.Test.Support.{Tenant, Post, Comment, TestRepo}

  #----- functions that DO use the ex_tenant macros ------#


  #----- TestRepo functions that DO NOT use the ex_tenant macros ------#


  def create_tenant(name) do
    %{"name" => name}
    |> Tenant.changeset()
    |> TestRepo.insert()
  end

  def create_post(name, body, tenant_id) do
    %{"name" => name, "body" => body, "tenant_id" => tenant_id}
    |> Post.changeset()
    |> TestRepo.insert()
  end

  def create_comment(name, body, post_id, tenant_id) do
    %{"name" => name, "body" => body, "post_id" => post_id, "tenant_id" => tenant_id}
    |> Comment.changeset()
    |> TestRepo.insert()
  end
end