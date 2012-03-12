require 'spec_helper'

describe Group, "When asked to validate" do
  it "should not create a new instance if the name is empty" do
    group = Group.new
    group.should_not be_valid
    group.errors[:name].should_not be_empty
  end
end

describe Group, "When asked to update users" do
  it "should add users to group including current user" do
    group = Factory(:group)
    user = Factory(:user)
    Membership.create!(:user => user, :group => group, :is_admin => true, :accepted => true)
    add_user = Factory(:user)
    users_to_add = [user.id, add_user.id]
    group.update_users(users_to_add.collect { |c| c }.join(','), user)
    group.save
    group.users.length.should be == 2
    group.users.include?(user).should be_true
    group.users.include?(add_user).should be_true
  end

  describe Group, "When asked to get membership" do
    it "should get users that belong to the group" do
      group = Factory(:group)
      user = Factory(:user)
      Membership.create!(:user => user, :group => group, :is_admin => true, :accepted => true)
      member = group.get_membership(user.id)
      member.user_id.should be == user.id
      member.group_id.should be == group.id
    end
  end

  describe Group, "When asked to get admins" do
    it "should get users that are admin of that group" do
      group = Factory(:group)
      user = Factory(:user)
      Membership.create!(:user => user, :group => group, :is_admin => true, :accepted => true)
      add_user = Factory(:user)
      group.update_users(add_user.id.to_s, user)
      group.save
      group.users.length.should be == 2
      group.admins.length.should be == 1
      member = group.get_membership(user.id)
      member.is_admin.should be_true
    end
  end

  describe Group, "When asked to update admins" do
    it "should set the user to admin including the current user even if current user is not selected in the list" do
      group = Factory(:group)
      user = Factory(:user)
      Membership.create!(:user => user, :group => group, :is_admin => true, :accepted => true)
      add_user = Factory(:user)
      users_to_add = [user.id, add_user.id]
      group.update_users(users_to_add.collect { |c| c }.join(','), user)
      group.update_admins([add_user.id.to_s], user)
      group.save
      group.admins.length.should be == 2
    end
  end
end