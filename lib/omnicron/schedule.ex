defmodule Omnicron.Schedule do
  alias Omnicron.Schedule.Interval
  alias Omnicron.Schedule.Task, as: ScheduleTask

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

  defp task({name, %{"command" => command, "interval" => interval, "args" => args}}) do
    command_with_args = ScheduleTask.command_with_args(command, args)

    %ScheduleTask{name: name, command: command_with_args, interval: task_interval(interval)}
  end

  defp task({name, %{"command" => command, "interval" => interval}}) do
    %ScheduleTask{name: name, command: command, interval: task_interval(interval)}
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
