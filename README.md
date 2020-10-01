# Telepath

![Master status](https://github.com/wapitea/telepath/workflows/Elixir%20CI/badge.svg?branch=master)

Official documentation: [hexdocs](https://hexdocs.pm/telepath).

## Installation

Add the following lib to your `mix.exs`.

```elixir
def deps do
  [
    {:telepath, "~> 0.1.0"}
  ]
end
```

## Quickstart

Telepath allows you to easily reach data from any elixir struct given a path
(like you do in jsonpath or xpath).

Importing Telepath allows you to use the sigil `~t` to generate the
struct path.

e.g.

``` elixir
~t/hello.world[0]/
# ["hello", "world", 0]
```

With the `a` modifier, you can exctract atoms instead of strings.

e.g.

``` elixir
~t/hello.world[0]/a
# [:hello, :world, 0]
```

When your struct path is generated, you can use the `&Telepath.get/2` function
to access the data.

e.g.

```elixir
import Telepath # for `~t` sigil

data = %{
   node: [%{attr: "value"}, %{attr: "value"}]
}

Telepath.get(data, ~t/node/a)
# [%{node: "value"}, %{node: "value}]

Telepath.get(data, ~t/node.attr/a)
# ["value", "value"]

Telepath.get(data, ~t/node[0]/a)
# %{node: "value"}

Telepath.get(data, ~t/node[0].attr/a)
# "value"

Telepath.get(%{"string_key" => "value"}, ~t/string_key/)
# "value"
```



