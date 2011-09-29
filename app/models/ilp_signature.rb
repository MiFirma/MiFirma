class IlpSignature < Signature
  belongs_to :ilp_proposal, :class_name => 'IlpProposal', :foreign_key => "proposal_id"
	belongs_to :municipality
	belongs_to :municipality_of_birth, :class_name => 'Municipality', :foreign_key => "municipality_of_birth_id"
	belongs_to :province_of_birth, :class_name => 'Province', :foreign_key => "province_of_birth_id"
	
	
  validates_presence_of :municipality_of_birth_id, :province_of_birth_id, :address, :zipcode, :municipality_id, :message => "Debes rellenar todos los campos."
	
	validates_format_of :zipcode,
                    :with => /^[0-9]{5}$/i,
                    :message => "Código Postal incorrecto"
										
	def proposal
		return ilp_proposal
	end
end
