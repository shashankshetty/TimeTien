class Tassk < ActiveRecord::Base
  self.table_name = "tasks"
  belongs_to :tag
  belongs_to :user

  attr_accessor :performance
  validates :tag, :presence => true
  validates :start_time, :presence => true

  validate :validate_start_time_earlier_than_end_time
  validate :validate_time_out

  def validate_start_time_earlier_than_end_time
    if (start_time && end_time)
      errors.add(:end_time, "cannot start earlier than start time") if start_time > end_time
    end
  end

  def validate_time_out
    if (start_time && end_time)
      errors.add(:time_out, "time out cannot be more than or equal to difference between start and end times") if time_spent <= 0
    end
  end

  def time_spent
    return (((end_time || Time.now) - start_time) - (time_out || 0) * 60)
  end

  def my_performance()
    return performance - ((tag.time_allocated || 0) * 60)
  end

  def self.formatted_time(total_seconds)
      total_seconds = total_seconds.abs.to_i

      hours = (total_seconds / 3600)
      minutes = (total_seconds / 60) - (hours * 60)
      seconds = total_seconds % 60
      if (seconds > 30)
        minutes = minutes + 1
      end
      display = ''
      display_concat = ''
      if hours > 0
        display = display + display_concat + "#{hours}hr"
        display_concat = ' '
      end
      if minutes > 0
        display = display + display_concat + "#{minutes}min"
      end
      display
    end
end
