import Config
config :nostrum,
  token: "MTE2NjQ3MTY5Mjk4MjQyMzU4Mg.G-FiwH.uGIikLp9-rYkRHFk162jz8vuuui6Fj0P24AbRw",
  gateway_intents: :all

config :kata_bot, ecto_repos: [Kata.Repo]

config :kata_bot, Kata.Repo,
  database: "kata_bot_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
  # OR use a URL to connect instead
  # url: "postgres://postgres:postgres@localhost/ecto_simple"
