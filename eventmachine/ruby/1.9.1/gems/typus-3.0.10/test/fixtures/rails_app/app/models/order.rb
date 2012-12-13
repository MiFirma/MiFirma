class Order < ActiveRecord::Base

  ##
  # Associations
  #

  has_one :invoice

end
