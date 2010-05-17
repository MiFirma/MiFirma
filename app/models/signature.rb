class Signature < ActiveRecord::Base
  belogs_to :proposal
  
  validates_presence_of :proposal_id
end
