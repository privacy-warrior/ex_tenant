defmodule ExTenant.Postgres.Tenanted.DataCase do
  @moduledoc """
  """
  use ExUnit.CaseTemplate

  alias ExTenant.Test.Support.PgTestRepo, as: TestRepo

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
