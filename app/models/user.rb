class User < ActiveRecord::Base
  has_many :tasks, :class_name => "Tassk", :dependent => :destroy
  has_many :tags, :dependent => :destroy
  has_many :membership
  has_many :authentications, :dependent => :destroy
  has_many :groups, :through => :membership, :order => "groups.updated_at"
  validates_length_of :display_name, :maximum => 30

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :display_name, :email, :password, :password_confirmation, :has_random_password, :remember_me, :time_zone

  def get_user_groups
    my_memberships =  self.membership.where("accepted = ?", true)
    user_groups = []
    my_memberships.each do |member|
      user_groups << member.group
    end
    user_groups
  end

  def get_tags
    tags = []
    self.tags.each { |tag| tags << tag }
    get_user_groups.each do |group|
      group.tags.each do |tag|
        unless tags.include?(tag)
          tags << tag
        end
      end
    end
    tags.sort_by { |x| x.group_id || 0 }.collect { |tag| [tag.group.nil? ? tag.name : "#{tag.name} (G: #{tag.group.name.first(5)})", tag.id.to_s] }
  end

  def get_group_tags
    tags = []
    get_user_groups.each do |group|
      group.tags.each do |tag|
        tags << tag
      end
    end
    tags.sort_by { |x| x.group_id || 0 }.collect { |tag| [tag.name, tag.id.to_s] }
  end

  def get_groups
    get_user_groups.sort_by { |x| x.name }.collect { |group| [group.name, group.id.to_s] }
  end

  def get_group_invites
    group_invites = []
    unaccepted_memberships = Membership.find(:all, :conditions => {:user_id => id, :accepted => false})
    unaccepted_memberships.each do |membership|
      group_invites << membership.group
    end
    group_invites
  end
end
