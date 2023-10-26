defmodule KataBotTest do
  use ExUnit.Case
  doctest KataBot

  test "greets the world" do
    assert KataBot.hello() == :world
  end
end
