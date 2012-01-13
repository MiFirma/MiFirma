class EndorsmentProposal < Proposal
	has_many :endorsment_signatures, :class_name => 'EndorsmentSignature', :foreign_key => "proposal_id"
	belongs_to :election
	
	validates :election_type, :inclusion => { :in => (["CONGRESO","SENADO", "CONGRESO Y SENADO","PARLAMENTO EUROPEO"]),
    :message => "%{value} no es un tipo de elecciónes válido. Los tipos son:CONGRESO,SENADO, CONGRESO Y SENADO,PARLAMENTO EUROPEO" }

	def signatures_end_date
		return election.signatures_end_date
	end
	
	def self.on_signature_time
	  return EndorsmentProposal.joins(:election).where('elections.signatures_end_date >= ?', Time.now ) 
	end
	
  def num_signatures
    @num_signatures ||= endorsment_signatures.signed.size
  end	
	
	def num_signatures_by_province
		@num_signatures_by_province ||= endorsment_signatures.joins(:province).signed.select("province_id, count(*) as total_signatures").group("province_id")
	end
	
	def num_signatures_signed
		return endorsment_signatures.signed.size
	end
end
