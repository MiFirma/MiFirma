# == Schema Information
#
# Table name: elections
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  signatures_end_date :date
#  created_at          :datetime
#  updated_at          :datetime
#

class Election < ActiveRecord::Base
	has_many :endorsment_proposals

	validates_presence_of :name, :signatures_end_date
	validates_uniqueness_of :name
	
	
end
