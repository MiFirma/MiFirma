class Signature < ActiveRecord::Base
  belongs_to :proposal
  
  validates_presence_of :proposal_id, :state, :token
  validates_presence_of :email, :name, :surname, :dni, :message => "Debes rellenar todos los campos."
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "Email no válido. Por favor, comprueba que has introducido correctamente tu dirección de correo electrónico."
  validates_acceptance_of :terms, :accept => true, :message => "Debes aceptar los términos de uso."
  
  validates_uniqueness_of :dni, :scope => :proposal_id, :message => "Sólo puedes firmar una vez esta propuesta."
  
  delegate :tractis_template_code, :to => :proposal
  
  before_validation :generate_token, :set_default_state
  
  named_scope :signed, :conditions => ["state > 0"]

  STATES = [:pending, :verified, :canceled]

  def return_url
    "http://www.mifirma.com/signatures/#{token}"
  end
  
  def contract_code
    tractis_contract_location.split("/")[4]
  end
  
  def check_tractis_signature!
    signed = TractisApi.contract_signed? contract_code    
    self.update_attribute :state, 1 if signed
  end
  
  def signed?
    state > 0
  end

  protected
  def generate_token
    self.token = ActiveSupport::SecureRandom.hex(15) if self.token.nil?
  end
    
  def set_default_state
    self.state = 0 if self.state.nil?
  end
  
end
