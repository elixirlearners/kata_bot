defmodule ListToRepo do
  use Toml.Transform

  def transform(_key, value) when is_list(value) do
    Enum.map(value, fn q -> 
      struct(KataBot.Kata, q)
    end)
  end
  def transform(_key, value), do: value
end

defmodule Questions do
  @file_path "questions.toml"
  use GenServer

  @impl true
  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(state) do
    load()
    {:ok, state}
  end

  defstruct question: [
    %{
      expected_output: "",
      input: "",
      name: "",
      optional_restrictions: "",
      question: "",
      restrictions: ""
    }
  ]

  def load do
    Enum.each(read(), fn kata ->  
      case Kata.Repo.get_by(KataBot.Kata, name: kata.name) do
        nil ->
          Kata.Repo.insert(kata)
        record ->
          %{kata | id: record.id}
          |> KataBot.Kata.changeset()
          |> Kata.Repo.update([id: record.id])
      end
    end)
  end

  def read do 
    results = case Toml.decode_file(@file_path, keys: :atoms, transforms: [ListToRepo]) do
      {:ok, result} -> result
      {:error, reason} -> raise "Unable to read questions file: #{reason}"
    end
    results.question
  end
end


