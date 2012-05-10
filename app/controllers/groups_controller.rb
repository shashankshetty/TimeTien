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
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new
    @group.update_attributes(params[:group])
    result = @group.save
    if result
      member_result = Membership.create!(:user => current_user, :group => @group, :is_admin => true, :accepted => true)
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
    if @group.tags.count > 0
      flash.now[:alert] = "One ore more tags are associated with the group. Delete the tags before deleting the group."
      respond_to do |format|
        format.html { render action: :edit }
      end
    else
      @group.membership.each do |member|
        member.destroy
      end
      result = @group.destroy

      if result
        flash[:success] = "Group was successfully deleted."
        respond_to do |format|
          format.html { redirect_to groups_url }
        end
      else
        flash.now[:alert] = @group.errors.full_messages
        respond_to do |format|
          format.html { render action: :edit }
        end
      end
    end
  end

  def accept_invite
    @group = Group.find(params[:id])
    membership = @group.membership.where("user_id = ?", current_user.id).first
    membership.accepted = true
    if membership.save
      flash[:success] = "Congratulations! You are now part of #{@group.name}."
      respond_to do |format|
        format.html { redirect_to groups_url }
        format.mobile { redirect_to groups_url }
      end
    else
      flash.now[:error] = @group.errors.full_messages
      respond_to do |format|
        format.html { render action: :edit }
        format.mobile { render action: :edit }
      end
    end
  end

  private

  def set_message_for_render(result, action)
    if result
      flash.now[:success] = "Group was successfully #{action}."
    else
      flash.now[:error] = @group.errors.full_messages
    end
  end
end