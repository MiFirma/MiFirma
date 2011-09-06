require 'test_helper'

class SignaturesControllerTest < ActionController::TestCase
  setup do
    @signature = signatures(:javier)
  end

  test "should get share" do
    get :share
    assert_response :success
  end

  test "should create signature" do
    assert_difference('Signature.count') do
      post :create, :signature => @signature.attributes
    end

    assert_redirected_to signature_path(assigns(:signature))
  end

  test "should show signature" do
    get :show, :id => @signature.to_param
    assert_response :success
  end

end
