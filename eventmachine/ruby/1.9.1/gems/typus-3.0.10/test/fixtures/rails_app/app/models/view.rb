=begin

  This model is used to test:

    - View.typus_application when no application is set.

=end

class View < ActiveRecord::Base

  ##
  # Associations
  #

  belongs_to :post

end
