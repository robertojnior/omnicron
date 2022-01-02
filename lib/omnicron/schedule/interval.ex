defmodule Omnicron.Schedule.Interval do
  defstruct hour: 0, minute: 0, second: 0

  def milliseconds(%__MODULE__{} = interval) do
    :timer.hours(interval.hour) +
      :timer.minutes(interval.minute) +
      :timer.seconds(interval.second)
  end
end
