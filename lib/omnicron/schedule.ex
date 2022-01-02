defmodule Omnicron.Schedule do
  alias Omnicron.Schedule.Cron
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

  defp task({name, %{"command" => command, "cron" => cron, "args" => args}}) do
    command_with_args = ScheduleTask.command_with_args(command, args)

    %ScheduleTask{name: name, command: command_with_args, interval: interval(cron)}
  end

  defp task({name, %{"command" => command, "cron" => cron}}) do
    %ScheduleTask{name: name, command: command, interval: interval(cron)}
  end

  defp interval(cron) do
    %Cron{
      hour: Map.get(cron, "hour", 0),
      minute: Map.get(cron, "minute", 0),
      second: Map.get(cron, "second", 0)
    }
    |> Cron.interval()
  end
end
