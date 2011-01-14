class Signature < ActiveRecord::Base
  belongs_to :proposal
  
  validates_presence_of :proposal_id, :state, :token
  validates_presence_of :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  delegate :tractis_contract_code, :to => :proposal
  
  before_validation :generate_token, :set_default_state

  STATES = [:pending, :verified, :canceled]

  def return_url
    "http://www.mifirma.com/signatures/#{token}"
  end

  protected
  def generate_token
    self.token = ActiveSupport::SecureRandom.hex(15)
  end
    
  def set_default_state
    self.state = 0
  end
  
end
