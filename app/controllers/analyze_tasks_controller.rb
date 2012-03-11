class AnalyzeTasksController < ApplicationController
  def analyze_user_tasks
    render_search_results_with_message [], ""
  end

  def analyze_group_tasks
    render_search_results_with_message [], ""
  end

  def get_group_tags
    #if params[:groups] == "all"
    #  memberships = Membership.find(:all, :conditions => {:user_id => current_user.id})
    #  group_tags = Tag.find(:all, :conditions => "group_id in (#{memberships.collect { |c| c.group_id }.join(',')})").collect { |x| GroupUsers.new(x.id, x.name) }
    #els
    if params[:groups] != "null" && (params[:groups].present?)
      group_tags = Tag.find(:all, :conditions => "group_id in (#{params[:groups].collect { |c| c }.join(',')})").collect { |x| GroupUsers.new(x.id, x.name) }
    end
    respond_to do |format|
      format.json { render json: group_tags || [] }
      #render :partial => "tags", :locals => {:group_tags => group_tags}
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