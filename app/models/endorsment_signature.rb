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

class EndorsmentSignature < Signature
	belongs_to :province
  belongs_to :proposal, :class_name => 'EndorsmentProposal'
	before_create :format_dni
	
	has_attached_file :tractis_signature, 
		{:path => ":rails_root/public/system/firmas/:promoter_name/:province_id/:filename", 
		 :url => "/system/firmas/:promoter_name/:province_id/:filename", 
		 :s3_permissions => :private}.merge(PAPERCLIP_CONFIG)
	
	validates_presence_of :province
	validates_presence_of :name, :surname, :surname2
	validate :uniqueness_of_dni
	
	validate :dni_or_nie_format
	
	def circunscripcion
			if proposal.election_type == "PARLAMENTO EUROPEO" then
				circunscripcion = "Circunscripción Nacional"
			else
				circunscripcion = signature.province.name 
			end
	end
	
	
	def dni_or_nie_format
		if !(dni_format or nie_format)
			errors.add(:dni, "Formato DNI o NIE no válido.")
		end
	end
	
	# Validates NIF
	def dni_format
		letters = "TRWAGMYFPDXBNJZSQVHLCKE"
		value = dni.clone
		if value.length > 1
			check = value.slice!(value.length - 1..value.length - 1).upcase
			calculated_letter = letters[value.to_i % 23].chr
			if !(check === calculated_letter)
				return false
			else
				return true
			end
		else
			return false
		end
	end
	
	# Validates NIE
	def nie_format
		letters = "TRWAGMYFPDXBNJZSQVHLCKE"
		value = dni.clone
		if value.length > 1 then
			check = value.slice!(value.length - 1..value.length - 1).upcase
			checkI = value.slice!(0).upcase
			
			if (checkI == "Y") then
				value = "1" + value
			elsif (checkI == "Z") then
				value = "2" + value
			end
		
			calculated_letter = letters[value.to_i % 23].chr
			if !(check === calculated_letter)
				return false
			else
				return true
			end
		else
			return false
		end
	end
	
	
	# Valida que el DNI sea único para este partido en estas elecciones
	def uniqueness_of_dni
		if self.signed? and EndorsmentSignature.joins("INNER JOIN proposals ON proposals.id = signatures.proposal_id").where("signatures.state > 0 and signatures.dni = ? and proposals.election_id = ? and signatures.id <> ?",dni,proposal.election_id,id).count>0
			errors.add :dni, "Sólo puedes firmar un aval una sola vez."
		end
	end

	def notifier
		Notifier.endorsment_signed(self).deliver
	end
 
	private
		# interpolate in paperclip
	Paperclip.interpolates :promoter_name  do |attachment, style|
		attachment.instance.proposal.promoter_short_name
	end
	
	Paperclip.interpolates :province_id  do |attachment, style|
		attachment.instance.province_id
	end
end
