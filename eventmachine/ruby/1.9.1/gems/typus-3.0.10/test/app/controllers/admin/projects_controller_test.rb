require "test_helper"

=begin

  What's being tested here?

    - HasManyThrough

=end

class Admin::ProjectsControllerTest < ActionController::TestCase

  setup do
    @typus_user = Factory(:typus_user)
    @request.session[:typus_user_id] = @typus_user.id

    @project = Factory(:project)
    @user = @project.user
  end

  should_eventually "be able to destroy items" do
    get :destroy, :id => @user.id, :method => :delete

    assert_response :redirect
    assert_equal "User successfully removed.", flash[:notice]
    assert_redirected_to :action => :index
  end

  context "relate colaborators to project" do

    setup do
      @request.env['HTTP_REFERER'] = "/admin/projects/edit/#{@project.id}"
    end

    should "work" do
      user = Factory(:user)

      assert_difference('@project.collaborators.count') do
        post :relate, { :id => @project.id,
                        :related => { :model => 'User', :id => user.id, :association_name => 'collaborators' } }
      end

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Project successfully updated.", flash[:notice]
    end

    should_eventually "not allow to add collaborator twice"

  end

end
