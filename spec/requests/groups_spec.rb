require 'spec_helper'
require 'factory_girl'

describe "Groups" do
  describe "GET /groups" do
    before :each do
      user = FactoryGirl.create(:user)
      #login_devise_user(user)
    end

    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get groups_path
      #response.status.should be(200)
    end
  end
end
