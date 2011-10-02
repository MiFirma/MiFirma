class EndorsmentSignature < Signature
  belongs_to :endorsment_proposal, :class_name => 'EndorsmentProposal', :foreign_key => "proposal_id"
	
	validates_presence_of :name, :surname, :surname2, :dni
	validate :dni_format
	
  def proposal
    return endorsment_proposal
  end
	
	# Validates NIF
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
end
