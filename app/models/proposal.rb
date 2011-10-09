class Proposal < ActiveRecord::Base
  
	has_attached_file :banner, PAPERCLIP_CONFIG
	acts_as_list
	
	validates_presence_of :name, :problem, :howto_solve, 
		:promoter_name, :promoter_url, :tractis_template_code,
		:signatures_end_date, :promoter_short_name

	
	#When the proposal still can collect signatures
	scope :on_signature_time, lambda { where("signatures_end_date >= ?", Time.now ) }
  
	def on_signature_time?
		return signatures_end_date >= Time.now.to_date
	end
	
	
end
