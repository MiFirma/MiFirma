class Proposal < ActiveRecord::Base
  has_many :signatures
  has_attached_file :pdf
  acts_as_list
  
  validates_presence_of :name, :problem, :howto_solve
  
  def num_remaining_signatures
    num_required_signatures - num_signatures
  end
  
  def precent_remaining_signatures
    num_signatures.to_f / num_required_signatures.to_f
  end
  
  def num_signatures
    @num_signatures ||= signatures.signed.size
  end
  
end
