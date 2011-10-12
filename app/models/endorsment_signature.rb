class EndorsmentSignature < Signature
  belongs_to :endorsment_proposal, :class_name => 'EndorsmentProposal', :foreign_key => "proposal_id"
	
	validates_presence_of :name, :surname, :surname2, :dni
	validate :dni_format
  validate :uniqueness_of_dni
	
  def proposal
    return endorsment_proposal
  end

	def uniqueness_of_dni
		if self.signed? and EndorsmentSignature.signed.find_by_dni(dni)
			errors.add :dni, "Sólo puedes firmar un aval una sola vez."
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
				errors.add(:dni, "Formato DNI no válido.")
			end
		else
			errors.add(:dni, "Formato DNI no válido.")
		end
	end
end
