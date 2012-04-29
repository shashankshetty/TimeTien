require 'spec_helper'

describe "When asked to get hours and minutes portion of time_allocated" do
  before :each do
    @tag = FactoryGirl.create(:tag)
    @tag.time_allocated = 100
  end

  it "should return the hour part of the time" do
    helper.get_hours.should == 1
  end

  it "should return the minutes part of the time" do
    helper.get_minutes.should == 40
  end
end