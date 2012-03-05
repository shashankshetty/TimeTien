require 'spec_helper'
require 'factory_girl'

describe User, "When asked to validate" do
  it "should not create a new instance if the length of name is more than 30 characters" do
    user = User.new(:display_name => "12345678901234567890123456789012")
    user.should_not be_valid
    user.errors[:display_name].should_not be_empty
  end
end

describe Task, "When asked to get all tags" do
  before :each do
    Time.zone = "Central Time (US & Canada)"
  end

  it "should return tags associated with the user" do
    user = Factory(:user)
    tag = Factory(:tag)
    tag.user = user
    tag.save

    group = Factory(:group)
    tag2 = Factory(:tag)
    tag2.user = user
    tag2.save
    group.tags << tag2
    group.save

    tags = user.get_tags
    tags.count.should be == 2
    tags[0][0].should be == tag.name
    tags[1][0].should include("G: #{group.name.first(5)}")
  end
end
