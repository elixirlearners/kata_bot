defmodule KataBot.Commands do
  @moduledoc """
  Used to process CRUD style commands for Kata. Most commands
  either take or return a `%KataBot.Kata{}` struct.  

  ## Examples

    iex> kata = %KataBot.Kata{name: "my kata", question: "you good?",
    ...> input: "nah", expected_output: "yah"} 
    ...> KataBot.Commands.create_kata(kata)
    :ok
  """
  @repo Application.compile_env(:kata_bot, :repo)
  require Ecto.Query
  alias KataBot.Kata
  use GenServer

  @impl true
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @doc """
  Adds a new Kata to the database. Takes in a `%KataBot.Kata{}`
  and returns `:ok` on success and `{:error, error_msg}` on failure.   
  A possible failure case is trying to create a Kata with a name
  that already exsists. This would return `{:error, "name has already been taken"}`

  ## Examples

    iex> kata = %KataBot.Kata{name: "my kata", question: "you good?",
    ...> input: "nah", expected_output: "yah"} 
    ...> KataBot.Commands.create_kata(kata)
    :ok
  """
  def create_kata(kata) do
    GenServer.call(__MODULE__, {:create_kata, kata})
  end

  @doc """
  Returns a list of `%KataBot.Kata{}`

  ## Examples

    iex> KataBot.Commands.list_kata
    {
      :ok,
      [
        %KataBot.Kata{id: 1, name: "Da Whey", question: "Do you know da whey my bruduh?", restrictions: nil, optional_restrictions: nil, input: "yes", expected_output: "yes"},
        %KataBot.Kata{id: 2, name: "List Sort", question: "Sort this list.", restrictions: nil, optional_restrictions: nil, input: "[3,1,2]", expected_output: "[1,2,3]"},
        %KataBot.Kata{id: 3, name: "Zero Division", question: "Can you devide by this?", restrictions: nil, optional_restrictions: nil, input: "0", expected_output: "no"}
      ]
    }
  """
  def list_kata() do
    GenServer.call(__MODULE__, :list)
  end

  def rand_kata() do
    GenServer.call(__MODULE__, :rand_kata)
  end

  def get_kata(id) do
    GenServer.call(__MODULE__, {:get_kata, id})
  end

  @doc """
  Returns a list of all Kata ids
  """
  def get_ids do
    query =
      Ecto.Query.from(Kata,
        select: [:id]
      )

    @repo.all(query)
  end

  @impl true
  def handle_call({:get_kata, id}, _from, state) do
    case Kata |> @repo.get(id) do
      nil -> {:reply, {:error, "**Error:** ID:#{id} not found"}, state}
      kata -> {:reply, {:ok, kata}, state}
    end
  end

  @impl true
  def handle_call(:rand_kata, _from, state) do
    %{id: id} = get_ids() |> Enum.random()
    kata = Kata |> @repo.get(id)
    {:reply, {:ok, kata}, state}
  end

  @impl true
  def handle_call(:list, _from, state) do
    {:reply, {:ok, Kata |> @repo.all()}, state}
  end

  @impl true
  def handle_call({:create_kata, kata}, _from, state) do
    case kata |> Kata.changeset() |> @repo.insert() do
      {:ok, _} -> {:reply, :ok, state}
      {:error, error} -> {:reply, {:error, get_error_msg(error)}, state}
    end
  end

  def get_error_msg(%Ecto.Changeset{errors: [name: {msg, _}]}) do
    "name #{msg}"
  end
end
