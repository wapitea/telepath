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
end
