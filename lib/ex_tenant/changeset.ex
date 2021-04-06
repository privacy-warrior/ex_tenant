defmodule ExTenant.Changeset do
  @moduledoc """
    ##cast_tenanted(changset, attrs, allowed)

    - injects the `tenant_id` key/atom into the allowed fields
    - retrieves the `tenant_id` value from the process dictionary
    - injects the %{"tenant_id" => tenant_id} into the attrs map
    - and then calls the standard Ecto.Changeset.cast function

    ##An exception will be raised in the following two situations

    - if the `Repo` was not set in the Config.exs file
    - if the tenant_id in the process dictionary is nil

    ##Here is an example

      defmodule Post do
        use ExTenant.Schema
        use ExTenant.Changeset

        ...

        defp changeset(attrs) do
          %__MODULE__{}
          |> cast(params, [:field1, :field1])
        end
      end

  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      import ExTenant.Changeset
      import Ecto.Changeset
    end
  end

  @doc """
    Basically call this like the standard `cast` function and the module
    macros will handle all the `tenant_id` injecting

    ### example

      def changeset(attrs) do
        %__MODULE__{}
        |> cast_tenanted(attrs, [:name, :body])
      end

  """
  defmacro cast_tenanted(changeset, params, allowed) do
    quote bind_quoted: [cs: changeset, params: params, allowed: allowed] do
      # Cast supports both atom and string keys, ensure we're matching on both.
      allowed_param_keys =
        Enum.map(allowed, fn key ->
          case key do
            key when is_binary(key) -> key
            key when is_atom(key) -> Atom.to_string(key)
          end
        end)

      tenanted_param_keys = allowed_param_keys ++ "tenant_id"

      tenanted_allowed =
        [:tenant_id, allowed]
        |> List.flatten()

      tenant_id = retrieve_tenant_id()

      tenanted_params =
        params
        |> convert_params_to_binary()
        |> inject_tenant_into_params(tenant_id)

      Ecto.Changeset.cast(cs, tenanted_params, tenanted_allowed)
    end
  end

  @doc false
  def convert_params_to_binary(params) do
    Enum.reduce(params, nil, fn
      {key, _value}, nil when is_binary(key) ->
        nil

      {key, _value}, _ when is_binary(key) ->
        raise ArgumentError,
              "expected params to be a map with atoms or string keys, " <>
                "got a map with mixed keys: #{inspect(params)}"

      {key, value}, acc when is_atom(key) ->
        Map.put(acc || %{}, Atom.to_string(key), value)
    end) || params
  end

  @doc false
  def inject_tenant_into_params(params, tenant_id) do
    params
    |> Map.put("tenant_id", tenant_id)
  end

  @doc false
  def retrieve_tenant_id do
    case Application.get_env(:ex_tenant, :tenant_repo) do
      nil ->
        raise_no_tenant_id_error(nil)

      repo ->
        repo.get_tenant_id()
        |> raise_no_tenant_id_error()
    end
  end

  defp raise_no_tenant_id_error(nil), do: raise(ExTenant.TenantNotSetError)
  defp raise_no_tenant_id_error(id), do: id
end
