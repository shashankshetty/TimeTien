class Tassk < ActiveRecord::Base
  self.table_name = "tasks"
  belongs_to :tag
  belongs_to :user

  attr_accessor :performance
  validates :tag, :presence => true

  validate :validate_start_time_earlier_than_end_time
  validate :validate_time_out
  validate :validate_start_time

  def validate_start_time_earlier_than_end_time
    if start_time && end_time && task_type == "wt"
      errors.add(:end_time, "cannot start earlier than start time") if start_time > end_time
    end
  end

  def validate_time_out
    if start_time && end_time && task_type == "wt"
      errors.add(:time_out, "cannot be more than the difference between start and end times") if time_spent < 0
    end
  end

  def validate_start_time
    if task_type == "wt" && start_time.blank?
      errors.add(:start_time, "can't be blank")
    elsif task_type == "wnt" && start_time.blank?
      errors.add(:task_date, "can't be blank")
    end
  end

  def validate_additional_time_spent
    if additional_time_spent.blank?
      errors.add(:time_spent, "can't be blank")
    end
  end

  def time_spent
    if task_type == 'wnt'
      (additional_time_spent || 0) * 60
    else
      (((end_time || Time.now) - start_time) - (time_out || 0) * 60)
    end
  end

  def my_performance()
    performance - ((tag.time_allocated || 0) * 60)
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
