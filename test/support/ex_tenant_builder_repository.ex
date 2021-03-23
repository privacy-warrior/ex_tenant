defmodule ExTenant.Support.ExTenantBuilderRepository do

  alias ExTenant.Test.Support.{Tenant, Post, Comment}
  alias ExTenant.RepoUsingBuilder, as: Repo

  #----- functions that DO use the ex_tenant macros ------#



  #----- ExTenant.Repo functions that DO NOT use the ex_tenant macros ------#

  def get_post(post_id), do: Repo.get(Post, post_id)

  def create_post(name, body) do
    attrs = %{"name" => name, "body" => body}

    {:ok, created_post} = attrs
    |> Post.changeset_with_tenant_id_from_process()
    |> IO.inspect
    |> Repo.insert()

    created_post
  end

  def get_comment(comment_id), do: Repo.get(Comment, comment_id)

  def create_comment(name, body, post_id) do
    attrs = %{"name" => name, "body" => body, "post_id" => post_id}

    {:ok, created_comment} = attrs
    |> Comment.changeset_with_tenant_id_from_process()
    |> Repo.insert()

    created_comment
  end

  def create_tenant(name) do
    %{"name" => name}
    |> Tenant.changeset()
    |> Repo.insert()
  end

end