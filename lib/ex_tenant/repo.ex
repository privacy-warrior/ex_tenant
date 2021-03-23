defmodule ExTenant.Repo do
  @moduledoc """
    before we transition to a macro - we need to work the repo functions manually
  """
  
  use Ecto.Repo, otp_app: :ex_tenant, adapter: Ecto.Adapters.Postgres
  require Ecto.Query

  @tenant_key {__MODULE__, :tenant_id}

  @doc """
    put the tenant_id into the process dictionary - typically this would be called in a Phoenix plug
  """
  def put_tenant_id(tenant_id) do
    Process.put(@tenant_key, tenant_id)
  end

  @doc """
    get the tenant_id from the process dictionary - the default options callback uses it to 
    inject the tenant_id into each query
  """
  def get_tenant_id() do
    Process.get(@tenant_key)
  end

  @doc """
  """
  def default_options(_operation) do
    [tenant_id: get_tenant_id()]
  end  

  @doc """
  """
  def prepare_query(operation, query, opts) do
    inspect_query_data(operation, query, opts)

    cond do
      opts[:skip_tenant_id] || opts[:schema_migration] ->
        {query, opts}
      tenant_id = opts[:tenant_id] ->
        {Ecto.Query.where(query, tenant_id: ^tenant_id), opts}
      true ->
        raise ExTenant.TenantNotSetError
    end
  end

  defp inspect_query_data(operation, query, opts) do
    IO.puts "\n debug operation: #{inspect(operation)}, query: #{inspect(query)}, opts: #{inspect(opts)}"
  end
end