class User < ActiveRecord::Base
  has_many :tasks, :class_name => "Tassk", :dependent => :destroy
  has_many :tags, :dependent => :destroy
  has_many :membership
  has_many :authentications, :dependent => :destroy
  has_many :projects, :through => :membership, :order => "projects.updated_at"
  validates_length_of :display_name, :maximum => 30

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :display_name, :email, :password, :password_confirmation, :has_random_password, :remember_me, :time_zone

  def get_user_projects
    my_memberships =  self.membership.where("accepted = ?", true)
    user_projects = []
    my_memberships.each do |member|
      user_projects << member.project
    end
    user_projects
  end

  def get_tags
    tags = []
    self.tags.each { |tag| tags << tag }
    get_user_projects.each do |project|
      project.tags.each do |tag|
        unless tags.include?(tag)
          tags << tag
        end
      end
    end
    tags.sort_by { |x| x.project_id || 0 }.collect { |tag| [tag.project.nil? ? tag.name : "#{tag.name} (G: #{tag.project.name.first(5)})", tag.id.to_s] }
  end

  def get_project_tags
    tags = []
    get_user_projects.each do |project|
      project.tags.each do |tag|
        tags << tag
      end
    end
    tags.sort_by { |x| x.project_id || 0 }.collect { |tag| [tag.name, tag.id.to_s] }
  end

  def get_projects
    get_user_projects.sort_by { |x| x.name }.collect { |project| [project.name, project.id.to_s] }
  end

  def get_project_invites
    project_invites = []
    unaccepted_memberships = Membership.find(:all, :conditions => {:user_id => id, :accepted => false})
    unaccepted_memberships.each do |membership|
      project_invites << membership.project
    end
    project_invites
  end
end
