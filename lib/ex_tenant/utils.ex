defmodule ExTenant.Utils do
  @moduledoc false

  def tenanted_field(), do: Application.get_env(:ex_tenant, :tenanted_field) || "tenant_id"
end
