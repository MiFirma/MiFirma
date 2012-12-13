=begin

  This model is used to test polymorphic associations.

=end

class ImageHolder < ActiveRecord::Base

  ##
  # Validations
  #

  validates :name, :presence => true

  ##
  # Associations
  #

  belongs_to :imageable, :polymorphic => true

end
