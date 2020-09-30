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

# Quickstart

Telepath allows you to easily reach data from any elixir struct given a path
(like you do in jsonpath or xpath).

Importing Telepath allows you to use the sigil `~t` to generate the
struct path.

e.g.

``` elixir
~t/hello.world[0]/
# ["hello", "world", 0]
```

Can also be use using atom with `a` modifier.

e.g.

``` elixir
~t/hello.world[0]/a
# [:hello, :world, 0]
```

When your struct path is generate you can use the `&Telepath.get/2` function
to access to the data

e.g.

```elixir
import Telepath # for `~r` sigil

data = %{
   node: [%{attr: "value"}, %{attr: "value"}]
}

Telepath.get(data, ~t/data/a)
# [%{titi: "value"}, %{titi: "value}]

Telepath.get(data, ~t/data.titi/a)
# ["value", "value"]

Telepath.get(data, ~t/data[0]/a)
# %{titi: "value"}

Telepath.get(data, ~t/data[0].titi/a)
# "value"

Telepath.get(%{"string_key" => "value"}, ~t/string_key/)
# "value"
```



