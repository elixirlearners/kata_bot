import Config

defmodule KataConfig do
  def env_error(env_var) do
    raise """
      environment variable #{env_var} is missing.
    """
  end
  def get_env(env) do
    System.get_env(env) ||
      env_error(env)
  end
end

config :nostrum,
  token: KataConfig.get_env("DISCORD_TOKEN"),
  gateway_intents: :all

config :kata_bot, ecto_repos: [Kata.Repo]

config :kata_bot, Kata.Repo,
  database: "kata_bot_repo",
  username: KataConfig.get_env("POSTGRES_USERNAME"),
  password: KataConfig.get_env("POSTGRES_PASSWORD"),
  hostname: KataConfig.get_env("POSTGRES_HOSTNAME")
  # OR use a URL to connect instead
  # url: "postgres://postgres:postgres@localhost/ecto_simple"
