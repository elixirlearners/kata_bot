defmodule KataBot.Commands do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(init_args) do
    {:ok, init_args}
  end

  def create_kata() do
  end
end