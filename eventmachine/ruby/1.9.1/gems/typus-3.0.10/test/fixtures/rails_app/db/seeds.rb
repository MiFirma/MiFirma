# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require '../../factories'

##
# CRUD
##

50.times { Factory(:entry) }

##
# CRUD Extended
##

5.times { Factory(:category) }
5.times { Factory(:post) }

assets_path = "#{Rails.root}/db/seeds/assets"
5.times { |i| Factory(:asset,
                      :dragonfly => File.new("#{assets_path}/00#{i}.jpg"),
                      :dragonfly_required => File.new("#{assets_path}/00#{i}.jpg"),
                      :paperclip => File.new("#{assets_path}/00#{i}.jpg")) }

##
# HasManyThrough
##

5.times do
  project = Factory(:project)
  50.times do
    project.collaborators << Factory(:user)
  end
end

##
# HasOne
##

5.times { Factory(:invoice) }

##
# Polymorphic
##

5.times do
  Factory(:bird)
  Factory(:dog)
end
