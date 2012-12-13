class Admin::ResourceController < Admin::BaseController

  before_filter :check_if_user_can_perform_action_on_resource

  def index
  end

end
