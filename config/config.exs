import Config

config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  gateway_intents: :all

config :kata_bot, ecto_repos: [Kata.Repo]

config :kata_bot, Kata.Repo,
  database: "kata_bot_repo",
  username: System.get_env("POSTGRES_USERNAME"),
  password: System.get_env("POSTGRES_PASSWORD"),
  hostname: System.get_env("POSTGRES_HOSTNAME")

import_config "#{Mix.env()}.exs"
