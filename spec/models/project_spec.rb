require 'spec_helper'

describe Project, "When asked to validate" do
  it "should not create a new instance if the name is empty" do
    project = Project.new
    project.should_not be_valid
    project.errors[:name].should_not be_empty
  end
end

describe Project, "When asked to update users" do
  it "should add users to project including current user" do
    project = FactoryGirl.create(:project)
    user = FactoryGirl.create(:user)
    Membership.create!(:user => user, :project => project, :is_admin => true, :accepted => true)
    add_user = FactoryGirl.create(:user)
    users_to_add = [user.id, add_user.id]
    project.update_users(users_to_add.collect { |c| c }.join(','), user)
    project.save
    project.users.length.should be == 2
    project.users.include?(user).should be_true
    project.users.include?(add_user).should be_true
  end

  describe Project, "When asked to get membership" do
    it "should get users that belong to the project" do
      project = FactoryGirl.create(:project)
      user = FactoryGirl.create(:user)
      Membership.create!(:user => user, :project => project, :is_admin => true, :accepted => true)
      member = project.get_membership(user.id)
      member.user_id.should be == user.id
      member.project_id.should be == project.id
    end
  end

  describe Project, "When asked to get admins" do
    it "should get users that are admin of that project" do
      project = FactoryGirl.create(:project)
      user = FactoryGirl.create(:user)
      Membership.create!(:user => user, :project => project, :is_admin => true, :accepted => true)
      add_user = FactoryGirl.create(:user)
      project.update_users(add_user.id.to_s, user)
      project.save
      project.users.length.should be == 2
      project.admins.length.should be == 1
      member = project.get_membership(user.id)
      member.is_admin.should be_true
    end
  end

  describe Project, "When asked to update admins" do
    it "should set the user to admin including the current user even if current user is not selected in the list" do
      project = FactoryGirl.create(:project)
      user = FactoryGirl.create(:user)
      Membership.create!(:user => user, :project => project, :is_admin => true, :accepted => true)
      add_user = FactoryGirl.create(:user)
      users_to_add = [user.id, add_user.id]
      project.update_users(users_to_add.collect { |c| c }.join(','), user)
      project.update_admins([add_user.id.to_s], user)
      project.save
      project.admins.length.should be == 2
    end
  end
end