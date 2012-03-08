class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
    respond_to do |format|
      format.html
      format.json { render json: @groups.map(&:attributes) }
    end
  end

  def show
    if (!params[:q].blank?)
      @users = User.where("display_name like ? or email like ?", "%#{params[:q]}%", "%#{params[:q]}%")
    else
      @users = User.all
    end
    @group_users = @users.collect { |x| GroupUsers.new(x.id, "#{x.display_name} (#{x.email})") }
    respond_to do |format|
      format.json { render json: @group_users }
    end
  end

  def new
    @group = Group.new
    respond_to do |format|
      format.html
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new
    @group.update_attributes(params[:group])
    result = @group.save
    if result
      member_result = Membership.create!(:user => current_user, :group => @group, :is_admin => true)
      if !member_result
        result = member_result
      end
    end
    set_message_for_render result, "created"
    respond_to do |format|
      if result
        format.html { render action: :edit }
      else
        format.html { render action: :new }
      end
    end
  end

  def update
    @group = Group.find(params[:id])
    @group.update_attributes(params[:group])
    @group.update_users(params[:group][:user_tokens], current_user)
    @group.update_admins(params[:group_admins], current_user)
    set_message_for_render @group.save, "updated"
    respond_to do |format|
      format.html { render action: :edit }
    end
  end

  def destroy
    @group = Group.find(params[:id])
    set_message_for_redirect @group.destroy, "deleted"
    respond_to do |format|
      format.html { redirect_to groups_url }
    end
  end

  private

  def set_message_for_redirect(result, action)
    if result
      flash[:success] = "Group was successfully #{action}."
    else
      flash[:error] = @group.errors.full_messages
    end
  end

  def set_message_for_render(result, action)
    if result
      flash.now[:success] = "Group was successfully #{action}."
    else
      flash.now[:error] = @group.errors.full_messages
    end
  end
end