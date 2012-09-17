require 'csv'

class AnalyzeTasksController < ApplicationController
  def analyze_user_tasks
    display_index [], [], :index, 0
  end

  def analyze_project_tasks
    display_index [], [], :index, 0
  end

  def get_project_tags
    if params[:projects] != "null" && (params[:projects].present?)
      project_tags = Tag.find(:all, :conditions => "project_id in (#{params[:projects].collect { |c| c }.join(',')})").collect { |x| NameIdPair.new(x.id, x.name) }
    end
    respond_to do |format|
      format.json { render json: project_tags || [] }
    end
  end

  def search
    tasks = AnalyzeTask.search(@search_query)
    message = "No tasks found!" if tasks.count == 0
    @search_query.search_type = "Search"
    summary = AnalyzeTask.summarize(tasks)
    render_search_results_with_message tasks, summary, message
  end

  def analyze
    tasks = AnalyzeTask.analyze(@search_query)
    message = "No tasks found with goal! Assign goal to tasks to analyze how you are doing" if tasks.count == 0
    @search_query.search_type = "Analyze"
    summary = AnalyzeTask.summarize_goals(tasks)
    render_search_results_with_message tasks, summary, message
  end

  def query_tasks
    @search_query = SearchQuery.new(params, current_user)
    validation = @search_query.validate_start_time_earlier_than_end_time
    return render_search_results_with_message [], [], validation unless (validation.blank?)
    @search_query.search_type = params[:query]
    if @search_query.tags.nil?
      return render_search_results_with_message [], [], "Select at least one task before you continue..."
    end
    if (@search_query.search_type == 'Search')
      search
    elsif (@search_query.search_type == 'Track Goals')
      analyze
    elsif (params[:csv_type] == 'Search')
      @search_query.download_csv = true
      search
    elsif (params[:csv_type] == 'Analyze')
      @search_query.download_csv = true
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

  def render_search_results_with_message(tasks, summary, message)
    flash.now[:info] = message
    display_index Kaminari.paginate_array(tasks).page(params[:page]).per(20), summary, :results, tasks.count
    return
  end

  def display_index(tasks, summary, view, count)
    if @search_query.nil?
      @search_query = SearchQuery.new(params, current_user)
    end
    @search_query.tasks = tasks
    @search_query.total_results_count = count
    @search_query.summary = summary

    if (@search_query.download_csv)
      csv_string = CSV.generate do |csv|
        csv << ["Task", "Start Time", "End Time", "Time Out(min)", "Total Time Spent"]
        @search_query.tasks.each do |task|
          csv << [task.tag.name, task.start_time, task.end_time, task.time_out, Tassk.formatted_time(task.time_spent)]
        end
      end
      send_data csv_string,
                :type => 'text/csv; charset=iso-8859-1; header=present',
                :disposition => "attachment; filename=goal_history_#{Time.zone.now.strftime('%Y-%m-%d_%H:%M:%S')}.csv"
    else
      respond_to do |format|
        format.html { render action: view }
      end
    end
  end
end