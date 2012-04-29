require 'spec_helper'
require 'factory_girl'

describe Tassk, "When asked to validate" do
  it "should not create a new instance if the tag is empty" do
    task = Tassk.new
    task.should_not be_valid
    task.errors[:tag].should_not be_empty
  end

  it "should not create a new instance if the start_time is empty" do
    task = FactoryGirl.create(:tassk)
    task.start_time = nil
    task.should_not be_valid
  end

  it "should not have start time greater than end time" do
    task = FactoryGirl.create(:tassk)
    task.end_time = task.start_time-1.day
    task.should_not be_valid
  end
end

describe Tassk, "When asked to get time spent on a task" do
  it "should get the difference between (end_time - start_time) and time allocated" do
    task = FactoryGirl.create(:tassk)
    task.tag.time_allocated = 60
    task.tag.frequency = 'task'
    task.end_time = task.start_time + 120
    task.time_spent.should be == 120
  end

  it "should get the difference between (end_time - Time.now) and time allocated" do
    task = FactoryGirl.create(:tassk)
    task.tag.time_allocated = 60
    task.tag.frequency = 'task'
    now = task.start_time + 60
    Time.stub!(:now).and_return(now)
    task.time_spent.should be == 60
  end
end

describe Tassk, "When asked to get my performance" do
  it "should get the difference between (total_time_spent - tag.time_allocated * 60))" do
    task = FactoryGirl.create(:tassk)
    task.tag.time_allocated = 60
    task.tag.frequency = 'task'
    task.performance = 3720
    task.my_performance().should be == 120
  end
end