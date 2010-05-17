class Signature < ActiveRecord::Base
  belongs_to :proposal
  
  validates_presence_of :proposal_id
end
