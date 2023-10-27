defmodule Release.Tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:kata_bot)

    path = Application.app_dir(:kata_bot, "priv/repo/migrations")

    Ecto.Migrator.run(Kata.Repo, path, :up, all: true)

    :init.stop()
  end
end
