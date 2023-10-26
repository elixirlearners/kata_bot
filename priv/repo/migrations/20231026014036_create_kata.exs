defmodule Kata.Repo.Migrations.CreateKata do
  use Ecto.Migration

  def change do
    create table(:kata) do
      add :name, :string
      add :question, :string
      add :restrictions, :string
      add :optional_restrictions, :string
      add :input, :string
      add :expected_output, :string
    end
    create unique_index(:kata, [:name])
  end
end
