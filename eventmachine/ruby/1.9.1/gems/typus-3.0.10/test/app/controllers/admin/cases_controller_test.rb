require "test_helper"

=begin

  What's being tested here?

    - Single Table Inheritance Stuff
    - Relate objects.
    - Unrelate objects.
    - Create (and relate objects).

=end

class Admin::CasesControllerTest < ActionController::TestCase

  setup do
    @typus_user = Factory(:typus_user)
    @request.session[:typus_user_id] = @typus_user.id
  end

end
