require 'test_helper'

class SignaturesControllerTest < ActionController::TestCase
  setup do
    @signature = signatures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:signatures)
  end

  test "should get new" do
    get :new
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

  test "should get edit" do
    get :edit, :id => @signature.to_param
    assert_response :success
  end

  test "should update signature" do
    put :update, :id => @signature.to_param, :signature => @signature.attributes
    assert_redirected_to signature_path(assigns(:signature))
  end

  test "should destroy signature" do
    assert_difference('Signature.count', -1) do
      delete :destroy, :id => @signature.to_param
    end

    assert_redirected_to signatures_path
  end
end
