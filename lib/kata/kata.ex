defmodule KataBot.Kata do
  use Ecto.Schema

  schema "kata" do
    field :name, :string
    field :question, :string
    field :restrictions, :string
    field :optional_restrictions, :string
    field :input, :string
    field :expected_output, :string
  end

  def changeset(kata, params \\ %{}) do
    kata
    |> Ecto.Changeset.cast(params, [:name, :question, :restrictions, :optional_restrictions, :input, :expected_output])
    |> Ecto.Changeset.validate_required([:name, :question, :input, :expected_output])
  end
end
