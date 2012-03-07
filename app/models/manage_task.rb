class ManageTask
  attr_reader :options, :user, :groups

  def initialize(options, user)
    @options = options || {}
    @user = user
    @groups = user.groups || []
  end

  def tag_id
    options[:select_tag]
  end

  def tasks
    @user.tasks || []
  end
end