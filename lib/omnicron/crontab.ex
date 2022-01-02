defmodule Omnicron.Crontab do
  use Agent

  alias Omnicron.Schedule

  def start_link(config_filepath) do
    Agent.start_link(fn -> Schedule.tasks(config_filepath) end, name: __MODULE__)
  end

  def list do
    Agent.get(__MODULE__, & &1)
  end
end
