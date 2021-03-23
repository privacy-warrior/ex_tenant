defmodule ExTenant.TenantNotSetError do
  defexception message: "expected tenant_id or skip_tenant_id to be set"
end