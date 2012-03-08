class TasksController < ApplicationController
  def new
    @task = Tassk.new
    respond_to do |format|
      format.html
    end
  end

  def manage
    @manage_task = ManageTask.new(params, current_user)
    respond_to do |format|
      format.html
    end
  end

  def edit
    @task = Tassk.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def stop_task
    @task = Tassk.find(params[:id])
    @task.end_time = Time.now
    set_message_for_render @task.save, "stopped"
    render_manage
  end

  def start_task
    if params[:select_tag] == ''
      flash.now[:error] = "Select a tag to start the task"
    else
      @tag = get_tag
      if flash.now[:error].blank?
        @task = Tassk.new
        @task.user = current_user
        @task.start_time = Time.now
        @task.tag = @tag
        set_message_for_render @task.save, "started"
      end
    end
    render_manage
  end

  def create
    @task = Tassk.new(params[:task])
    @task.start_time = parse_datetime(params[:task]["start_time"])
    @task.end_time = parse_datetime(params[:task]["end_time"])
    @task.user = current_user
    result = @task.save
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
    @task = Tassk.find(params[:id])
    @task.update_attributes(params[:task])
    @task.start_time = parse_datetime(params[:task]["start_time"])
    @task.end_time = parse_datetime(params[:task]["end_time"])
    set_message_for_render @task.save, "updated"
    respond_to do |format|
      format.html { render action: :edit }
    end
  end

  def destroy
    @task = Tassk.find(params[:id])
    set_message_for_redirect @task.destroy, "deleted"
    respond_to do |format|
      format.html { redirect_to root_url }
    end
  end

  private

  def get_tag
    if params[:select_tag] == '[new_tag]'
      @tag = Tag.find(:first, :conditions => {:name => params[:add_tag], :user_id => current_user.id})
      if @tag
        flash.now[:error] = "Tag with same name already exists in your list"
      else
        @tag = Tag.new(:name => params[:add_tag], :user => current_user)
        @tag.save
      end
    else
      @tag = Tag.find(params[:select_tag])
    end
    @tag
  end

  def set_message_for_render(result, action)
    if result
      flash.now[:success] = "Task was successfully #{action}."
    else
      flash.now[:error] = @task.errors.full_messages
    end
  end

  def set_message_for_redirect(result, action)
    if result
      flash[:success] = "Task was successfully #{action}."
    else
      flash[:error] = @task.errors.full_messages
    end
  end

  def render_manage
    @manage_task = ManageTask.new(params, current_user)
    respond_to do |format|
      format.html { render action: :manage }
    end
  end

  def parse_datetime(t)
    return t if t.nil?
    Chronic.parse(t)
  end
end