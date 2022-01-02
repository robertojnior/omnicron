defmodule Omnicron.Schedule.Task do
  @enforce_keys [:name, :command, :interval]
  defstruct [:name, :command, :interval]

  def command_with_args(command, argument) when is_binary(command) and is_binary(argument) do
    "#{command} #{argument}"
  end

  def command_with_args(command, [head | tail]) when is_binary(command) do
    command_with_args("#{command} #{head}", tail)
  end

  def command_with_args(command, []) when is_binary(command), do: command
end
