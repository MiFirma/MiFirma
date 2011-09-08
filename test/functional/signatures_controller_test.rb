require 'test_helper'

class SignaturesControllerTest < ActionController::TestCase
  setup do
    @signature_finished = signatures(:javier)
		@signature_notfinished = signatures(:juan)
  end

  test "should get share" do
    get :share
    assert_response :success
  end

  test "should create signature" do
    assert_difference('Signature.count') do
      post :create, :signature => @signature_notfinished.attributes
    end

    assert_redirected_to signature_path(assigns(:signature_notfinished))
  end

  test "should show signature" do
    get :show, :id => @signature_finished.to_param
    assert_response :success
  end

end
