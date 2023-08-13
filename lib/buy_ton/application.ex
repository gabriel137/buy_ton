defmodule BuyTon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BuyTonWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: BuyTon.PubSub},
      # Start Finch
      {Finch, name: BuyTon.Finch},
      # Start the Endpoint (http/https)
      BuyTonWeb.Endpoint
      # Start a worker by calling: BuyTon.Worker.start_link(arg)
      # {BuyTon.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BuyTon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BuyTonWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
