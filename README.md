# ExTenant

## Multi Tenancy Library - based on foreign key relationship

## Installation

- The package can be installed by adding `ex_tenant` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_tenant, "~> 0.1.1"}
  ]
end
```

- Run: `mix deps.get && mix deps.compile` to retrieve dependencies & compile

## How to use the library

- Call the `use ExTenant` macro to inject all the required behaviour into your
- Application Repo module to enable all multi-tenancy functions.

Setup
-----

In the application `Config` file the `repo` and `tenanted_field` settings need to be configured.
ExTenant will default the tenanted_field setting to be `tenant_id`.

Config
------

```elixir
  config :ex_tenant,
    tenant_repo: MyAppRepo,
    tenanted_field: "tenant_id",
    get_tenant_from_subdomain_func: &your_application_get_tenant_from_subdomain_function/1
```

- If the `repo` is not configured ExTenant will raise an exception.
- the `get_tenant_from_subdomain_func` is optional if you decide to use the Plug - see example below

Repo
----

- In your application `Repo` file call the `use` macro as per this example

```elixir
  def YourApplication.Repo do
    use ExTenant,
      config: [
        otp_app: :name_of_your_elixir_phoenix_app_as_atom,
        adapter: Ecto.Adapters.Postgres,
        tenanted_field: "tenant_id"
      ]
  end
```

In order to get the `tenant_id` into the progress dictionary in Phoenix
we recommend to use a plug - there you should retrieve the `tenant name`
from something like the `sub domain` in the url. Then using the `tenant name`
retrieve the `tenant`, and call:

- Repo.put_tenant_id(tenant_id)

> To insert the `tenant_id` into the process dictionary.

Plug
----

- An example of how a Plug can be used to insert the tenant_id into the process dictionary

- Take a look at the module `ExTenant.SubdomainPlug`


From here all your Repo callbacks (Repo.get/Repo.one/Repo.all etc) will
have a where clause applied to them with the `tenant_id` injected into the clause.

In order to set the `tenant_id` on `insert` and `update` functions the tenant_id
needs to be inserted into the attributes to be inserted. The `tenanted_schema`
macro & the `tenanted()` function inserts the correct `belongs_to` tenanted foreign
key based relationship.

Further the `cast_tenant` method overloads the standard `Ecto.Changeset.cast` function
by injecting the `tenant_id` into the params and allowed keys. This function raises
exceptions when the `Repo` was not configured correctly in `config.exs` and also
if the `tenant_id` value is not set in the process_dictionary.

Ecto Schema/Changeset
---------------------

```elixir
  defmodule Post do
    use ExTenant.Schema
    use ExTenant.Changeset

    tenanted_schema "posts" do
      field(:name, :string)
      field(:body, :string)

      tenanted()
    end

    defp changeset(attrs) do
      %__MODULE__{}
      |> cast_tenanted(params, [:name, :body])
    end
  end
```

NB: If the `tenant_id` is not set in the changeset, Repo.insert/update callbacks will raise a `Postgrex.Error` (not_null_violation)

Migrations
----------

- documentation to be added.


## Features for Querying the database

- Overrides the Ecto callback `default_options` to inject the `tenant_id`
- Overrides the Ecto callback `prepare_query` to inject the `tenant_id` into a where clause


