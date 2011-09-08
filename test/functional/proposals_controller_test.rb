require 'test_helper'

class ProposalsControllerTest < ActionController::TestCase
  setup do
    @proposal = proposals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
		# Should be compared with proposals but for now it's the same that show test
		assert_select 'div .proposal'
    assert_not_nil assigns(:proposals)
  end

  test "should show proposal" do
    get :show, :id => @proposal.to_param
    assert_response :success
		assert_select 'div .proposal'
  end

end
