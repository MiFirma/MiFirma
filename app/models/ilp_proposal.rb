class IlpProposal < Proposal
	has_many :ilp_signatures, :class_name => 'IlpSignature', :foreign_key => "proposal_id"
	
	has_attached_file :pdf, PAPERCLIP_CONFIG
	
	validates_presence_of :pdf_file_name, :pdf_content_type,
		:pdf_file_size, :pdf_updated_at, :num_required_signatures,
		:handwritten_signatures, :signatures_end_date
	validates_uniqueness_of :name

  #When the proposal still can collect signatures
	scope :on_signature_time, lambda { where("signatures_end_date >= ?", Time.now ) }
	
  def num_remaining_signatures
		num_required_signatures - num_signatures
	  if num_required_signatures == nil || num_required_signatures == 0
			num_remaining_signatures = 0
		else
			num_required_signatures - num_signatures
   	end	
  end
  
  def precent_remaining_signatures
	  if num_required_signatures == nil || num_required_signatures == 0
			precent_remaining_signatures = 0
		else
			num_signatures.to_f / num_required_signatures.to_f
		end
  end
  
  def num_signatures
    @num_signatures ||= ilp_signatures.signed.size + handwritten_signatures
  end	
	
	def num_signatures_signed
		return ilp_signatures.signed.size
	end
end