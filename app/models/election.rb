class Election < ActiveRecord::Base
	has_many :endorsment_proposals

	validates_presence_of :name, :signatures_end_date
	validates_uniqueness_of :name
	
	
end
