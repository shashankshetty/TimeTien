class Tassk < ActiveRecord::Base
  self.table_name = "Tasks"
  belongs_to :tag
  belongs_to :user

  attr_accessor :performance
  validates :tag, :presence => true
  validates :start_time, :presence => true

  validate :validate_start_time_earlier_than_end_time

  def validate_start_time_earlier_than_end_time
    if (start_time && end_time)
      errors.add(:end_time, "cannot start earlier than start time") if start_time > end_time
    end
  end

  def time_spent
    return (end_time || Time.now) - start_time
  end

  def my_performance()
    return performance - ((tag.time_allocated || 0) * 60)
  end
end
