# == Schema Information
#
# Table name: proposals
#
#  id                      :integer         not null, primary key
#  name                    :string(255)
#  position                :integer
#  tractis_template_code   :string(255)
#  pdf_file_name           :string(255)
#  pdf_content_type        :string(255)
#  pdf_file_size           :integer
#  pdf_updated_at          :datetime
#  num_required_signatures :integer
#  promoter_name           :string(255)
#  promoter_url            :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  handwritten_signatures  :integer
#  banner_file_name        :string(255)
#  banner_content_type     :string(255)
#  banner_file_size        :integer
#  banner_updated_at       :datetime
#  promoter_short_name     :string(255)
#  signatures_end_date     :date
#  type                    :string(255)
#  howto_solve             :text
#  election_type           :string(255)
#  problem                 :text
#  election_id             :integer
#

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
