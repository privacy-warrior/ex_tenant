defmodule ExTenantTenantUtilsTest do
  use ExTenant.Mysql.Cases.UtilsCase

  alias ExTenant.TenantUtils

  setup do
    host = "tenant1.host.com.au"
    host2 = "tenant1.host.com.au/?test=one"
    host3 = "com.au/?test=one"
    host4 = "com/?test=one"

    {:ok, host: host, host2: host2, host3: host3, host4: host4}
  end

  describe "test subdomains" do
    test "splits the host into parts", %{host: host} do
      assert TenantUtils.sub_domain(host) == "tenant1"
    end

    test "splits the host into parts url with params", %{host2: host2} do
      assert TenantUtils.sub_domain(host2) == "tenant1"
    end

    test "splits the host into parts url with params - without the subdomain", %{host3: host3} do
      assert TenantUtils.sub_domain(host3) == "com"
    end

    test "splits the host into parts url with params - the subdomain too short", %{host4: host4} do
      assert TenantUtils.sub_domain(host4) == nil
    end

    test "testing get subdomain", %{host: host} do
      subdomain = TenantUtils.sub_domain(host)
      tenant = TenantUtils.retrieve_tenant_from_subdomain(subdomain)
      assert tenant == 1
    end
  end
end
