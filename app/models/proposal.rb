class Proposal < ActiveRecord::Base
  has_many :signatures
	has_attached_file :pdf
	acts_as_list
	
	validates_presence_of :name, :problem, :howto_solve
  
  def num_remaining_signatures
		num_required_signatures - num_signatures
	  if num_required_signatures == nil or num_required_signatures == 0
			num_remaining_signatures=0
		else
			num_required_signatures - num_signatures
   	end	
  end
  
  def precent_remaining_signatures
	  if num_required_signatures == nil or num_required_signatures == 0
			precent_remaining_signatures = 0
		else
			num_signatures.to_f / num_required_signatures.to_f
		end
  end
  
  def num_signatures
    @num_signatures ||= signatures.signed.size
  end
end
