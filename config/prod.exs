import Config

config :kata_bot, repo: Kata.Repo

config :kata_bot, Kata.Repo,
  # OR use a URL to connect instead
  url: System.get_env("DATABASE_URL")