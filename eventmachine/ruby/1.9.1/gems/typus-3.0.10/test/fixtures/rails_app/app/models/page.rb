=begin

  This model is used to test:

    - ActsAsTree
    - Default Scope

=end

class Page < ActiveRecord::Base

  ##
  # Mixins
  #

  acts_as_tree

  ##
  # Scopes
  #

  default_scope where(:status => true)

end
