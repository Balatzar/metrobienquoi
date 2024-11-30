module ApplicationHelper
  def format_duration(seconds)
    minutes = (seconds / 60).floor
    remaining_seconds = (seconds % 60).floor

    if minutes > 0
      "#{minutes} min #{remaining_seconds} sec"
    else
      "#{remaining_seconds} sec"
    end
  end
end
