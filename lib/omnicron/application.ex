defmodule Omnicron.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Omnicron.Worker.start_link(arg)
      # {Omnicron.Worker, arg}
      Application.fetch_env!(:omnicron, :schedule)
      |> Omnicron.Crontab.child_spec(),
      Omnicron.Job.child_spec([])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Omnicron.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
