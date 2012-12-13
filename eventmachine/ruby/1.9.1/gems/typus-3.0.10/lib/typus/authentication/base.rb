module Typus
  module Authentication
    module Base

      def admin_user
        @admin_user
      end

      def authenticate; end
      def check_if_user_can_perform_action_on_user; end
      def check_if_user_can_perform_action_on_resources; end
      def check_if_user_can_perform_action_on_resource; end
      def check_resource_ownership; end
      def check_resources_ownership; end
      def set_attributes_on_create; end
      def set_attributes_on_update; end

    end
  end
end
