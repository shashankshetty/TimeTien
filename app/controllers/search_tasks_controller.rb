class SearchTasksController < ApplicationController
  def index
    render_search_results_with_message [], ""
  end

  def search
    tasks = SearchTask.search(@search_query)
    message = "No tasks found!" if tasks.count == 0
    @search_query.search_type = "Search"
    render_search_results_with_message tasks, message
  end

  def analyze
    tasks = SearchTask.analyze(@search_query)
    message = "No tasks found with goal! Assign goal to tags to analyze how you are doing" if tasks.count == 0
    @search_query.search_type = "Analyze"
    render_search_results_with_message tasks, message
  end

  def query_tasks
    @search_query = SearchQuery.new(params, current_user)
    validation = @search_query.validate_start_time_earlier_than_end_time
    return render_search_results_with_message [], validation unless (validation.blank?)
    @search_query.search_type = params[:query]
    if @search_query.tags.nil?
      return render_search_results_with_message [], "Select atleast one tag before you continue..."
    end
    if (@search_query.search_type == 'Search')
      search
    end
    if (@search_query.search_type == 'Analyze')
      analyze
    end
  end

  def destroy
    @task = Tassk.find(params[:id])
    message = @task.destroy ? "Task was successfully deleted." : @task.errors.full_messages
    render_search_results_with_message [], message
  end

  private

  def render_search_results_with_message(tasks, message)
    flash.now[:info] = message
    display_index Kaminari.paginate_array(tasks).page(params[:page]).per(12)
    return
  end

  def display_index(tasks)
    if @search_query.nil?
      @search_query = SearchQuery.new(params, current_user)
    end
    @search_query.tasks = tasks
    respond_to do |format|
      format.html { render action: :index }
    end
  end
end