require "test_helper"

=begin

  What's being tested here?

    - ActsAsList.
    - Template Override (TODO: Centralize this!!!)
    - Unrelate (Post#categories) (has_and_belongs_to_many)

=end

class Admin::CategoriesControllerTest < ActionController::TestCase

  setup do
    @request.session[:typus_user_id] = Factory(:typus_user).id
    @request.env['HTTP_REFERER'] = '/admin/categories'
  end

  context "Categories Views" do

    should_eventually "verify form partial can overrided by model" do
      get :new
      assert_match "categories#_form.html.erb", @response.body
    end

  end

  context "Categories List" do

    setup do
      @first_category = Factory(:category, :position => 1)
      @second_category = Factory(:category, :position => 2)

      @second_category.name = nil
      @second_category.save(:validate => false)
    end

    should "verify referer" do
      get :position, { :id => @first_category.id, :go => 'move_lower' }
      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
    end

    should "position item one step down" do
      get :position, { :id => @first_category.id, :go => 'move_lower' }
      assert_equal "Category successfully updated.", flash[:notice]
      assert_equal 2, assigns(:item).position
    end

    should "position item one step up" do
      get :position, { :id => @second_category.id, :go => 'move_higher' }
      assert_equal 1, assigns(:item).position
    end

    should "position top item to bottom" do
      get :position, { :id => @first_category.id, :go => 'move_to_bottom' }
      assert_equal 2, assigns(:item).position
    end

    should "position bottom item to top" do
      get :position, { :id => @second_category.id, :go => 'move_to_top' }
      assert_equal 1, assigns(:item).position
    end

  end

  context "Unrelate (has_and_belongs_to_many)" do

    ##
    # We are in:
    #
    #   /admin/posts/edit/1
    #
    # And we see a list of comments under it:
    #
    #   /admin/categories/unrelate/1?resource=Post&resource_id=1
    #   /admin/categories/unrelate/2?resource=Post&resource_id=1
    ##

    setup do
      @category = Factory(:category)
      @category.posts << Factory(:post)
      @request.env['HTTP_REFERER'] = "/admin/dashboard"
    end

    should "unrelate category from post" do
      assert_difference('@category.posts.count', -1) do
        post :unrelate, :id => @category.id, :resource => 'Post', :resource_id => @category.posts.first
      end

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Post successfully updated.", flash[:notice]
    end

  end

  ##
  # Basically we verify Admin::ResourcesController#create_with_back_to works
  # as expected for STI models.
  #
  # We are editing a Case (which is an STI model). And we click on "Add New"
  # to add a new category. Once create, we will be redirected and the new
  # category will be assigned to the current case. Easy right?
  #
  #   /admin/categories/new?back_to=%2Fadmin%2Fcases%2Fedit%1F2&resource=Case&resource_id=2
  #
  context "Relate using Add New on STI models" do

    setup do
      @category = { :name => "Category Name" }
    end

    context "when editing an item" do

      setup do
        @case = Factory(:case)
      end

      should "create new category and redirect to case" do
        assert_difference('@case.categories.count') do
          post :create, { :category => @category,
                          :resource => "Case", :resource_id => @case.id }
        end
        assert_response :redirect
        assert_redirected_to "/admin/cases/edit/#{@case.id}"
      end

    end

  end

end
