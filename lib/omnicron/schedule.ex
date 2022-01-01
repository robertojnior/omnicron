defmodule Omnicron.Schedule do
  alias Omnicron.Schedule.Task, as: ScheduleTask
  alias ScheduleTask.Cron

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

  defp task({name, %{"command" => command, "cron" => interval, "args" => args}}) do
    %ScheduleTask{name: name, command: command, args: args, cron: cron(interval)}
  end

  defp task({name, %{"command" => command, "cron" => interval}}) do
    %ScheduleTask{name: name, command: command, cron: cron(interval)}
  end

  defp cron(interval) do
    %Cron{
      hour: Map.get(interval, "hour", 0),
      minute: Map.get(interval, "minute", 0),
      second: Map.get(interval, "second", 0)
    }
  end
end
