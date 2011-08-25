require 'hpricot'

class Signature < ActiveRecord::Base
  belongs_to :proposal
	belongs_to :municipality
	
	validates_presence_of :proposal_id, :state, :token
  validates_presence_of :email, :province_id, :municipality_id, :message => "Debes rellenar todos los campos."
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "Email no válido. Por favor, comprueba que has introducido correctamente tu dirección de correo electrónico."
  validates_acceptance_of :terms, :accept => true, :message => "Debes aceptar los términos de uso."
  
  validates_uniqueness_of :dni, :scope => :proposal_id, :if => Proc.new { |sig| sig.state > 0 }, :message => "Sólo puedes firmar una vez esta propuesta."
  
  delegate :tractis_template_code, :to => :proposal
  
  before_validation :generate_token, :set_default_state
  
  scope :signed, :conditions => ["state > 0"]

  STATES = [:pending, :verified, :canceled]

  def return_url
    "http://#{MIFIRMA_HOST}/signatures/#{token}"
  end
  
  def contract_code
    tractis_contract_location.split("/")[4]
  end
  
  def check_tractis_signature
		contract_response = TractisApi.contract contract_code
		doc = Hpricot(contract_response)
    signed = TractisApi.contract_signed? contract_response
		if signed then
			self.name = (doc/"signature"/"name").text
			logger.debug "Nombre recuperado"
			logger.debug self.name
			self.dni = (doc/"signature"/"serialnumber").text
			logger.debug "DNI recuperado"
			logger.debug self.dni
			self.state = 1
			self.save
  	end

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
