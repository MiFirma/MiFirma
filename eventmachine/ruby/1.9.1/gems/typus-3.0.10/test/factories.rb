##
# CRUD
##

Factory.define :entry do |f|
  f.sequence(:title) { |n| "Entry##{n}" }
  f.content "Body of the entry"
end

Factory.define :case do |f|
  f.sequence(:title) { |n| "Case##{n}" }
  f.content "Body of the entry"
end

##
# CRUD Extended
##

Factory.define :asset do |f|
  f.sequence(:caption) { |n| "Asset##{n}" }
  f.dragonfly File.new("#{Rails.root}/public/images/rails.png")
  f.dragonfly_required File.new("#{Rails.root}/public/images/rails.png")
  f.paperclip File.new("#{Rails.root}/public/images/rails.png")
end

Factory.define :category do |f|
  f.sequence(:name) { |n| "Category##{n}" }
end

Factory.define :comment do |f|
  f.sequence(:name) { |n| "Comment##{n}" }
  f.sequence(:email) { |n| "john+#{n}@example.com" }
  f.body "Body of the comment"
  f.association :post
end

Factory.define :page do |f|
  f.sequence(:title) { |n| "Page##{n}" }
  f.body "Content"
end

Factory.define :post do |f|
  f.sequence(:title) { |n| "Post##{n}" }
  f.body "Body"
  f.status "published"
end

Factory.define :typus_user do |f|
  f.sequence(:email) { |n| "user+#{n}@example.com" }
  f.role "admin"
  f.status true
  f.token "1A2B3C4D5E6F"
  f.password "12345678"
end

Factory.define :view do |f|
  f.ip "127.0.0.1"
  f.association :post
end

##
# HasOne Association
#

Factory.define :invoice do |f|
  f.sequence(:number) { |n| "Invoice##{n}" }
  f.association :order
end

Factory.define :order do |f|
  f.sequence(:number) { |n| "Order##{n}" }
end

##
# HasManyThrough Association
#

Factory.define :user do |f|
  f.sequence(:name) { |n| "User##{n}" }
  f.sequence(:email) { |n| "user.#{n}@example.com" }
end

Factory.define :project do |f|
  f.sequence(:name) { |n| "Project##{n}" }
  f.association :user
end

Factory.define :project_collaborators do |f|
  f.association :user
  f.association :project
end

##
# Polymorphic
##

Factory.define :animal do |f|
  f.sequence(:name) { |n| "Animal##{n}" }
end

Factory.define :bird do |f|
  f.sequence(:name) { |n| "Bird##{n}" }
end

Factory.define :dog do |f|
  f.sequence(:name) { |n| "Dog##{n}" }
end

Factory.define :image_holder do |f|
  f.sequence(:name) { |n| "ImageHolder##{n}" }
end
