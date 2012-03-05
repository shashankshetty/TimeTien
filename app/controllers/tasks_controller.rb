class TasksController < ApplicationController
  def index
    if @search_task.nil?
      @search_task = SearchTask.new(params, current_user)
      @search_task.tasks = Kaminari.paginate_array(Array.new).page(params[:page]).per(12)
    end
    respond_to do |format|
      format.html
    end
  end

  def search
    tasks = Kaminari.paginate_array(Task.search(@search_task)).page(params[:page]).per(12)
    flash.now[:info] = "No tasks found!" if tasks.count == 0
    @search_task.search_type = "Search"
    display_index tasks
  end

  def analyze
    tasks = Kaminari.paginate_array(Task.analyze(@search_task)).page(params[:page]).per(12)
    flash.now[:info] = "No tasks found with goal! Assign goal to tags to analyze how you are doing" if tasks.count == 0
    @search_task.search_type = "Analyze"
    display_index tasks
  end

  def query_tasks
    @search_task = SearchTask.new(params, current_user)
    @search_task.search_type = params[:query]
    if @search_task.tags.nil?
      flash.now[:info] = "Select atleast one tag before you continue..."
      display_index Kaminari.paginate_array([]).page(params[:page]).per(12)
      return
    end
    if (@search_task.search_type == 'Search')
      search
    end
    if (@search_task.search_type == 'Analyze')
      analyze
    end
  end

  def new
    @task = Task.new
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
    @task = Task.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def stop_task
    @task = Task.find(params[:id])
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
        @task = Task.new
        @task.user = current_user
        @task.start_time = Time.now
        @task.tag = @tag
        set_message_for_render @task.save, "started"
      end
    end
    render_manage
  end

  def create
    @task = Task.new(params[:task])
    @task.start_time = parse_datetime(params[:task]["start_time"])
    @task.end_time = parse_datetime(params[:task]["end_time"])
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
    @task = Task.find(params[:id])
    @task.update_attributes(params[:task])
    @task.start_time = parse_datetime(params[:task]["start_time"])
    @task.end_time = parse_datetime(params[:task]["end_time"])
    set_message_for_render @task.save, "updated"
    respond_to do |format|
      format.html { render action: :edit }
    end
  end

  def delete
    destroy(root_url)
  end

  def delete_task
    destroy(tasks_url)
  end

  private

  def display_index(tasks)
    @search_task.tasks = tasks
    respond_to do |format|
      format.html { render action: :index }
    end
  end

  def destroy(url = root_url)
    @task = Task.find(params[:id])
    set_message_for_redirect @task.destroy, "deleted"
    respond_to do |format|
      format.html { redirect_to url }
    end
  end

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