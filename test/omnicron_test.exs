defmodule OmnicronTest do
  use ExUnit.Case
  doctest Omnicron

  test "greets the world" do
    assert Omnicron.hello() == :world
  end
end
