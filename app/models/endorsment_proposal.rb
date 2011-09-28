class EndorsmentProposal < Proposal
	has_many :endorsment_signatures, :class_name => 'EndorsmentSignature', :foreign_key => "proposal_id"

  def num_signatures
    @num_signatures ||= endorsment_signatures.signed.size
  end	

end
