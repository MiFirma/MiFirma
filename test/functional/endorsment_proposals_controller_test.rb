require 'test_helper'

class EndorsmentProposalsControllerTest < ActionController::TestCase
  setup do
    @endorsment_proposal = endorsment_proposals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:endorsment_proposals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create endorsment_proposal" do
    assert_difference('EndorsmentProposal.count') do
      post :create, :endorsment_proposal => @endorsment_proposal.attributes
    end

    assert_redirected_to endorsment_proposal_path(assigns(:endorsment_proposal))
  end

  test "should show endorsment_proposal" do
    get :show, :id => @endorsment_proposal.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @endorsment_proposal.to_param
    assert_response :success
  end

  test "should update endorsment_proposal" do
    put :update, :id => @endorsment_proposal.to_param, :endorsment_proposal => @endorsment_proposal.attributes
    assert_redirected_to endorsment_proposal_path(assigns(:endorsment_proposal))
  end

  test "should destroy endorsment_proposal" do
    assert_difference('EndorsmentProposal.count', -1) do
      delete :destroy, :id => @endorsment_proposal.to_param
    end

    assert_redirected_to endorsment_proposals_path
  end
end
