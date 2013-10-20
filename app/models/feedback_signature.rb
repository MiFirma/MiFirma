class FeedbackSignature < ActiveRecord::Base
  belongs_to :reason_feedback
  belongs_to :signature
  belongs_to :proposal
  
  validates_presence_of :reason_feedback, :proposal
end
