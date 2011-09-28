require 'test_helper'

class EndorsmentSignaturesControllerTest < ActionController::TestCase
  setup do
    @endorsment_signature = endorsment_signatures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:endorsment_signatures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create endorsment_signature" do
    assert_difference('EndorsmentSignature.count') do
      post :create, :endorsment_signature => @endorsment_signature.attributes
    end

    assert_redirected_to endorsment_signature_path(assigns(:endorsment_signature))
  end

  test "should show endorsment_signature" do
    get :show, :id => @endorsment_signature.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @endorsment_signature.to_param
    assert_response :success
  end

  test "should update endorsment_signature" do
    put :update, :id => @endorsment_signature.to_param, :endorsment_signature => @endorsment_signature.attributes
    assert_redirected_to endorsment_signature_path(assigns(:endorsment_signature))
  end

  test "should destroy endorsment_signature" do
    assert_difference('EndorsmentSignature.count', -1) do
      delete :destroy, :id => @endorsment_signature.to_param
    end

    assert_redirected_to endorsment_signatures_path
  end
end
