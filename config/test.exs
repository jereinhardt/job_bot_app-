use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :job_bot_app, JobBotWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :job_bot_app, JobBot.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "job_bot_app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
