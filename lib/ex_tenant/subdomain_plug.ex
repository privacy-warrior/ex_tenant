defmodule ExTenant.SubdomainPlug do
  @moduledoc """
  """
  require Logger

  @doc false
  defmacro __using__(_opts) do
    quote do
      import ExTenant.SubdomainPlug, only: [setup: 0, init: 1, call: 2]

      def setup() do
      end

      def init(_opts) do
      end

      def call(conn, _labels) do
        repo = Application.get_env(:ex_tenant, :repo)

        conn
        |> url_value(:host)
        |> ExTenant.TenantUtils.sub_domain()
        |> ExTenant.TenantUtils.retrieve_tenant_from_subdomain()
        |> repo.put_tenant_id()

        conn
      end
    end
  end

  @doc false
  def url_value(conn, :host) do
    quote do
      conn = unquote(conn)
      conn.host
    end
  end
end
