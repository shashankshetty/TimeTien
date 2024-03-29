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

describe TasksController do
  login_user
  # This should return the minimal set of attributes required to create a valid
  # Task. As you add validations to Task, be sure to
  # update the return value of this method accordingly.

  before(:each) do
    @task = FactoryGirl.create(:tassk)
    @task.user = @user
    @task.save

    @tag = @task.tag
  end

  describe "GET manage" do
    it "assigns all tasks as @tasks" do
      get :manage
      assigns(:manage_task).tasks.should eq([@task])
    end
  end

  describe "GET new" do
    it "assigns a new task as @task" do
      get :new
      assigns(:task).should be_a_new(Tassk)
    end
  end

  describe "GET edit" do
    it "assigns the requested task as @task" do
      get :edit, :id => @task.id
      assigns(:task).should eq(@task)
    end
  end

  describe "POST create" do

    describe "with valid params for task type with times" do
      def valid_attributes
        {
            :tag_id => @tag.id,
            :start_time => Time.now,
            :user_id => @user.id
        }
      end

      it "creates a new Task" do
        expect {
          post :create, :task => valid_attributes, :task_type => "wt"
        }.to change(Tassk, :count).by(1)
      end

      it "assigns a newly created task as @task" do
        post :create, :task => valid_attributes, :task_type => "wt"
        assigns(:task).should be_a(Tassk)
        assigns(:task).should be_persisted
      end

      it "renders edit template" do
        post :create, :task => valid_attributes, :task_type => "wt"
        task = assigns(:task)
        response.should redirect_to(edit_task_path(task))
      end
    end

    describe "with valid params for task type with no times" do
      def valid_attributes
        {
            :tag_id => @tag.id,
            :user_id => @user.id
        }
      end

      it "creates a new Task" do
        expect {
          post :create, :task => valid_attributes, :task_date => "6/19/2012", :select_tag => @tag.id, :time_spent_hours => "5", :time_spent_minutes => "0", :task_type => "wnt"
        }.to change(Tassk, :count).by(1)
      end

      it "assigns a newly created task as @task" do
        post :create, :task => valid_attributes, :task_date => "6/19/2012", :select_tag => @tag.id, :time_spent_hours => "5", :time_spent_minutes => "0", :task_type => "wnt"
        assigns(:task).should be_a(Tassk)
        assigns(:task).should be_persisted
      end

      it "renders edit template" do
        post :create, :task => valid_attributes, :task_date => "6/19/2012", :select_tag => @tag.id, :time_spent_hours => "5", :time_spent_minutes => "0", :task_type => "wnt"
        task = assigns(:task)
        response.should redirect_to(edit_task_path(task))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved task as @task" do
        # Trigger the behavior that occurs when invalid params are submitted
        Tassk.any_instance.stub(:save).and_return(false)
        post :create, :task => {}
        assigns(:task).should be_a_new(Tassk)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Tassk.any_instance.stub(:save).and_return(false)
        post :create, :task => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params for task with no times" do
      def valid_attributes
        {
            :tag_id => @tag.id,
            :user_id => @user.id
        }
      end

      it "updates the requested task" do
        task = Tassk.create!(:tag => @tag, :user => @user, :start_time => DateTime.now.beginning_of_day, :additional_time_spent => 300, :task_type => 'wnt')
        put :update, :id => task.id, :task => valid_attributes, :task_date => "08/10/2012", :select_tag => @tag.id, :time_spent_hours => "5", :time_spent_minutes => "0", :task_type => 'wnt'
        assigns(:task).start_time.strftime("%m/%d/%Y").should eq("08/10/2012")
      end

      it "assigns the requested task as @task" do
        task = Tassk.create!(:tag => @tag, :user => @user, :start_time => DateTime.now.beginning_of_day, :end_time => DateTime.now.beginning_of_day, :additional_time_spent => 300, :task_type => 'wnt')
        put :update, :id => task.id, :task => valid_attributes, :task_date => DateTime.now.beginning_of_day, :select_tag => @tag.id, :time_spent_hours => "5", :time_spent_minutes => "0", :task_type => 'wnt'
        assigns(:task).should eq(task)
      end

      it "renders edit template", :ignore => true do
        task = Tassk.create!(:tag => @tag, :user => @user, :start_time => DateTime.now.beginning_of_day, :end_time => DateTime.now.beginning_of_day, :additional_time_spent => 300, :task_type => 'wnt')
        put :update, :id => task.id, :task => valid_attributes, :task_date => DateTime.now.beginning_of_day, :select_tag => @tag.id, :time_spent_hours => "5", :time_spent_minutes => "0", :task_type => 'wnt'
        response.should render_template("edit")
      end
    end

    describe "with valid params for task with times" do
      def valid_attributes
        {
            :tag_id => @tag.id,
            :start_time => Time.now,
            :user_id => @user.id
        }
      end

      def update_attributes
        {
            :tag_id => @tag.id,
            :start_time => "08/10/2012",
            :user_id => @user.id,
            :end_time => "08/11/2012"
        }
      end

      it "updates the requested task" do
        task = Tassk.create! valid_attributes
        put :update, :id => task.id, :task => update_attributes
        assigns(:task).end_time.strftime("%m/%d/%Y").should eq(update_attributes[:end_time])
      end

      it "assigns the requested task as @task" do
        task = Tassk.create! valid_attributes
        put :update, :id => task.id, :task => valid_attributes
        assigns(:task).should eq(task)
      end

      it "renders edit template", :ignore => true do
        task = Tassk.create! valid_attributes
        put :update, :id => task.id, :task => valid_attributes
        response.should render_template("edit")
      end
    end

    describe "with invalid params" do
      it "assigns the task as @task" do
        Tassk.any_instance.stub(:save).and_return(false)
        put :update, :id => @task.id, :task => {}
        assigns(:task).should eq(@task)
      end

      it "re-renders the 'edit' template" do
        Tassk.any_instance.stub(:save).and_return(false)
        put :update, :id => @task.id, :task => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested task" do
      expect {
        delete :destroy, :id => @task.id
      }.to change(Tassk, :count).by(-1)
    end

    it "redirects to home page" do
      delete :destroy, :id => @task.id
      response.should redirect_to(root_url)
    end
  end

  describe "Start the task" do
    def valid_attributes
      {
          :tag_id => @tag.id,
          :start_time => Time.now,
          :user_id => @user.id
      }
    end

    describe "with valid params" do
      it "creates the task with user, current time and selected tag" do
        expect {
          post :start_task, :task => valid_attributes, :select_tag => @tag.id
        }.to change(Tassk, :count).by(1)
      end

      it "assigns a newly created task as @task" do
        post :start_task, :task => valid_attributes, :select_tag => @tag.id
        assigns(:task).should be_a(Tassk)
        assigns(:task).user should_not be_nil
        assigns(:task).should be_persisted
      end

      it "re-renders home page" do
        post :start_task, :id => @task.id, :select_tag => @tag.id
        response.should render_template("manage")
      end
    end

    describe "with invalid params" do
      it "returns an error message if Tag is not selected" do
        post :start_task, :task => valid_attributes, :select_tag => ""
        flash.now[:error].should == "Select a task to start"
      end
      it "returns an error message if Tag is new_tag and add_tag is blank" do
        post :start_task, :task => valid_attributes, :select_tag => "[new_tag]", :add_tag => ""
        flash.now[:error].should == "Add new task to start"
      end
    end
  end

  describe "Stop the task" do
    it "stops the existing task" do
      now = Time.mktime(2012, 1, 20, 0, 0, 0)
      Time.stub!(:now).and_return(now)
      post :stop_task, :id => @task.id, :select_tag => @task.tag
      (assigns(:task).end_time == now).should be_true
    end

    it "re-renders home page" do
      post :stop_task, :id => @task.id, :select_tag => @task.tag
      response.should render_template("manage")
    end
  end
end
