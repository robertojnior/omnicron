defmodule Omnicron.Job do
  use GenServer

  alias Omnicron.Crontab
  alias Omnicron.Schedule.Task

  # Client

  def start_link(_state) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Server (callbacks)

  @impl true
  def init(_state) do
    Process.send_after(self(), :start, :timer.seconds(1))

    {:ok, :scheduled}
  end

  # Receives any message from any process
  @impl true
  def handle_info(:start, _state) do
    with tasks <- Crontab.list(),
         :ok <- Enum.each(tasks, &schedule_task/1) do
      {:noreply, tasks}
    end
  end

  def handle_info({:execute, %Task{} = task}, tasks) do
    execute_task(task)

    {:noreply, tasks}
  end

  def execute_task(%Task{} = task) do
    {res, _} = System.cmd(task.command, task.args)

    IO.puts(task.name)
    IO.puts(res)

    schedule_task(task)
  end

  def schedule_task(%Task{} = task) do
    Process.send_after(self(), {:execute, task}, task.interval)
  end
end
