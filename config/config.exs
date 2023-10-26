import Config
config :nostrum,
  token: "<token>",
  gateway_intents: :all

config :kata_bot, ecto_repos: [Kata.Repo]

config :kata_bot, Kata.Repo,
  database: "kata_bot_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
  # OR use a URL to connect instead
  # url: "postgres://postgres:postgres@localhost/ecto_simple"
