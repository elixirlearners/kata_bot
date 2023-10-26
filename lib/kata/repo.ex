defmodule Kata.Repo do
  use Ecto.Repo,
    otp_app: :kata_bot,
    adapter: Ecto.Adapters.Postgres
end
