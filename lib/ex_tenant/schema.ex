defmodule ExTenant.Schema do
  @moduledoc """

    To use the Extenant.Schema in your schema modules
    -------------------------------------------------

    - it injects the belongs_to relationship to the tenant
    - it also raises a compiler error if the `tenanted()` call was omitted
    - it works with the `tenant_id` field set in Config.exs

    Here is an example
    ------------------

      defmodule Post do
        use ExTenant.Schema
        use ExTenant.Changeset

        tenanted_schema "posts" do
          field(:name, :string)
          field(:body, :string)

          tenanted()
        end
      end

  """
  require Ecto.Schema

  @doc false
  defmacro __using__(_opts) do
    quote do
      import ExTenant.Schema,
        only: [
          tenanted_schema: 2,
          tenanted_embedded_schema: 1,
          tenanted: 0
        ]

      use Ecto.Schema
    end
  end

  @doc """
    injects belongs_to relationship to the tenant model see this example

    tenanted_schema "posts" do
      field(:name, :string)
      tenanted()
    end
  """
  defmacro tenanted do
    owner = __CALLER__.module

    quote do
      Ecto.Schema.belongs_to(:tenant, unquote(owner), references: :tenant_id)
    end
  end

  @doc """
    Replaces `Ecto.Schema.embedded_schema/2` - checking whether `tenanted()` has been
    called - that injects the `belongs_to` tenant relationship
  """
  defmacro tenanted_embedded_schema(do: block) do
    quote do
      Ecto.Schema.embedded_schema do
        unquote(inner(block))
      end
    end
  end

  @doc """
    Replaces `Ecto.Schema.schema/2` - checking whether `tenanted()` has been
    called - that injects the `belongs_to` tenant relationship
  """
  defmacro tenanted_schema(table_name, do: block) do
    quote do
      Ecto.Schema.schema unquote(table_name) do
        unquote(inner(block))
      end
    end
  end

  defp inner(block) do
    quote do
      unquote(apply_to_block(block))
    end
  end

  defp apply_to_block(block) do
    calls =
      case block do
        {:__block__, _, calls} ->
          calls

        call ->
          [call]
      end

    raise_if_tenanted_association_not_exists?(calls)

    {:__block__, [], calls}
  end

  defp raise_if_tenanted_association_not_exists?(calls) do
    calls
    |> Enum.filter(fn n ->
      key = elem(n, 0)
      key == :tenanted
    end)
    |> List.first()
    |> raise_error()
  end

  defp raise_error(nil), do: raise(ExTenant.TenantNotCalledInSchemaError)
  defp raise_error(_), do: :ok
end
