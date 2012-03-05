Factory.define :user do |f|
  f.sequence(:email) { |n| "test#{n}@example.com" }
  f.password "abcdef"
end

Factory.define :tag do |f|
  f.sequence(:name) { |n| "Work#{n}" }
  f.description "Work description"
end

Factory.define :tag_with_user, :parent => :tag do |f|
  f.sequence(:name) { |n| "Work#{n}" }
  f.description "Work description"
  f.user { Factory(:user) }
end

Factory.define :task do |f|
  f.tag { Factory(:tag) }
  f.start_time Time.now-2.days
end

Factory.define :group do |f|
  f.sequence(:name) { |n| "Group#{n}" }
  f.description "Group description"
end

Factory.define :authentication do |f|
  f.user { Factory(:user) }
  f.group { Factory(:group) }
end