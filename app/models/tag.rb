class Tag < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  has_many :tasks, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :uniqueness => {:scope => :name}
  validates_length_of :name, :maximum => 50
end
