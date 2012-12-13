=begin

  This model is used to test polymorphic associations.

=end

class Animal < ActiveRecord::Base

  ##
  # Validations
  #

  validates :name, :presence => true

  ##
  # Associations
  #

  has_many :image_holders, :as => :imageable

end
