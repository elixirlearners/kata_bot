defmodule KataBotTest do
  use ExUnit.Case
  doctest KataBot

  test "handles unexpected event without failing" do
    assert KataBot.handle_event({:something_random}) == :noop
  end
end
