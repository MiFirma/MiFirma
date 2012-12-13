=begin

  This model is used to test:

    - Dragonfly Attachments
    - Paperclip Attachments

=end

class Asset < ActiveRecord::Base

  ##
  # Dragonfly Stuff
  #

  image_accessor :dragonfly
  image_accessor :dragonfly_required
  validates :dragonfly_required, :presence => true

  ##
  # Paperclip Stuff
  #

  has_attached_file :paperclip, :styles => { :medium => "300x300>", :thumb => "100x100>" }

  ##
  # Instance Methods
  #

  def original_file_name
  end

end
