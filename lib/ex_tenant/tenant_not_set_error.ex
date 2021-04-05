defmodule ExTenant.TenantNotSetError do
  @moduledoc false

  defexception message: "expected tenant_id or skip_tenant_id to be set"
end
