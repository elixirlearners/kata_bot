import Config

config :kata_bot, repo: Kata.Repo

config :kata_bot, Kata.Repo,
  database: "kata_bot_repo",
  username: System.get_env("POSTGRES_USERNAME"),
  password: System.get_env("POSTGRES_PASSWORD"),
  hostname: System.get_env("POSTGRES_HOSTNAME")
  # OR use a URL to connect instead
  # url: "postgres://postgres:postgres@localhost/ecto_simple"
