defmodule ExTenant.RepoBuilder do
  @moduledoc """
    by calling the `use` macro we should be able to inject all the required behaviour
    to allow us to handle multi-tenancy - most of it at least - apart from

    (1) placing the `tenant_id` into the process dictionary in Phoenix
      --> we should create a `use macro` for a plug for this
    (2) injecting the `tenant_id` into the changeset for creating & updating structs like this

      def changeset_with_tenant_id_from_process(params \\ :empty) do
        params 
        |> Repo.inject_tenant_id()
        |> default_changeset()
      end

      defp default_changeset(params) do
        %__MODULE__{}
        |> cast(params, [:name, :body, :tenant_id])
      end 
  """
  
  defmacro __using__(opts) do
    config = Keyword.get(opts, :config)
    tenanted_field = config[:tenanted_field]
    application = config[:otp_app]
    database_adapter = config[:adapter]
    tenant_key = {__CALLER__.module, String.to_atom(tenanted_field)}

    quote do
      import ExTenant.RepoBuilder
      require Ecto.Query
      use Ecto.Repo, otp_app: unquote(application), adapter: unquote(database_adapter)

      generate_put_tenant_function(unquote(tenant_key))
      generate_get_tenant_function(unquote(tenant_key))
      generate_default_options_callback()
      generate_inject_tenant_id_callback(unquote(tenanted_field))
      generate_prepare_query_callback()
    end    
  end

  @doc """
    generate a function signature that does this

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
  """
  defmacro generate_prepare_query_callback() do
    quote do
      def prepare_query(operation, query, opts) do 
        cond do
          opts[:skip_tenant_id] || opts[:schema_migration] ->
            {query, opts}
          tenant_id = opts[:tenant_id] ->
            {Ecto.Query.where(query, tenant_id: ^tenant_id), opts}
          true ->
            raise ExTenant.TenantNotSetError
        end
      end
    end
  end

  @doc """
    generate a function signature that does this..

    def inject_tenant_id(params) do 
      params    
      |> params_as_string_based()
      |> Map.put("tenant_id", get_tenant_id())
    end
  """
  defmacro generate_inject_tenant_id_callback(tenant_field) do
    quote do
      def inject_tenant_id(params) do
        string_params = for {key, val} <- params, into: %{}, do: {"#{key}", val}

        string_params
        |> Map.put(unquote(tenant_field), get_tenant_id())        
      end
    end
  end

  @doc """
    generate a function signature that does this..

    def default_options(_operation) do
      [tenant_id: get_tenant_id()]
    end
  """
  defmacro generate_default_options_callback() do
    quote do
      def default_options(_operation) do
        [tenant_id: get_tenant_id()]
      end  
    end
  end

  @doc """
    generate a function signature that does this..
    @tenant_key is handled through the incoming attrs

      def put_tenant_id(tenant_id) do
        Process.put(@tenant_key, tenant_id)
      end
  """
  defmacro generate_put_tenant_function(tenant_key) do
    quote do
      def put_tenant_id(tenant_id) do
        Process.put(unquote(tenant_key), tenant_id)
      end  
    end
  end

  @doc """
    generate a function signature that does this..
    @tenant_key is handled through the incoming attrs

    def get_tenant_id() do
      Process.get(@tenant_key)
    end
  """
  defmacro generate_get_tenant_function(tenant_key) do
    quote do
      def get_tenant_id() do
        Process.get(unquote(tenant_key))
      end  
    end
  end

  #defp inspect_query_data(operation, query, opts) do
  #  Logger.debug "\n debug operation: #{inspect(operation)}, query: #{inspect(query)}, opts: #{inspect(opts)}"
  #end
end