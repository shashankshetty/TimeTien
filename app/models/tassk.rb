class Tassk < ActiveRecord::Base
  self.table_name = "Tasks"
  belongs_to :tag
  belongs_to :user

  attr_accessor :performance
  validates :tag, :presence => true
  validates :start_time, :presence => true

  validate :validate_start_time_earlier_than_end_time

  def validate_start_time_earlier_than_end_time
    if (start_time && end_time)
      errors.add(:end_time, "cannot start earlier than start time") if start_time > end_time
    end
  end

  def time_spent
    return (end_time || Time.now) - start_time
  end

  def my_performance()
    return performance - (tag.time_allocated * 60)
  end

  def self.search(search_task)
    find(:all, :conditions => search_task.conditions, :order => "start_time ASC")
  end

  def self.analyze(search_task)
    tasks = search(search_task)
    group_tasks(tasks)
  end

  def self.group_tasks(tasks)
    grouped_tasks = []
    tags = tasks.map { |task| task.tag }.uniq
    tags.find_all { |g| g.frequency == 'task' }.each do |tag|
      tag_tasks = tasks.find_all { |t| t.tag.name == tag.name }
      tag_tasks.each do |task|
        task_performance = ((task.end_time || Time.now) - task.start_time)
        grouped_tasks << Tassk.new(:start_time => task.start_time, :end_time => task.end_time, :tag => tag, :performance => task_performance)
      end
    end
    tags.find_all { |g| g.frequency == 'day' }.each do |tag|
      tag_tasks = tasks.find_all { |t| t.tag.name == tag.name }
      tasks_by_day = tag_tasks.group_by { |t| t.start_time.beginning_of_day }
      tasks_by_day.each do |day, day_tasks|
        total_time_spent = 0
        day_tasks.each do |day_task|
          total_time_spent = ((day_task.end_time || Time.now) - day_task.start_time)
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
          total_time_spent = ((week_task.end_time || Time.now) - week_task.start_time)
        end
        task_performance = total_time_spent
        grouped_tasks << Tassk.new(:start_time => week.beginning_of_week, :end_time => week.end_of_week, :tag => tag, :performance => task_performance)
      end
    end
    grouped_tasks
  end
end
