class Proposal < ActiveRecord::Base
  has_many :signatures
	has_attached_file :pdf
	has_attached_file :banner
	acts_as_list
	
	validates_presence_of :name, :problem, :howto_solve, :position,
		:tractis_template_code, :pdf_file_name, :pdf_content_type, 
		:pdf_file_size, :pdf_updated_at, :num_required_signatures,
		:promoter_name, :promoter_url, :handwritten_signatures,
		:signatures_end_date, :promoter_short_name
	validates_uniqueness_of :name
	
	#When the proposal still can collect signatures
	scope :on_signature_time, lambda { where("signatures_end_date >= ?", Time.now ) }
  
	def on_signature_time?
		return signatures_end_date >= Time.now.to_date
	end
	
  def num_remaining_signatures
		num_required_signatures - num_signatures
	  if num_required_signatures == nil || num_required_signatures == 0
			num_remaining_signatures=0
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
    @num_signatures ||= signatures.signed.size + handwritten_signatures
  end
end
