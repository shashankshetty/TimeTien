class Tag < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :tasks, :class_name => "Tassk", :dependent => :destroy

  validates :name, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :uniqueness => {:scope => :name}
  validates_length_of :name, :maximum => 50
  validates_length_of :description, :maximum => 250

  validates_numericality_of :pay_rate, :greater_than => 0, :less_than => 10000, :allow_nil => true

  validate :validate_complete_within

  def validate_complete_within
    if complete_within
      errors.add(:complete_within, "cannot be checked if Time allocated is blank or incomplete") if (time_allocated.blank? || frequency.blank?)
    end
  end

  def total_time_taken
    tasks.flatten.map(&:time_spent).sum
  end

  def billable_amount
    return nil if pay_rate.nil?
    pay_rate * (total_time_taken/3600)
  end
end
