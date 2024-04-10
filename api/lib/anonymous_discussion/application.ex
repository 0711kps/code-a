defmodule AnonymousDiscussion.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AnonymousDiscussionWeb.Telemetry,
      AnonymousDiscussion.Repo,
      {DNSCluster, query: Application.get_env(:anonymous_discussion, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AnonymousDiscussion.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AnonymousDiscussion.Finch},
      # Start a worker by calling: AnonymousDiscussion.Worker.start_link(arg)
      # {AnonymousDiscussion.Worker, arg},
      # Start to serve requests, typically the last entry
      AnonymousDiscussionWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AnonymousDiscussion.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AnonymousDiscussionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
