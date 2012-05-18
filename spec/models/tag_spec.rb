require 'spec_helper'
require 'factory_girl'

describe Tag, "When asked to validate" do
  it "should not create a new instance if the name is empty" do
    tag = Tag.new
    tag.should_not be_valid
    tag.errors[:name].should_not be_empty
  end

  it "should not create a new instance if the length of name is more than 50 characters" do
    tag = Tag.new(:name => "1234567890123456789012345678901234567890123456789012")
    tag.should_not be_valid
    tag.errors[:name].should_not be_empty
  end

  it "should not create multiple tags for the same name and user combination" do
    tag = FactoryGirl.create(:tag)
    tag1 = FactoryGirl.create(:tag)
    tag1.name = tag.name

    tag1.should_not be_valid
    tag1.errors[:name].should_not be_empty
  end

  it "should not check complete_within if time allocated is blank" do
    tag = FactoryGirl.create(:tag)
    tag.complete_within = true
    tag.should_not be_valid
    tag.errors[:complete_within].should_not be_empty
  end

  it "should not allow pay rate greater than 9999" do
    tag = FactoryGirl.create(:tag)
    tag.pay_rate = 10000
    tag.should_not be_valid
    tag.errors[:pay_rate].should_not be_empty
  end

  it "should not allow pay rate less than 0" do
    tag = FactoryGirl.create(:tag)
    tag.pay_rate = -100
    tag.should_not be_valid
    tag.errors[:pay_rate].should_not be_empty
  end
end

describe "When asked to calculate earning" do
  before :each do
    Time.zone = "Central Time (US & Canada)"
  end

  it "should return the total earning with the currency" do
    tag = FactoryGirl.create(:tag)
    tag.pay_rate = 10
    tag.pay_currency = "$"
    Tassk.create(:tag => tag, :start_time => Time.now-60.minutes, :end_time => Time.now)
    tag.billable_amount.to_i.should == 10
  end
end
