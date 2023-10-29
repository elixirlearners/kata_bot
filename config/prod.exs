import Config

config :kata_bot, repo: Kata.Repo

config :kata_bot, Kata.Repo,
  # OR use a URL to connect instead
  socket_options: [:inet6],
  url: System.get_env("DATABASE_URL")
