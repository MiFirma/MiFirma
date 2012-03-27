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

class AttestorSignature < Signature
  belongs_to :proposal, :class_name => 'IlpProposal'
	belongs_to :municipality
	belongs_to :municipality_of_birth, :class_name => 'Municipality', :foreign_key => "municipality_of_birth_id"
	belongs_to :province_of_birth, :class_name => 'Province', :foreign_key => "province_of_birth_id"
	belongs_to :province
	
  validate :uniqueness_of_dni
  validates_presence_of :municipality_of_birth_id, :province_of_birth_id, 
		:address, :municipality_id, :message => "Debes rellenar todos los campos."
		
	def uniqueness_of_dni
		if self.signed? and AttestorSignature.where("state > 0 and dni = ? and proposal_id = ? and id <> ?",dni,proposal_id,id).count>0
			errors.add :dni, "Sólo puedes firmar esta ILP una sola vez."
		end
	end
end
