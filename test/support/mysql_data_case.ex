defmodule ExTenant.Mysql.DataCase do
  @moduledoc """
  """
  use ExUnit.CaseTemplate

  alias ExTenant.Test.Support.Schemas.Mysql.MyTestRepo, as: TestRepo

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestRepo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(
        TestRepo,
        :auto
      )
    end

    :ok
  end
end
