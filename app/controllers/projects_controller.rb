class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects
    respond_to do |format|
      format.html
      format.json { render json: @projects.map(&:attributes) }
    end
  end

  def get_project_users
    if (!params[:q].blank?)
      users = User.where("LOWER(display_name) like ? or LOWER(email) like ?", "%#{params[:q]}%", "%#{params[:q]}%")
    else
      users = User.all
    end
    @project_users = users.collect { |x| NameValuePair.new(x.id, "#{x.display_name} (#{get_email(x.email)})") }
    respond_to do |format|
      format.json { render json: @project_users }
    end
  end

  def get_tags
    if (!params[:q].blank?)
      tags = current_user.tags.where("project_id is NULL and LOWER(name) like ?", "%#{params[:q]}%")
    else
      tags = current_user.tags
    end
    @project_tags = tags.collect { |x| NameValuePair.new(x.id, x.name) }
    respond_to do |format|
      format.json { render json: @project_tags }
    end
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new
    @project.update_attributes(params[:project])

    if @project.validate_project_uniqueness_scope(current_user, @project)
      respond_to do |format|
        format.html { render action: :new }
      end
    else
      result = @project.save
      if result
        member_result = Membership.create!(:user => current_user, :project => @project, :is_admin => true, :accepted => true)
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
  end

  def update
    @project = Project.find(params[:id])
    @project.update_attributes(params[:project])
    @project.update_users(params[:project][:user_tokens], current_user)
    @project.update_tags(params[:project][:tag_tokens])
    unless @project.validate_project_uniqueness_scope(current_user, @project)
      result = @project.save
      if result
        admins = get_sanitized_admins
        @project.membership.each do |member|
          member.is_admin = admins.include?(member.user.id.to_s) || member.user == current_user ? true : false
          member.save
        end
      end
      set_message_for_render result, "updated"
    end
    set_message_for_render result, "updated"

    respond_to do |format|
      format.html { render action: :edit }
    end
  end

  def destroy
    @project = Project.find(params[:id])
    if @project.tags.count > 0
      flash.now[:alert] = "One ore more tags are associated with the project. Delete the tags before deleting the project."
      respond_to do |format|
        format.html { render action: :edit }
      end
    else
      @project.membership.each do |member|
        member.destroy
      end
      result = @project.destroy

      if result
        flash[:success] = "Project was successfully deleted."
        respond_to do |format|
          format.html { redirect_to projects_url }
        end
      else
        flash.now[:alert] = @project.errors.full_messages
        respond_to do |format|
          format.html { render action: :edit }
        end
      end
    end
  end

  def accept_invite
    @project = Project.find(params[:id])
    membership = @project.membership.where("user_id = ?", current_user.id).first
    membership.accepted = true
    if membership.save
      flash[:success] = "Congratulations! You are now part of #{@project.name}."
      respond_to do |format|
        format.html { redirect_to projects_url }
        format.mobile { redirect_to projects_url }
      end
    else
      flash.now[:error] = @project.errors.full_messages
      respond_to do |format|
        format.html { render action: :edit }
        format.mobile { render action: :edit }
      end
    end
  end

  private

  def set_message_for_render(result, action)
    if result
      flash.now[:success] = "Project was successfully #{action}."
    else
      flash.now[:error] = @project.errors.full_messages
    end
  end

  def get_sanitized_admins
    params[:project_admins].blank? ? [] : params[:project_admins].reject { |s| s.nil? or s.empty? }
  end

  def get_email(email)
    len = email.length
    if len > 3
      new_email = email[0..3] + email[4..len].gsub(/[0-9A-Za-z]/, 'x')
      return new_email
    end
    email
  end
end
