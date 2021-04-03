defmodule ExTenant.Test.Support.PgTestManualRepo do
  @moduledoc """
    before we transition to a macro - we need to work the repo functions manually
  """

  use Ecto.Repo, otp_app: :ex_tenant, adapter: Ecto.Adapters.Postgres
  require Ecto.Query
  require Logger

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
    the default_options callback is always called and
    allows us to inject the tenant_id from the process dictionary
  """
  def default_options(_operation) do
    [tenant_id: get_tenant_id()]
  end

  @doc """
    the prepare_query callback allows us to inject the actual tenant_id into the query
    as a where clause OR raise an exception - which allows us to enforce the tenancy
    and yet we can use the standard Repo based callbacks from Ecto - basically the
    multi-tenancy get's out of the developers way! & finally we avoid it during migrations!
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

  @doc """
    this function can be used to inject the tenant_id into
    for example a Phoenix based params hash - we could naturally also
    do this in a plug - but it is preferable to have this handled
    at a lower level and not have phoenix worry about any more than
    actually placing the tenant_id into the process dictionary!
  """
  def inject_tenant_id(params) do
    params
    |> params_as_string_based()
    |> Map.put("tenant_id", get_tenant_id())
  end

  defp inspect_query_data(operation, query, opts) do
    Logger.debug(
      "\n debug operation: #{inspect(operation)}, query: #{inspect(query)}, opts: #{inspect(opts)}"
    )
  end

  defp params_as_string_based(params),
    do: for({key, val} <- params, into: %{}, do: {"#{key}", val})
end
