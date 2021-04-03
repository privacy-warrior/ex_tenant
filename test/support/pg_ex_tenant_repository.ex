defmodule ExTenant.Support.PgExTenantRepository do
  alias ExTenant.Test.Support.Schemas.Postgres.{Tenant, Post, Comment}

  # ----- functions that DO use the ex_tenant macros ------#

  def get_post(post_id, repo), do: repo.get(Post, post_id)

  def create_post(name, body, repo) do
    attrs = %{"name" => name, "body" => body}

    {:ok, created_post} =
      attrs
      |> Post.changeset_with_tenant_id_from_process(repo)
      |> repo.insert()

    created_post
  end

  def get_comment(comment_id, repo), do: repo.get(Comment, comment_id)

  def create_comment(name, body, post_id, repo) do
    attrs = %{"name" => name, "body" => body, "post_id" => post_id}

    {:ok, created_comment} =
      attrs
      |> Comment.changeset_with_tenant_id_from_process(repo)
      |> repo.insert()

    created_comment
  end

  def create_tenant(name, repo) do
    %{"name" => name}
    |> Tenant.changeset()
    |> repo.insert()
  end
end
