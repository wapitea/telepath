defmodule TelepathTest do
  use ExUnit.Case
  doctest Telepath
  import Telepath

  @simple_data %{
    "node" => [
      %{"attr1" => "attr1-value"},
      %{"attr1" => "attr1-value", "attr2" => "attr2-value"}
    ]
  }

  test "access to first node" do
    assert Telepath.get(@simple_data, ~t(node)) == [
             %{"attr1" => "attr1-value"},
             %{"attr1" => "attr1-value", "attr2" => "attr2-value"}
           ]
  end

  test "access to node.attr1" do
    assert Telepath.get(@simple_data, ~t(node.attr1)) == ["attr1-value", "attr1-value"]
  end

  test "access to node[0]" do
    assert Telepath.get(@simple_data, ~t(node[0])) == %{"attr1" => "attr1-value"}
  end

  test "access to node[0].attr1" do
    assert Telepath.get(@simple_data, ~t(node[0].attr1)) == "attr1-value"
  end

  test "access to node.attr2" do
    assert Telepath.get(@simple_data, ~t(node.attr2)) == [nil, "attr2-value"]
  end

  test "access to node[1].attr2" do
    assert Telepath.get(@simple_data, ~t(node[1].attr2)) == "attr2-value"
  end

  test "flatten a list" do
    data = %{
      node: [%{subnode: ["data1", "data2"]}, %{subnode: ["data3", "data4"]}]
    }

    assert Telepath.get(data, ~t(node.subnode)a, flatten: true) == [
             "data1",
             "data2",
             "data3",
             "data4"
           ]
  end

  test "flatten a map" do
    data = %{
      node: %{subnode: ["data1", "data2"]}
    }

    assert Telepath.get(data, ~t(node)a, flatten: true) == %{subnode: ["data1", "data2"]}
  end

  test "every on map" do
    result =
      Telepath.get(
        %{data: %{key1: "value1", key2: "value2"}},
        ~t/data.*/a
      )

    assert result == ["value1", "value2"]
  end

  test "every on array" do
    result =
      Telepath.get(
        [[%{bar: "bar1"}, %{bar: "bar2"}], [%{bar: "bar3"}]],
        ~t/*.bar/a
      )

    assert result == [["bar1", "bar2"], ["bar3"]]
  end
end
