class Group < ActiveRecord::Base
  belongs_to :user
  has_many :tags
  has_many :membership
  has_many :users, :through => :membership

  validates :name, :presence => true
  validates :name, :uniqueness => true
  validates_length_of :name, :maximum => 50
  validates_length_of :description, :maximum => 250

  attr_accessor :display_name, :user_tokens, :tag_tokens
  attr_accessible :name, :description, :user

  def admins
    self.membership.where("is_admin = ?", true)
  end

  def get_membership(user_id)
    self.membership.where("user_id = ?", user_id).first
  end

  def update_users(user_ids, current_user)
    if user_ids.blank?
      users_to_delete = self.membership.where("user_id != ?", current_user.id)
      users_to_delete.delete_all
    else
      split_ids = user_ids.split(",")
      if !split_ids.blank?
        users_to_update = [current_user.id]
        split_ids.each do |id|
          users_to_update << id
          user_to_add = self.membership.where("user_id = ?", id).first
          if user_to_add.blank?
            user = User.find_by_id(id)
            self.users << user
            if !user.tasks.blank? && user.tasks.where("tag_id in (#{tags.collect { |c| c.id }.join(',')})").count > 0
              group_member = get_membership(id)
              group_member.accepted = true
              membership << group_member
            end
          end
        end
        users_to_delete = self.membership.where("user_id not in (#{users_to_update.collect { |c| c }.join(',')})")
        users_to_delete.delete_all
      end
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

  def update_tags(tag_ids)
    self.tags.clear
    if !tag_ids.blank?
      split_ids = tag_ids.split(",")
      split_ids.each do |id|
        tag = Tag.find_by_id(id.to_i)
        self.tags << tag
      end
    end
  end
end


