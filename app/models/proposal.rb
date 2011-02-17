class Proposal < ActiveRecord::Base
  has_many :signatures
  has_attached_file :pdf
  acts_as_list
  
  validates_presence_of :name, :problem, :howto_solve
end
