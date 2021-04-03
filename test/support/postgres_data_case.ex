defmodule ExTenant.Postgres.DataCase do
  @moduledoc """
  """
  use ExUnit.CaseTemplate

  alias ExTenant.Test.Support.Schemas.Postgres.PgTestRepo, as: TestRepo

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestRepo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(
        TestRepo,
        :auto
        # {:shared, self()}
      )
    end

    :ok
  end
end
