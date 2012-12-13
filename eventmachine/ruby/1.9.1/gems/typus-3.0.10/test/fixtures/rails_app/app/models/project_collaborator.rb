class ProjectCollaborator < ActiveRecord::Base

  ##
  # Validations
  #

  validates_uniqueness_of :user_id, :scope => :project_id

  ##
  # Associations
  #

  belongs_to :user
  belongs_to :project

end
