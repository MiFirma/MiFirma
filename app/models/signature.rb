require 'hpricot'
require 'tractis_api'

class Signature < ActiveRecord::Base
	belongs_to :province
	
	has_attached_file :tractis_signature, 
		{:path => ":rails_root/public/system/firmas/:promoter_name/:province_id/:filename", :s3_permissions => :private}.merge(PAPERCLIP_CONFIG)
	
	validates_presence_of :proposal_id, :state, :token
  validates_presence_of :email, :date_of_birth, :message => "Debes rellenar todos los campos."
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "Email no válido. Por favor, comprueba que has introducido correctamente tu dirección de correo electrónico."
  validates_acceptance_of :terms, :accept => true, :message => "Debes aceptar los términos de uso."
  
	validates_date :date_of_birth, :before => lambda { 18.years.ago },
                              :before_message => "debe tener al menos 18 años", :after => lambda { 150.years.ago }, :after_message => "demasiados años"
	
  
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
	
	def Signature.get_all_signatures
		signatures = Signature.signed
		signatures.each do |s|
			s.check_and_get_tractis_signature
			sleep 0.5
		end
  end
  
  def check_and_get_tractis_signature
	
	  ::Rails.logger.debug "--- Comprobando firma de tractis ---"
		contract_response = TractisApi.contract contract_code,self
		doc = Hpricot(contract_response)
    signed = TractisApi.contract_signed? contract_response
		if signed then
			self.name = (doc/"signature"/"name").text
			logger.debug "Nombre recuperado"
			logger.debug self.name
			self.dni = (doc/"signature"/"serialnumber").text
			logger.debug "DNI recuperado"
			logger.debug self.dni
			
			copy_tractis_signature
		
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
 
  private
	def copy_tractis_signature
		::Rails.logger.debug "--- Copiando firmas desde tractis ---"
		contract_response = TractisApi.get_signatures contract_code,self
		::Rails.logger.debug "Tamaño del archivo de firmas:"
		::Rails.logger.debug contract_response.body.size
		file = StringIO.new(contract_response.body) #mimic a real upload file
		file.class.class_eval { attr_accessor :original_filename, :content_type } #add attr's that paperclip needs
		file.original_filename = "FD#{dni}.zip"
		file.content_type = "application/zip"

		self.tractis_signature = file
		
  end	
	
	# interpolate in paperclip
	Paperclip.interpolates :promoter_name  do |attachment, style|
		attachment.instance.proposal.promoter_short_name
	end
	
	Paperclip.interpolates :province_id  do |attachment, style|
		attachment.instance.province_id
	end
end
