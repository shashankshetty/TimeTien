require 'spec_helper'
require 'factory_girl'

describe "Projects" do
  describe "GET /projects" do
    before :each do
      user = FactoryGirl.create(:user)
      #login_devise_user(user)
    end

    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      #get projects_path
      #response.status.should be(200)
    end
  end
end
