module TasksHelper
  def available_tags_with_select
    [['Select', ''], ['[Add New Tag]', '[new_tag]']].concat(current_user.get_tags)
  end

  def available_tags
    [['All', '']].concat(current_user.get_tags)
  end

  def ongoing_tasks
    @manage_task.tasks.where('end_time IS NULL').order('end_time DESC')
  end

  def completed_tasks
    @manage_task.tasks.where('end_time IS NOT NULL').order('end_time DESC').limit(15)
  end

  def format_time_m_d_y(t)
    return t if t.blank?
    return t.strftime('%I:%M %p') if (t.to_date == Date.today)
    return t.strftime('%m/%d/%Y %I:%M %p')
  end

  def format_time_d_m_y(t)
    return t if t.blank?
    return t.strftime('%I:%M %p') if (t.to_date == Date.today)
    return t.strftime('%d-%b-%Y %I:%M %p')
  end

  # http://stufftohelpyouout.blogspot.com/2010/02/seconds-to-days-minutes-hours-seconds.html
  def display_time_with_performance(total_seconds)
    return "n/a" if total_seconds.blank?
    performance = total_seconds >=0 ? "-" : "+"
    display = display_time(total_seconds)
    return performance == "-" ? "#{performance}#{display} over" : "#{performance}#{display} under"
  end

  def display_time(total_seconds)
    total_seconds = total_seconds.abs.to_i

    days = total_seconds / 86400
    hours = (total_seconds / 3600) - (days * 24)
    minutes = (total_seconds / 60) - (hours * 60) - (days * 1440)
    seconds = total_seconds % 60
    if (seconds > 30)
      minutes = minutes + 1
    end
    display = ''
    display_concat = ''
    if days > 0
      display = display + display_concat + "#{days}d"
      display_concat = ' '
    end
    if hours > 0
      display = display + display_concat + "#{hours}h"
      display_concat = ' '
    end
    if minutes > 0
      display = display + display_concat + "#{minutes}m"
      #display_concat = ' '
    end
    #display = display + display_concat + "#{seconds}s"
    return display
  end
end
