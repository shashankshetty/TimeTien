require 'spec_helper'
require 'factory_girl'

describe Task, "When asked to validate" do
  it "should not create a new instance if the tag is empty" do
    task = Task.new
    task.should_not be_valid
    task.errors[:tag].should_not be_empty
  end

  it "should not create a new instance if the start_time is empty" do
    task = Factory(:task)
    task.start_time = nil
    task.should_not be_valid
  end

  it "should not have start time greater than end time" do
    task = Factory(:task)
    task.end_time = task.start_time-1.day
    task.should_not be_valid
  end
end

describe Task, "When asked to get time spent on a task" do
  it "should get the difference between (end_time - start_time) and time allocated" do
    task = Factory(:task)
    task.tag.time_allocated = 60
    task.tag.frequency = 'task'
    task.end_time = task.start_time + 120
    task.time_spent.should be == 120
  end

  it "should get the difference between (end_time - Time.now) and time allocated" do
    task = Factory(:task)
    task.tag.time_allocated = 60
    task.tag.frequency = 'task'
    now = task.start_time + 60
    Time.stub!(:now).and_return(now)
    task.time_spent.should be == 60
  end
end

describe Task, "When asked to get my performance" do
  it "should get the difference between (total_time_spent - tag.time_allocated * 60))" do
    task = Factory(:task)
    task.tag.time_allocated = 60
    task.tag.frequency = 'task'
    task.performance = 3720
    task.my_performance().should be == 120
  end
end

describe Task, "When asked to analyze tasks" do
  before :each do
    Time.zone = "Central Time (US & Canada)"
  end

  it "should group tasks with frequency tasks" do
    tag = Factory(:tag)
    tag.name = "Work12"
    tag.time_allocated = 60
    tag.frequency = 'task'
    user = Factory(:user)
    tasks = []
    tasks << get_task(tag, user)
    tasks << get_task(tag, user)
    tasks << get_task(tag, user)
    tasks = Task.group_tasks(tasks)
    tasks.count.should be == 3
    tasks[0].performance.should be > 0
  end

  it "should group tasks with frequency day" do
    tag = Factory(:tag)
    tag.name = "Work12"
    tag.time_allocated = 360
    tag.frequency = 'day'
    user = Factory(:user)
    tasks = []
    tasks << get_task(tag, user)
    tasks << get_task(tag, user)
    tasks << get_task(tag, user)
    grouped_tasks = Task.group_tasks(tasks)
    grouped_tasks.count.should be == 1
    grouped_tasks[0].performance.should be > 0
  end

  def get_task(tag, user)
    task = Task.new(:start_time => Time.now-1.day-17.hours, :tag => tag, :user => user)
    task.save
    task
  end
end