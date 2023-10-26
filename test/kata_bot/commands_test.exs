defmodule KataBot.CommandsTest do

  use ExUnit.Case
  doctest KataBot.Commands

  test "creates a kata in the database" do
    kata = %KataBot.Kata{name: "test", question: "you good?", input: "yah", expected_output: "nah"}
    assert KataBot.Commands.create_kata(kata) == :ok
  end
end