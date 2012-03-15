require 'spec_helper'
require 'factory_girl'
require 'ruby-debug'
require 'time'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe AnalyzeTasksController do
  login_user
  # This should return the minimal set of attributes required to create a valid
  # Task. As you add validations to Task, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {
        :tag_id => Factory(:tag),
        :start_time => Time.now,
        :user_id => @user.id
    }
  end

  describe "GET index" do
    it "assigns all tasks as @tasks" do
      get :analyze_user_tasks
      assigns(:search_query).tasks.should eq([])
    end
  end

  describe "GET index to group tasks" do
    it "assigns all tasks as @tasks" do
      get :analyze_group_tasks
      assigns(:search_query).tasks.should eq([])
    end
  end

  describe "POST get tags groups" do
    it "returns all the tags for the selected groups" do
      tag1 = Factory(:tag)
      tag2 = Factory(:tag)
      group = Factory(:group)
      tag1.group = group
      tag2.group = group
      tag1.save
      tag2.save
      post :get_group_tags, :groups => [group.id], :format => :json
      parsed_body = JSON.parse(response.body)
      parsed_body[0]["name"].should == tag1.name
      parsed_body[1]["name"].should == tag2.name
    end

    it "returns no tags if no group is selected" do
      post :get_group_tags, :groups => "null", :format => :json
      parsed_body = JSON.parse(response.body)
      parsed_body.should be_empty
    end

    it "returns no tags if the group has no tags" do
      group = Factory(:group)
      post :get_group_tags, :groups => [group.id], :format => :json
      parsed_body = JSON.parse(response.body)
      parsed_body.should be_empty
    end
  end

  describe "POST query tasks" do
    it "returns message to select atleast one tag" do
      Tassk.create! valid_attributes
      post :query_tasks, :query => "Search"
      assigns(:search_query).search_type.should be == "Search"
      assigns(:search_query).tasks.should eq([])
      flash[:info].should_not be_empty
    end
  end

  describe "POST search tasks" do
    it "returns all the relevant tasks" do
      task = Tassk.create! valid_attributes
      post :query_tasks, :query => "Search", :search_tag => [task.tag.id]
      assigns(:search_query).search_type.should be == "Search"
      assigns(:search_query).tasks.should eq([task])
    end
  end

  describe "POST analyze tasks" do
    it "returns all the relevant tasks" do
      post :query_tasks, :query => "Analyze"
      assigns(:search_query).search_type.should be == "Analyze"
      assigns(:search_query).tasks.should eq([])
    end
  end

  describe "DELETE destroy" do
    it "cannot destroy other users task" do
      task = Tassk.create! valid_attributes
      user = Factory(:user)
      task.user = user
      task.save
      post :destroy_task, :id => task.id, :format => :json
      parsed_body = JSON.parse(response.body)
      parsed_body["status"].should == "error"
    end

    it "destroys the requested task" do
      task = Tassk.create! valid_attributes
      expect {
        post :destroy_task, :id => task.id, :format => :json
      }.to change(Tassk, :count).by(-1)
    end

    it "returns a success message" do
      task = Tassk.create! valid_attributes
      post :destroy_task, :id => task.id, :format => :json
      parsed_body = JSON.parse(response.body)
      parsed_body["status"].should == "success"
    end
  end
end
