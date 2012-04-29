FactoryGirl.define do
  factory :user do |f|
    f.sequence(:email) { |n| "test#{n}@example.com" }
    f.password "abcdef"
  end

  factory :tag do |f|
    f.sequence(:name) { |n| "Work#{n}" }
    f.description "Work description"
  end

  factory :tag_with_user, :parent => :tag do |f|
    f.sequence(:name) { |n| "Work#{n}" }
    f.description "Work description"
    f.user { FactoryGirl.create(:user) }
  end

  factory :tassk do |f|
    f.tag { FactoryGirl.create(:tag) }
    f.start_time Time.now-2.days
  end

  factory :group do |f|
    f.sequence(:name) { |n| "Group#{n}" }
    f.description "Group description"
    end

  factory :membership do |f|
    f.user { FactoryGirl.create(:user) }
    f.group { FactoryGirl.create(:group) }
    f.is_admin true
    f.accepted false
  end

  factory :authentication do |f|
    f.user { FactoryGirl.create(:user) }
    f.group { FactoryGirl.create(:group) }
  end
end