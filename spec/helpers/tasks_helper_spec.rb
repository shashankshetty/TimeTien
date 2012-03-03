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
      helper.format_time_m_d_y(t).should == t.strftime('%m/%d/%Y %I:%M %p')
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
      helper.format_time_d_m_y(t).should == t.strftime('%d-%b-%Y %I:%M %p')
    end
  end

  describe "When asked to display the time given in seconds" do
    it "should display time in d h m format" do
      helper.display_time(90000).should == "1d 1h"
    end
  end

  describe "When asked to display the time_allocated given in seconds" do
    it "should display time in d h m format" do
      helper.display_time_with_performance(6400).should == "-1h 47m over"
    end
  end

  describe "When asked to display time in seconds to formatted time" do
    before :each do
      Time.zone = "Central Time (US & Canada)"
    end

    it "should display time in {d}{h}{m} format" do
      t = Time.now
      helper.display_time(3700).should == "1h 2m"
    end
  end

  describe "When asked to relative performance" do
    before :each do
      Time.zone = "Central Time (US & Canada)"
    end

    it "should display time in {d}{h}{m} over for positive number" do
      t = Time.now
      helper.display_time_with_performance(3700).should == "-1h 2m over"
    end

    it "should display time in {d}{h}{m} under for negative number" do
      t = Time.now
      helper.display_time_with_performance(-3700).should == "+1h 2m under"
    end
  end
end
