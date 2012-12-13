module Typus
  module Authentication
    module None

      protected

      include Base

      def authenticate
        @admin_user = FakeUser.new
      end

    end
  end
end
