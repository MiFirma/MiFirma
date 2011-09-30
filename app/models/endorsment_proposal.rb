class EndorsmentProposal < Proposal
	has_many :endorsment_signatures, :class_name => 'EndorsmentSignature', :foreign_key => "proposal_id"
	
	validates :election_type, :inclusion => { :in => (["CONGRESO","SENADO", "CONGRESO Y SENADO","PARLAMENTO EUROPEO"]),
    :message => "%{value} no es un tipo de elecciónes válido. Los tipos son:CONGRESO,SENADO, CONGRESO Y SENADO,PARLAMENTO EUROPEO" }


  def num_signatures
    @num_signatures ||= endorsment_signatures.signed.size
  end	

end
