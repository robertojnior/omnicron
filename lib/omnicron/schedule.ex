defmodule Omnicron.Schedule do
  alias Omnicron.Schedule.Interval

  defmodule __MODULE__.Task do
    @enforce_keys [:name, :command, :interval]
    defstruct [:name, :command, :interval, args: []]
  end

  def tasks(filepath) do
    filepath
    |> config()
    |> Enum.map(&task/1)
  end

  defp config(filepath) do
    with {:ok, content} <- File.read(filepath),
         {:ok, parsed_config} <- Jason.decode(content) do
      parsed_config
    end
  end

  defp task({name, %{"command" => command, "interval" => interval, "args" => args}})
       when not is_list(args) do
    %__MODULE__.Task{
      name: name,
      command: command,
      args: [args],
      interval: task_interval(interval)
    }
  end

  defp task({name, %{"command" => command, "interval" => interval, "args" => args}}) do
    %__MODULE__.Task{name: name, command: command, args: args, interval: task_interval(interval)}
  end

  defp task({name, %{"command" => command, "interval" => interval}}) do
    %__MODULE__.Task{name: name, command: command, interval: task_interval(interval)}
  end

  defp task_interval(interval) do
    %Interval{
      hour: Map.get(interval, "hour", 0),
      minute: Map.get(interval, "minute", 0),
      second: Map.get(interval, "second", 0)
    }
    |> Interval.milliseconds()
  end
end
