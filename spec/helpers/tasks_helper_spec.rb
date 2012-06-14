require 'spec_helper'

describe TasksHelper do
  describe "When asked to format time as mm/dd/yyyy" do
    before :each do
      Time.zone = "Central Time (US & Canada)"
    end

    it "should return only time if time is today" do
      t = Time.now
      helper.format_time_m_d_y(t).should == t.strftime('%I:%M %p')
    end

    it "should return date and time if time is not today" do
      t = (Time.now-2.days)
      helper.format_time_m_d_y(t).should == t.strftime('%m/%d/%Y %I:%M %p').gsub(/ 0(\d\D)/, ' \1')
    end
  end

  describe "When asked to format time as dd-mmm-yyyy" do
    before :each do
      Time.zone = "Central Time (US & Canada)"
    end

    it "should return only time if time is today" do
      t = Time.now
      helper.format_time_d_m_y(t).should == t.strftime('%I:%M %p')
    end

    it "should return date and time if time is not today" do
      t = (Time.now-2.days)
      helper.format_time_d_m_y(t).should == t.strftime('%d-%b-%Y %I:%M %p').gsub(/ 0(\d\D)/, ' \1')
    end
  end

  describe "When asked to display the time given in seconds" do
    it "should display time in h m format" do
      helper.display_time(90000).should == "25hr"
    end
  end

  describe "When asked to display the time_allocated given in seconds" do
    it "should display time in h m format" do
      helper.display_time_with_performance(6400, true).should == "-1hr 47min over"
    end
  end

  describe "When asked to display time in seconds to formatted time" do
    before :each do
      Time.zone = "Central Time (US & Canada)"
    end

    it "should display time in {h}{m} format" do
      t = Time.now
      helper.display_time(3700).should == "1hr 2min"
    end
  end

  describe "When asked to relative performance with complete_within is true" do
    before :each do
      Time.zone = "Central Time (US & Canada)"
    end

    it "should display time in {h}{m} over for positive number with negative sign" do
      t = Time.now
      helper.display_time_with_performance(3700, true).should == "-1hr 2min over"
    end

    it "should display time in {h}{m} under for negative number with positive sign" do
      t = Time.now
      helper.display_time_with_performance(-3700, true).should == "+1hr 2min under"
    end
  end

  describe "When asked to relative performance with complete_within is false" do
    before :each do
      Time.zone = "Central Time (US & Canada)"
    end

    it "should display time in {h}{m} over for positive number with positive sign" do
      t = Time.now
      helper.display_time_with_performance(3700, false).should == "+1hr 2min over"
    end

    it "should display time in {h}{m} under for negative number with negative sign" do
      t = Time.now
      helper.display_time_with_performance(-3700, false).should == "-1hr 2min under"
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
      total_seconds = 36000
      helper.calculate_earning(tag, total_seconds).should == "$100.00"
    end
  end

  describe "When asked to get hours and minutes portion of time_out" do
    before :each do
      @task = FactoryGirl.create(:tassk)
      @task.time_out = 100
    end

    it "should return the hour part of the time" do
      helper.get_time_out_hours.should == 1
    end

    it "should return the minutes part of the time" do
      helper.get_time_out_minutes.should == 40
    end
  end
end
