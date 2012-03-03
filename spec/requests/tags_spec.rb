require 'spec_helper'
require 'factory_girl'

describe "Tags" do
  #login_devise_user

  describe "GET /tags" do
    it "works! (now write some real specs)", :ignore => true do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get tags_path
      response.status.should be(200)
    end
  end
end
