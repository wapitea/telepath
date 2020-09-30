# Telepath

Telepath allows you to easily reach data from any elixir struct given a path
(like you do in jsonpath or xpath).

# Examples

```elixir
data = %{
   node: [%{attr: "value"}, %{attr: "value}]
}

$.data => [%{titi: “value”}, %{titi: “value}]
$.data.titi => [“value”, “value”]
$.data[0] => %{titi: “value”}
$.data[0].titi => “value”
```

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `telepath` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:telepath, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/telepath](https://hexdocs.pm/telepath).

