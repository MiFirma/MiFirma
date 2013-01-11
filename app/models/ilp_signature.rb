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

class IlpSignature < Signature
  belongs_to :proposal, :class_name => 'IlpProposal'
	before_create :format_dni
	
	has_attached_file :tractis_signature, 
		{:path => ":rails_root/public/system/firmas/:promoter_name/ilp/:filename", 
		 :url => "/system/firmas/:promoter_name/ilp/:filename",
     :s3_permissions => :private}.merge(PAPERCLIP_CONFIG)
	
  validate :uniqueness_of_dni, :if => :signed?
	validates_presence_of :dni, :name, :surname, :surname2, 
		:message => "Debes rellenar todos los campos."	

	def uniqueness_of_dni
		if IlpSignature.where("state > 0 and dni = ? and proposal_id = ? and id <> ?",dni,proposal_id,id).count>0
			errors.add :dni, "Sólo puedes firmar esta ILP una sola vez."
		end
	end
	
	validate :dni_format

	# Validates NIF format
	def dni_format
		letters = "TRWAGMYFPDXBNJZSQVHLCKE"
		value = dni.clone
		if value.length > 1
			check = value.slice!(value.length - 1..value.length - 1).upcase
			calculated_letter = letters[value.to_i % 23].chr
			if !(check === calculated_letter)
				errors.add(:dni, "Formato DNI no válido.")
			end
		else
			errors.add(:dni, "Formato DNI no válido.")
		end
	end
	
	def notifier
		Notifier.ilp_signed(self).deliver
	end
	
	private
	# interpolate in paperclip
	Paperclip.interpolates :promoter_name  do |attachment, style|
		attachment.instance.proposal.promoter_short_name
	end


end
