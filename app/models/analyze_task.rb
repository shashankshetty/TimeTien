class AnalyzeTask
  def self.search(search_query)
    Tassk.find(:all, :conditions => search_query.conditions, :order => "start_time ASC")
  end

  def self.analyze(search_query)
    tasks = search(search_query)
    group_tasks(tasks)
  end

  def self.summarize(tasks)
    grouped_tasks = []
    tags = tasks.map { |task| task.tag }.uniq
    tags.each do |tag|
      tag_tasks = tasks.find_all { |t| t.tag.name == tag.name }
      grouped_tasks << NameValuePair.new(tag_tasks.sum(&:time_spent), tag)
    end
    grouped_tasks
  end

  def self.summarize_goals(tasks)
    grouped_tasks = []
    tags = tasks.map { |task| task.tag }.uniq
    tags.each do |tag|
      tag_tasks = tasks.find_all { |t| t.tag.name == tag.name }
      name_value_pair = NameValuePair.new(tag_tasks.sum(&:performance), tag)
      name_value_pair.count = tag_tasks.count
      grouped_tasks << name_value_pair
    end
    grouped_tasks
  end

  def self.group_tasks(tasks)
    grouped_tasks = []
    tags = tasks.map { |task| task.tag }.uniq
    tags.find_all { |g| g.frequency == 'task' }.each do |tag|
      tag_tasks = tasks.find_all { |t| t.tag.name == tag.name }
      tag_tasks.each do |task|
        task_performance = task.time_spent
        grouped_tasks << Tassk.new(:start_time => task.start_time, :end_time => task.end_time, :tag => tag, :performance => task_performance)
      end
    end
    tags.find_all { |g| g.frequency == 'day' }.each do |tag|
      tag_tasks = tasks.find_all { |t| t.tag.name == tag.name }
      tasks_by_day = tag_tasks.group_by { |t| t.start_time.beginning_of_day }
      tasks_by_day.each do |day, day_tasks|
        total_time_spent = 0
        day_tasks.each do |day_task|
          total_time_spent = total_time_spent + day_task.time_spent
        end
        task_performance = total_time_spent
        grouped_tasks << Tassk.new(:start_time => day.beginning_of_day, :end_time => day.end_of_day, :tag => tag, :performance => task_performance)
      end
    end
    tags.find_all { |g| g.frequency == 'week' }.each do |tag|
      tag_tasks = tasks.find_all { |t| t.tag.name == tag.name }
      tasks_by_week = tag_tasks.group_by { |t| t.start_time.beginning_of_week }
      tasks_by_week.each do |week, week_tasks|
        total_time_spent = 0
        week_tasks.each do |week_task|
          total_time_spent = total_time_spent + week_task.time_spent
        end
        task_performance = total_time_spent
        grouped_tasks << Tassk.new(:start_time => week.beginning_of_week, :end_time => week.end_of_week, :tag => tag, :performance => task_performance)
      end
    end
    grouped_tasks
  end
end