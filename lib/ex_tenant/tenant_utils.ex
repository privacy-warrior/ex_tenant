defmodule ExTenant.TenantUtils do
  @moduledoc false

  def retrieve_tenant_from_subdomain(subdomain) do
    get_tenant_func = get_tenant_from_subdomain_func()
    tenant = get_tenant_func.(subdomain)

    if tenant != nil do
      tenant.id
    else
      nil
    end
  end

  def sub_domain(host) do
    host
    |> split_host()
    |> split_domain()
  end

  def get_tenant_from_subdomain_func do
    Application.get_env(:ex_tenant, :get_tenant_from_subdomain_func) ||
      (&ExTenant.TenantUtils.get_tenant_from_subdomain/1)
  end

  def get_tenant_from_subdomain(_subdomain), do: %{id: 1}

  # -------------- private functions ----------------#

  defp split_domain(host) do
    host
    |> String.split(".")
    |> check_length()
    |> List.first()
  end

  defp check_length(host_list) do
    count =
      host_list
      |> Enum.count()

    host_list
    |> count_dots(count)
  end

  defp count_dots(_host_list, 0), do: []

  defp count_dots(_host_list, 1), do: []

  defp count_dots(host_list, _), do: host_list

  defp split_host(host) do
    host
    |> String.split("/")
    |> List.first()
  end
end
