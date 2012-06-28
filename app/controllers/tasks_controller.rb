class TasksController < ApplicationController
  def new
    @task = Tassk.new(:task_type => 'wt')
  end

  def new2
    @task = Tassk.new(:task_type => 'wnt')
  end

  def manage
    @manage_task = ManageTask.new(params, current_user)
  end

  def edit
    @task = Tassk.find(params[:id])
  end

  def stop_task
    @task = Tassk.find(params[:id])
    @task.end_time = Time.zone.now
    set_message_for_render @task.save, "stopped"
    @manage_task = ManageTask.new(params, current_user)
    respond_to do |format|
      format.html { render action: :manage }
      format.mobile { render action: :manage }
    end
  end

  def start_task
    if params[:select_tag] == ''
      flash.now[:error] = "Select a task to start"
    elsif params[:select_tag] == '[new_tag]' && params[:add_tag] == ''
      flash.now[:error] = "Add new task to start"
    else
      @tag = get_tag params[:select_tag]
      if flash.now[:error].blank?
        @task = Tassk.new
        @task.user = current_user
        @task.start_time = Time.zone.now
        @task.tag = @tag
        set_message_for_render @task.save, "started"
      end
    end
    @manage_task = ManageTask.new(params, current_user)
    respond_to do |format|
      format.html { render action: :manage }
      format.mobile { render action: :manage }
    end
  end

  def create
    @task = Tassk.new
    @task.tag = get_tag params[:task][:tag_id]
    @task.task_type = params[:task_type]
    @task.user = current_user
    result = false
    if params[:task_type] == "wt"
      @task.start_time = parse_datetime(params[:task]["start_time"])
      @task.end_time = parse_datetime(params[:task]["end_time"])
      @task.time_out = get_time(params[:time_out_hours], params[:time_out_minutes])
      result = @task.save
    elsif params[:task_type] == "wnt"
      @task.start_time = parse_datetime(params["task_date"])
      @task.end_time = parse_datetime(params["task_date"])
      @task.additional_time_spent = get_time(params[:time_spent_hours], params[:time_spent_minutes])
      @task.validate_additional_time_spent
      if @task.errors.count == 0
        result = @task.save
      end
    end
    respond_to do |format|
      if result
        set_message_for_redirect result, "created"
        format.html { redirect_to edit_task_path(@task) }
        format.mobile { redirect_to edit_task_path(@task) }
      else
        set_message_for_render result, "created"
        format.html { render action: :new }
        if @task.task_type == "wnt"
          format.mobile { render action: :new2 }
        else
          format.mobile { render action: :new }
        end
      end
    end
  end

  def update
    @task = Tassk.find(params[:id])
    @task.update_attributes(params[:task])
    if @task.task_type == "wt"
      @task.start_time = parse_datetime(params[:task]["start_time"])
      @task.end_time = parse_datetime(params[:task]["end_time"])
      @task.time_out = get_time(params[:time_out_hours], params[:time_out_minutes])
      set_message_for_render @task.save, "updated"
    elsif @task.task_type == "wnt"
      @task.start_time = parse_datetime(params["task_date"])
      @task.end_time = parse_datetime(params["task_date"])
      @task.additional_time_spent = get_time(params[:time_spent_hours], params[:time_spent_minutes])
      @task.validate_additional_time_spent
      if @task.errors.count == 0
        set_message_for_render @task.save, "updated"
      end
    end
    respond_to do |format|
      format.html { render action: :edit }
      format.mobile { render action: :edit }
    end
  end

  def destroy
    @task = Tassk.find(params[:id])
    set_message_for_redirect @task.destroy, "deleted"
    respond_to do |format|
      format.html { redirect_to root_url }
      format.mobile { redirect_to root_url }
    end
  end

  private

  def get_tag(selected_tag)
    if selected_tag == '[new_tag]' && !params[:add_tag].blank?
      @tag = Tag.find(:first, :conditions => {:name => params[:add_tag], :user_id => current_user.id})
      if @tag
        flash.now[:error] = "Task with same name already exists in your list"
      else
        @tag = Tag.new(:name => params[:add_tag], :user => current_user)
        @tag.save
      end
    elsif !selected_tag.blank? && selected_tag != '[new_tag]'
      @tag = Tag.find(selected_tag)
    end
    @tag
  end

  def get_time (hours, minutes)
    hours = hours.to_i
    minutes = minutes.to_i
    total_time = hours * 60 + minutes
    #total_time = nil if total_time == 0
    total_time
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

  def parse_datetime(t)
    return t if t.nil?
    Chronic.parse(t)
  end
end