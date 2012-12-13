class Project < ActiveRecord::Base

  ##
  # Validations
  #

  validates :user, :presence => true

  ##
  # Associations
  #

  belongs_to :user
  has_many :collaborators, :through => :project_collaborators, :source => :user
  has_many :project_collaborators, :dependent => :destroy

end
