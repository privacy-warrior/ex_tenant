defmodule ExTenant.TenantNotCalledInSchemaError do
  @moduledoc false

  defexception message: "expected schema to call tenanted() function to include tenant_id!"
end
