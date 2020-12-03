defmodule Telepath do
  @moduledoc """
  Provide an easy way to access elixir's data struct with a path.

  Inspired by JsonPath & xPath (for json and xml), Telepath allows you to reach
  the data that you want, simply by specifying a path.

  > The path can be created using the sigil: ~t (see `Telepath.sigil_t/2`).
  """

  @type path :: [String.t() | atom | number]
  @regex ~r/^\w+|[0-9]+|\*/

  @doc """
  Transform the struct path to an array that defines how to
  access the data.

  > Use `~t` instead of `&Telepath.sigil_t/2`.

  ## Modifiers

  The modifiers available when creating a Telepath are:

  - atom (a) - enable atom keys for path exploration.

  ## Special characters

  - `*`: will be transform to `:*` (see `*` in `Telepath.get/3`)

  ## Examples

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

      iex> Telepath.sigil_t("node.*.attr1")
      ["node", :*, "attr1"]


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

      cond do
        node == "*" ->
          [:* | array_pos]

        Enum.member?(opts, ?a) ->
          [String.to_atom(node) | array_pos]

        true ->
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

  Telepath.get(%{foo: [%{bar: "bar1"}, %{bar: "bar2"}]}, ~t/*/a)
  # [%{bar: "bar1"}, %{bar: "bar2"}]
  ```

  If you want to map every case in the path, you can use `:*`.

  e.g.

  ```elixir
  Telepath.get(
    %{data: %{key1: "value1", key2: "value2"}},
    ~t/data.*/a
  )
  # ["value1", "value2"]
  ```

  > See `sigil_t/2` for more informations on path.

  ### opts

  - `flatten` Return a flattened list (works only if the result of telepath is a list) (default `false`).
  """

  def get(data, path, opts \\ []) do
    result = do_get(data, path)

    if is_list(result) && Keyword.get(opts, :flatten) do
      List.flatten(result)
    else
      result
    end
  end

  @spec do_get(data :: any, path :: __MODULE__.path()) :: any
  defp do_get(data, _path = []), do: data

  defp do_get(data, _) when not is_map(data) and not is_list(data) do
    nil
  end

  defp do_get(data, [:* | path]) when is_map(data) do
    Enum.map(data, fn {_k, v} -> get(v, path) end)
  end

  defp do_get(data, [:* | path]) when is_list(data) do
    if Keyword.keyword?(data) do
      data
      |> Keyword.values()
      |> get(path)
    else
      Enum.map(data, &get(&1, path))
    end
  end

  defp do_get(data, [x | path]) when is_list(data) and is_integer(x) do
    data |> Enum.at(x) |> get(path)
  end

  defp do_get(data, [x | path]) when is_list(data) do
    if Keyword.keyword?(data) do
      data
      |> Keyword.get_values(x)
      |> get(path)
    else
      Enum.map(data, &get(&1, [x | path]))
    end
  end

  defp do_get(data, [x | expresion]) when is_map(data) do
    data
    |> Map.get(x)
    |> get(expresion)
  end
end
