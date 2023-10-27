defmodule KataBot.TestRepo do
  alias Ecto.Changeset
  alias KataBot.Kata

  @kata_db [
    %Kata{
      id: 1,
      name: "Da Whey",
      question: "Do you know da whey my bruduh?",
      input: "yes",
      expected_output: "yes"
    },
    %Kata{
      id: 2,
      name: "List Sort",
      question: "Sort this list.",
      input: "[3,1,2]",
      expected_output: "[1,2,3]"
    },
    %Kata{
      id: 3,
      name: "Zero Division",
      question: "Can you devide by this?",
      input: "0",
      expected_output: "no"
    }
  ]
  def all(Kata, _opts \\ []) do
    @kata_db
  end

  def insert(changeset, opts \\ [])

  def insert(%Changeset{errors: [], changes: values}, _opts) do
    {:ok, struct(Kata, values)}
  end

  def insert(changeset, _opts) do
    {:error, changeset}
  end
end
