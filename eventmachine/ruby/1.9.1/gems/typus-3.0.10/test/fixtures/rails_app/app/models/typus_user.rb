class TypusUser < ActiveRecord::Base

  ##
  # Constants
  #

  ROLE = Typus::Configuration.roles.keys.sort
  LOCALE = Typus.locales

  ##
  # Mixins
  #

  enable_as_typus_user

  ##
  # Associations
  #

  has_many :invoices

end
