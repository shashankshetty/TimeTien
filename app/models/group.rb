class Group < ActiveRecord::Base
  belongs_to :user
  has_many :tags
  has_many :membership
  has_many :users, :through => :membership

  validates :name, :presence => true
  validates :name, :uniqueness => true
  validates_length_of :name, :maximum => 50

  attr_accessor :display_name, :user_tokens
  attr_accessible :name, :description, :user

  def admins
    self.membership.where("is_admin = ?", true)
  end

  def get_membership(user_id)
    Membership.find(:first, :conditions => {:user_id => user_id, :group_id => id})
  end

  def update_users(user_ids, current_user)
    if !user_ids.blank?
      split_ids = user_ids.split(",")
      users.delete_all
      if !split_ids.blank?
        split_ids.each do |id|
          self.users << User.find_by_id(id)
        end
      end
    end
    unless self.users.include?(current_user)
      self.users << current_user
    end
  end

  def update_admins(user_ids, user)
    if !user_ids.blank?
      sanitized_user_ids = user_ids.reject { |s| s.nil? or s.empty? }
      sanitized_user_ids.each do |id|
        group_member = get_membership(id)
        if !group_member.nil?
          group_member.is_admin = true
          membership << group_member
        end
      end
    end
    current_user_membership = get_membership(user.id)
    if !current_user_membership.nil?
      current_user_membership.is_admin = true
      membership << current_user_membership
    end
  end
end


