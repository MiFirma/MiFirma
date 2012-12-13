# == Schema Information
#
# Table name: signatures
#
#  id                             :integer         not null, primary key
#  proposal_id                    :integer
#  email                          :string(255)
#  state                          :integer
#  token                          :string(255)
#  tractis_contract_location      :string(255)
#  name                           :string(255)
#  dni                            :string(255)
#  surname                        :string(255)
#  terms                          :boolean
#  created_at                     :datetime
#  updated_at                     :datetime
#  province_id                    :integer
#  municipality_id                :integer
#  address                        :string(255)
#  zipcode                        :string(255)
#  date_of_birth                  :date
#  province_of_birth_id           :integer
#  municipality_of_birth_id       :integer
#  type                           :string(255)
#  surname2                       :string(255)
#  tractis_signature_file_name    :string(255)
#  tractis_signature_content_type :string(255)
#  tractis_signature_file_size    :integer
#  tractis_signature_updated_at   :datetime
#


require 'hpricot'
require 'psis_api'
require 'nokogiri'

class Signature < ActiveRecord::Base
	
	validates_presence_of :proposal_id, :state, :token
  validates_presence_of :email, :date_of_birth, :message => "Debes rellenar todos los campos."
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :message => "Email no válido. Por favor, comprueba que has introducido correctamente tu dirección de correo electrónico."
  
	validates_acceptance_of :terms, :accept => true, :message => "Debes aceptar los términos de uso."
  
	validates_date :date_of_birth, :before => lambda { 18.years.ago },
                              :before_message => "debe tener al menos 18 años", :after => lambda { 150.years.ago }, :after_message => "demasiados años"
	

  
  delegate :tractis_template_code, :attestor_template_code, :to => :proposal
  
  before_validation :generate_token, :set_default_state

  
  scope :signed, :conditions => ["state > 0"]

  STATES = [:pending, :verified, :canceled]

	attr_accessor  :xmlSigned #Sitio temporal donde va a residir la firma de FNMT  del applet de afirma

	
  def return_url
    "http://#{MIFIRMA_HOST}/signatures/#{token}"
  end
  
  def contract_code
    tractis_contract_location.split("/")[4]
  end
	
	# Método para recuperar TODAS las firmas desde un rake (de manera manual)
	def Signature.get_all_signatures
		signatures = Signature.signed
		signatures.each do |s|
			s.check_and_get_tractis_signature
			sleep 0.5
		end
  end
  
	#Validates againts PSIS the digital signature
	def validate_signature
		::Rails.logger.debug "--- Realizando comprobación de la firma con PSEIS ---"
		doc = Nokogiri::XML(xmlSigned)
		doc.remove_namespaces!
		
		cert = doc.xpath('//X509Data/X509Certificate').first.inner_text
		
		myValidation = PSISApi.new
		myValidation.validate cert
		return myValidation
	end
	
	
  def get_afirma_signature
	  copy_afirma_signature
			
		self.state = 1
		self.save
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

	def copy_afirma_signature
		::Rails.logger.debug "--- Copiando firmas desde applet afirma ---"
	
		::Rails.logger.debug "Tamaño del archivo de firma:"
		::Rails.logger.debug xmlSigned.size

		file = StringIO.new(xmlSigned) #mimic a real upload file
		file.class.class_eval { attr_accessor :original_filename, :content_type } #add attr's that paperclip needs
		file.original_filename = "FD#{dni}.xsig"
		file.content_type = "text/xml"

		self.tractis_signature = file

  end	
	
		# format dni with uppercase and leading zeros on the left
	def format_dni
	    if self.dni
				self.dni.upcase!
				self.dni = self.dni.rjust(9,"0") if self.dni.length < 9
			end
	end
end
