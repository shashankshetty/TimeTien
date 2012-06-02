require 'spec_helper'
require 'factory_girl'

describe AnalyzeTask, "When asked to summarize tasks" do
  before :each do
    Time.zone = "Central Time (US & Canada)"
  end

  it "should summarize total time taken by each task" do
    tag = FactoryGirl.create(:tag)
    tag.name = "Work12"
    user = FactoryGirl.create(:user)
    tasks = []
    tasks << get_task(tag, user)
    tasks << get_task(tag, user)
    tasks = AnalyzeTask.summarize(tasks)
    tasks.count.should be == 1
    tasks[0].id.floor.should be == 7200
  end

  def get_task(tag, user)
    task = Tassk.new(:start_time => Time.now-1.hours, :tag => tag, :user => user)
    task.save
    task
  end
end

describe AnalyzeTask, "When asked to analyze tasks" do
  before :each do
    Time.zone = "Central Time (US & Canada)"
  end

  it "should group tasks with frequency tasks" do
    tag = FactoryGirl.create(:tag)
    tag.name = "Work12"
    tag.time_allocated = 60
    tag.frequency = 'task'
    user = FactoryGirl.create(:user)
    tasks = []
    tasks << get_task(tag, user)
    tasks << get_task(tag, user)
    tasks << get_task(tag, user)
    tasks = AnalyzeTask.group_tasks(tasks)
    tasks.count.should be == 3
    tasks[0].performance.should be > 0
  end

  it "should group tasks with frequency day" do
    tag = FactoryGirl.create(:tag)
    tag.name = "Work12"
    tag.time_allocated = 360
    tag.frequency = 'day'
    user = FactoryGirl.create(:user)
    tasks = []
    tasks << get_task(tag, user)
    tasks << get_task(tag, user)
    tasks << get_task(tag, user)
    grouped_tasks = AnalyzeTask.group_tasks(tasks)
    grouped_tasks.count.should be == 1
    grouped_tasks[0].performance.should be > 0
  end

  it "should group tasks with frequency week" do
    tag = FactoryGirl.create(:tag)
    tag.name = "Work12"
    tag.time_allocated = 86400
    tag.frequency = 'day'
    user = FactoryGirl.create(:user)
    tasks = []
    tasks << get_task(tag, user)
    tasks << get_task(tag, user)
    tasks << get_task(tag, user)
    grouped_tasks = AnalyzeTask.group_tasks(tasks)
    grouped_tasks.count.should be == 1
    grouped_tasks[0].performance.should be > 0
  end

  def get_task(tag, user)
    task = Tassk.new(:start_time => Time.now-1.day-17.hours, :tag => tag, :user => user)
    task.save
    task
  end
end