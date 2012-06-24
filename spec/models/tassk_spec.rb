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

  it "should not have time_out more than difference between start and end times" do
    task = FactoryGirl.create(:tassk)
    task.end_time = task.start_time-1.hour
    task.time_out = 120*60
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

  it "should get the difference between (end_time - start_time) -time_out" do
    task = FactoryGirl.create(:tassk)
    task.end_time = task.start_time + 3600
    task.time_out = 30
    task.time_spent.should be == 1800
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

describe Tassk, "When asked to validate additional time spent for task with no times" do
  it "should return error if the additional_time_spent is blank" do
    task = FactoryGirl.create(:tassk)
    task.validate_additional_time_spent
    task.errors[:time_spent].should_not be_empty
  end
end

describe Tassk, "When asked to validate additional time spent for task with no times" do
  it "should return success if the additional_time_spent is not blank" do
    task = FactoryGirl.create(:tassk)
    task.additional_time_spent = 300
    task.validate_additional_time_spent
    task.errors[:time_spent].should be_empty
  end
end