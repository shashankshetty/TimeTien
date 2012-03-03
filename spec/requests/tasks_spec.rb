require 'spec_helper'
require 'factory_girl'

describe "Tasks" do
  #login_devise_user

  describe "GET /tasks" do
    it "works! (now write some real specs)", :ignore => true do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get user_root
      response.status.should be(200)
    end
  end
end
