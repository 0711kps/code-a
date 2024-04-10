defmodule AnonymousDiscussion.Repo do
  use Ecto.Repo,
    otp_app: :anonymous_discussion,
    adapter: Ecto.Adapters.Postgres
end
