class Invoice < ActiveRecord::Base

  ##
  # Associations
  #

  belongs_to :order
  belongs_to :typus_user

end
