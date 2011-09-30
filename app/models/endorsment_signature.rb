class EndorsmentSignature < Signature
  belongs_to :endorsment_proposal, :class_name => 'EndorsmentProposal', :foreign_key => "proposal_id"

  def proposal
    return endorsment_proposal
  end
end
