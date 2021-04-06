defmodule ExTenant.Changeset do
  @moduledoc false

  @doc false
  defmacro __using__(_opts) do
    quote do
      import ExTenant.Changeset
      import Ecto.Changeset
    end
  end

  @doc """
  TODO: document this!
  """
  defmacro cast_tenanted(changeset_or_data, params, allowed) do
    caller = __CALLER__.module

    quote bind_quoted: [
            changeset_or_data: changeset_or_data,
            params: params,
            allowed: allowed,
            calling_module: caller
          ] do
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

      Ecto.Changeset.cast(changeset_or_data, tenanted_params, tenanted_allowed)
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
