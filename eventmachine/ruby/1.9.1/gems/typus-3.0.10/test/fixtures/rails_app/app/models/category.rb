=begin

  This model is used to test:

    - ActsAsList on resources_controller
    - Relate and unrelate for has_and_belongs_to_many.

=end

class Category < ActiveRecord::Base

  ##
  # Mixins
  #

  acts_as_list

  ##
  # Validations
  #

  validates :name, :presence => true

  ##
  # Associations
  #

  has_and_belongs_to_many :entries
  has_and_belongs_to_many :posts

end
