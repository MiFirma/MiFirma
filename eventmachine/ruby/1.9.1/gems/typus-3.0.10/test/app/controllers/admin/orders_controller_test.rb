require "test_helper"

=begin

  What's being tested here?

    - Order has_one Invoice

=end

class Admin::OrdersControllerTest < ActionController::TestCase

  setup do
    @typus_user = Factory(:typus_user)
    @request.session[:typus_user_id] = @typus_user.id
  end

end
