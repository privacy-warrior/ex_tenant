# ExTenant

## Multi Tenancy Library - based on foreign key relationship

## Features for Querying the database

- Overrides the Ecto callback `default_options` to inject the `tenant_id`
- Overrides the Ecto callback `prepare_query` to inject the `tenant_id` into a where clause


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
