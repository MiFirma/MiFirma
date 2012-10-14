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
#  attestor_template_code  :string(255)
#  user_id                 :integer
#

class EndorsmentProposal < Proposal
	has_many :signatures, :class_name => 'EndorsmentSignature', :foreign_key => "proposal_id"
	belongs_to :election
	
	validates :election_type, :inclusion => { :in => (["CONGRESO","SENADO", "CONGRESO Y SENADO","PARLAMENTO EUROPEO","ASAMBLEA AUTONOMICA"]),
    :message => "%{value} no es un tipo de elecciónes válido. Los tipos son:CONGRESO,SENADO, CONGRESO Y SENADO,PARLAMENTO EUROPEO" }

	def signatures_end_date
		return election.signatures_end_date
	end
	
	def self.on_signature_time
	  return EndorsmentProposal.joins(:election).where('elections.signatures_end_date >= ?', Time.now ) 
	end
	
  def num_signatures
    @num_signatures ||= signatures.signed.size
  end	
	
	def num_signatures_by_province
		@num_signatures_by_province ||= signatures.joins(:province).signed.select("province_id, count(*) as total_signatures").group("province_id")
	end
	
end
