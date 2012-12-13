module Admin
  module DashboardHelper

    def resources(admin_user)
      available = Typus.resources.delete_if { |r| !(admin_user.is_a?(FakeUser) || admin_user.resources.include?(r)) }
      render "admin/helpers/dashboard/resources", :resources => available
    end

  end
end
