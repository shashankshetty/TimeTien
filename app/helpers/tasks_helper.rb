module TasksHelper
  def available_tags_with_option_to_add
    [['Select to start a task', ''], ['[Add New]', '[new_tag]']].concat(current_user.get_tags)
  end

  def tags_with_option_to_add
    [['Select', ''], ['[Add New]', '[new_tag]']].concat(current_user.get_tags)
  end

  def available_tags
    [['Select', '']].concat(current_user.get_tags)
  end

  def ongoing_tasks
    @manage_task.tasks.where('end_time IS NULL').order('start_time DESC')
  end

  def completed_tasks
    @manage_task.tasks.where('end_time IS NOT NULL').order('end_time DESC').limit(30)
  end

  def format_time_m_d_y(t)
    return t if t.blank?
    return t.strftime('%I:%M %p').gsub(/ 0(\d\D)/, ' \1') if (t.to_date == Date.today)
    t.strftime('%m/%d/%Y %I:%M %p').gsub(/ 0(\d\D)/, ' \1')
  end

  def format_time_d_m_y(t)
    return t if t.blank?
    return t.strftime('%I:%M %p').gsub(/ 0(\d\D)/, ' \1') if (t.to_date == Date.today)
    t.strftime('%d-%b-%Y %I:%M %p').gsub(/ 0(\d\D)/, ' \1')
  end

  def format_date_d_m_y(t)
    return t if t.blank?
    t.strftime('%d-%b-%Y').gsub(/ 0(\d\D)/, ' \1')
  end

  def format_date_m_d_y(t)
    return t if t.blank?
    t.strftime('%m/%d/%Y').gsub(/ 0(\d\D)/, ' \1')
  end

  # http://stufftohelpyouout.blogspot.com/2010/02/seconds-to-days-minutes-hours-seconds.html
  def display_time_with_performance_for(task)
    total_seconds = task.my_performance
    display_time_with_performance(total_seconds, task.tag.complete_within)
  end

  def display_time_with_performance(total_seconds, complete_within)
    return "n/a" if total_seconds.blank?
    display = display_time(total_seconds)
    if display.blank?
      return "perfect"
    end
    if total_seconds >=0
      performance = complete_within ? "-" : "+"
      "#{performance}#{display} over"
    else
      performance = complete_within ? "+" : "-"
      "#{performance}#{display} under"
    end
  end

  def display_time(total_seconds)
    Tassk.formatted_time(total_seconds)
  end

  def get_progress_bar_width_for_task(task)
    get_progress_bar_width(task.performance, task.tag.time_allocated)
  end

  def get_progress_bar_width(time_spent, total_time)
    time_spent = time_spent.abs
    total_time = total_time*60
    return 100 if (time_spent == 0)
    number_to_percentage((time_spent.to_f/total_time)*100)
  end

  def get_progress_bar_color_for_task(task)
    get_progress_bar_color(task.my_performance, task.tag.complete_within)
  end

  def get_progress_bar_color(performance, complete_within)
    return "info" if performance == 0
    if performance < 0
      complete_within ? "success" : "danger"
    elsif performance > 0
      return complete_within ? "danger" : "success"
    end
  end

  def calculate_earning(tag, total_seconds)
    return nil if tag.pay_rate.nil?
    earning = (tag.pay_rate * total_seconds)/3600
    number_to_currency(earning, :unit => tag.pay_currency)
  end

  def search_title
    @search_query.blank? || @search_query.search_type.blank? ? "search tasks/track goals" : @search_query.search_type
  end

  def get_time_out_hours
    return nil if @task.time_out.blank?
    @task.time_out/60
  end

  def get_time_out_minutes
    return nil if @task.time_out.blank?
    return @task.time_out.divmod(60)[1]
  end

  def get_additional_time_spent_hours
    return nil if @task.additional_time_spent.blank?
    @task.additional_time_spent/60
  end

  def get_additional_time_spent_minutes
    return nil if @task.additional_time_spent.blank?
    @task.additional_time_spent.divmod(60)[1]
  end
end
