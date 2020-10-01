defmodule Telepath do
  @moduledoc """
  Provide an easy way to access elixir's data struct with a path.

  Inspired by JsonPath & xPath (for json and xml), Telepath allows you to reach
  the data that you want, simply by specifying a path.

  > The path can be created using the sigil: ~t (see `Telepath.sigil_t/2`).
  """

  @type path :: [String.t() | atom | number]
  @regex ~r/^\w+|[0-9]+/

  @doc """
  Transform the struct path to an array that defines how to
  access the data.

  > Use `~t` instead of `&Telepath.sigil_t/2`.

  ## Modifiers

  The modifiers available when creating a Telepath are:

  - atom (a) - enable atom keys for path exploration.

  E.g
      iex> Telepath.sigil_t("node")
      ["node"]

      iex> Telepath.sigil_t("node.attr1")
      ["node", "attr1"]

      iex> Telepath.sigil_t("node[0]")
      ["node", 0]

      iex> Telepath.sigil_t("node[0].attr1")
      ["node", 0, "attr1"]

      iex> Telepath.sigil_t("node.0.attr1")
      ["node", "0", "attr1"]


  With the sigil `~t` it will be as simple as:

  ```elixir
  ~t/data/
  # ["data"]

  ~t/data/a
  # [:data]
  ```
  """
  @spec sigil_t(String.t(), List.t()) :: __MODULE__.path()
  def sigil_t(string, opts \\ []) do
    String.split(string, ".")
    |> Enum.map(fn p ->
      [node | array_pos] =
        @regex
        |> Regex.scan(p)
        |> List.flatten()

      array_pos = Enum.map(array_pos, &String.to_integer/1)

      if Enum.member?(opts, ?a) do
        [String.to_atom(node) | array_pos]
      else
        [node | array_pos]
      end
    end)
    |> List.flatten()
  end

  @doc """
  Obtains a data at a given path.

  ```elixir
  Telepath.get(%{hello: "world"}, ~t/hello/a)
  # "world"

  Telepath.get(%{foo: [%{bar: "bar1"}, %{bar: "bar2"}]}, ~t/foo.bar/a)
  # ["bar1", "bar2"]

  # works also with string key
  Telepath.get(%{"foo" => [%{"bar" => "bar1"}, %{"bar" => "bar2"}]}, ~t/foo.bar/)
  # ["bar1", "bar2"]

  Telepath.get(%{foo: [%{bar: "bar1"}, %{bar: "bar2"}]}, ~t/foo/a)
  # [%{bar: "bar1"}, %{bar: "bar2"}]
  ```

  > See `sigil_t/2` for more informations on path.
  """
  @spec get(data :: any, path :: __MODULE__.path()) :: any
  def get(data, _path = []), do: data

  def get(data, _) when not is_map(data) and not is_list(data) do
    nil
  end

  def get(data, [x | path]) when is_list(data) and is_integer(x) do
    data
    |> Enum.at(x)
    |> get(path)
  end

  def get(data, [x | path]) when is_list(data) do
    if Keyword.keyword?(data) do
      data
      |> Keyword.get_values(x)
      |> get(path)
    else
      Enum.map(data, &get(&1, [x | path]))
    end
  end

  def get(data, [x | expresion]) when is_map(data) do
    data
    |> Map.get(x)
    |> get(expresion)
  end
end
