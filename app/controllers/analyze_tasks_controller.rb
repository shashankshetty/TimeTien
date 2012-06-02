class AnalyzeTasksController < ApplicationController
  def analyze_user_tasks
    display_index [], :index
  end

  def analyze_project_tasks
    display_index [], :index
  end

  def get_project_tags
    if params[:projects] != "null" && (params[:projects].present?)
      project_tags = Tag.find(:all, :conditions => "project_id in (#{params[:projects].collect { |c| c }.join(',')})").collect { |x| NameValuePair.new(x.id, x.name) }
    end
    respond_to do |format|
      format.json { render json: project_tags || [] }
    end
  end

  def search
    tasks = AnalyzeTask.search(@search_query)
    message = "No tasks found!" if tasks.count == 0
    @search_query.search_type = "Search"
    render_search_results_with_message tasks, message
  end

  def analyze
    tasks = AnalyzeTask.analyze(@search_query)
    message = "No tasks found with goal! Assign goal to tasks to analyze how you are doing" if tasks.count == 0
    @search_query.search_type = "Analyze"
    render_search_results_with_message tasks, message
  end

  def query_tasks
    @search_query = SearchQuery.new(params, current_user)
    validation = @search_query.validate_start_time_earlier_than_end_time
    return render_search_results_with_message [], validation unless (validation.blank?)
    @search_query.search_type = params[:query]
    if @search_query.tags.nil?
      return render_search_results_with_message [], "Select atleast one task before you continue..."
    end
    if (@search_query.search_type == 'Search')
      search
    end
    if (@search_query.search_type == 'Analyze')
      analyze
    end
  end

  def destroy_task
    @task = Tassk.find(params[:id])
    if @task.user != current_user
      message = {:status => "error", :text => "You are only authorized to delete tasks that you own."}
    elsif @task.destroy
      message = {:status => "success", :text => "Task was successfully deleted."}
    else
      messages = []
      @task.errors.full_messages.each do |key, value|
        messages << value
      end
      message = {:status => "error", :text => messages.join(", ")}
    end
    respond_to do |format|
      format.json { render json: message }
    end
  end

  private

  def render_search_results_with_message(tasks, message)
    flash.now[:info] = message
    display_index Kaminari.paginate_array(tasks).page(params[:page]).per(12), :results
    return
  end

  def display_index(tasks, view)
    if @search_query.nil?
      @search_query = SearchQuery.new(params, current_user)
    end
    @search_query.tasks = tasks
    respond_to do |format|
      format.html { render action: view }
    end
  end
end