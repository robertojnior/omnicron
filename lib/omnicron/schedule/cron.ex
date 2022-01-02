defmodule Omnicron.Schedule.Cron do
  @hour_in_minutes 60
  @second_in_milliseconds 1000

  defstruct hour: 0, minute: 0, second: 0

  def interval(%__MODULE__{} = cron) do
    minutes = cron.minute + cron.hour * @hour_in_minutes

    seconds = cron.second + minutes * @hour_in_minutes

    seconds * @second_in_milliseconds
  end
end
