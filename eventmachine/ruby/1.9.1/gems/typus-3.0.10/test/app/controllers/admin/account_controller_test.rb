require "test_helper"

=begin

  What's being tested here?

    - Create first user. (/admin/account/new)
    - Stuff that happens when there are already users.

=end

class Admin::AccountControllerTest < ActionController::TestCase

  context "No users" do

    should "render new when there are not admin users" do
      get :new

      assert_response :success
      assert_template "new"
      assert_equal "Enter your email below to create the first user.", flash[:notice]
    end

    should "render session layout" do
      get :new
      assert_template "new"
      assert_template "layouts/admin/session"
    end

    should "verify forgot_password redirects to new when there are no admin users" do
      get :forgot_password

      assert_response :redirect
      assert_redirected_to new_admin_account_path
    end

    should "verify send_password redirects to new when there are no admin users"

    should "not sign_up invalid emails" do
      post :create, :typus_user => { :email => "example.com" }

      assert_response :redirect
      assert_redirected_to :action => :new
      assert flash.empty?
    end

    should "sign_up a valid email" do
      assert_difference('TypusUser.count') do
        post :create, :typus_user => { :email => "john@example.com" }
      end

      assert_response :redirect
      assert_redirected_to :action => "show", :id => TypusUser.find_by_email("john@example.com").token
    end

  end

  context "There are users" do

    setup do
      @typus_user = Factory(:typus_user)
    end

    should "new redirect new admin session when there are admin users" do
      get :new
      assert_response :redirect
      assert_redirected_to new_admin_session_path
    end

    should "verify forgot_password is rendered when there are admin users" do
      get :forgot_password
      assert_response :success
      assert_template "forgot_password"
    end

    should "not_send_recovery_password_link_to_unexisting_user" do
      post :send_password, { :typus_user => { :email => "unexisting" } }
      assert_response :success
      assert flash.empty?
    end

    should "test_should_send_recovery_password_link_to_existing_user" do
      post :send_password, { :typus_user => { :email => @typus_user.email } }

      assert_response :redirect
      assert_redirected_to new_admin_session_path
      assert_equal "Password recovery link sent to your email.", flash[:notice]
    end

    should "test_should_create_admin_user_session_and_redirect_user_to_its_details" do
      get :show, :id => @typus_user.token

      assert_equal @typus_user.id, @request.session[:typus_user_id]
      assert_response :redirect
      assert_redirected_to :controller => "/admin/typus_users", :action => "edit", :id => @typus_user.id
    end

    should "test_should_return_404_on_reset_passsword_if_token_is_not_valid" do
      assert_raises ActiveRecord::RecordNotFound do
        get :show, :id => "unexisting"
      end
    end

  end

end
