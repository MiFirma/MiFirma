class Proposal < ActiveRecord::Base
  
	has_attached_file :banner
	acts_as_list
	
	validates_presence_of :name, :problem, :howto_solve,
		:tractis_template_code, :promoter_name, :promoter_url,
		:signatures_end_date, :promoter_short_name

	
	#When the proposal still can collect signatures
	scope :on_signature_time, lambda { where("signatures_end_date >= ?", Time.now ) }
  
	def on_signature_time?
		return signatures_end_date >= Time.now.to_date
	end
	
	def self.inherited(child)
		child.instance_eval do
			def model_name
				Proposal.model_name
			end
		end
		super
	end
end
