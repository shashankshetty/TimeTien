class ManageTask
  attr_reader :options, :user, :projects

  def initialize(options, user)
    @options = options || {}
    @user = user
    @projects = user.projects || []
  end

  def tag_id
    options[:select_tag]
  end

  def tasks
    @user.tasks || []
  end
end