require "test_helper"

=begin

  What's being tested here?

    - CRUD: Create, read, update, destroy
    - CRUD Extras: toggle
    - Filters
    - Forms
    - Overrides
    - Permissions
    - Roles
    - Views

=end

class Admin::PostsControllerTest < ActionController::TestCase

  setup do
    @typus_user = Factory(:typus_user)
    @request.session[:typus_user_id] = @typus_user.id
    @post = Factory(:post)
  end

  teardown do
    Post.delete_all
    TypusUser.delete_all
  end

  ##############################################################################
  #
  ##############################################################################

  context "CRUD" do

    should "render index" do
      get :index
      assert_response :success
      assert_template 'index'
    end

    context "new" do

      should "render" do
        get :new
        assert_response :success
        assert_template 'new'
      end

      should "reject params which are not included in @resource.columns.map(&:name)" do
        %w(chunky_bacon).each do |param|
          get :new, {param => param}
          assert_response :success
          assert_template 'new'
        end
      end

    end

    should "create" do
      assert_difference('Post.count') do
        post :create, :post => @post.attributes
        assert_response :redirect
        assert_redirected_to "/admin/posts/edit/#{Post.last.id}"
      end
    end

    should "render show" do
      get :show, :id => @post.id
      assert_response :success
      assert_template 'show'
    end

    should "render edit" do
      get :edit, :id => @post.id
      assert_response :success
      assert_template 'edit'
    end

    should "update" do
      post :update, :id => @post.id, :post => { :title => 'Updated' }
      assert_response :redirect
      assert_redirected_to "/admin/posts/edit/#{@post.id}"
    end

  end

  context "CRUD extras" do

    setup do
      @request.env['HTTP_REFERER'] = "/admin/posts"
    end

    context "toggle" do

      should "work" do
        assert !@post.published
        get :toggle, :id => @post.id, :field => "published"

        assert_response :redirect
        assert_redirected_to @request.env["HTTP_REFERER"]
        assert_equal "Post successfully updated.", flash[:notice]
        assert @post.reload.published
      end

      should "render edit post when validation fails" do
        @post.body = nil
        @post.save(:validate => false)
        get :toggle, :id => @post.id, :field => "published"
        assert_response :success
        assert_template "admin/resources/edit"
      end

    end

  end

  context "Filters" do

    should "render index with accepted params" do
      @post.update_attributes(:published => true)
      get :index, :published => 'true'
      assert_response :success
      assert_template 'index'
      assert assigns(:items).size.eql?(1)

      get :index, :published => 'false'
      assert assigns(:items).size.eql?(0)
    end

    should "render index with accepted params - search" do
      @post.update_attributes(:title => "neinonon")
      get :index, :search => 'neinonon'
      assert_response :success
      assert_template 'index'
      assert assigns(:items).size.eql?(1)

      get :index, :search => 'unexisting'
      assert assigns(:items).size.eql?(0)
    end

    should "render index with non-accepted params" do
      get :index, :non_accepted_param => 'non_accepted_param'
      assert_response :success
      assert_template 'index'
    end

  end

  context "Filters" do

    should "be included in index" do
      get :index
      expected = [["All", "index", "unscoped"]]
      assert_equal expected, assigns(:predefined_filters)
    end

  end

  context "Actions" do

    should "be edit and trash on index" do
      get :index

      expected = [["Edit", {"action"=>"edit"}, {}],
                  ["Trash", {"action"=>"destroy"}, {"method"=>"delete", "confirm"=>"Trash?"}]]

      assert_equal expected, assigns(:resource_actions)
    end

    context "with overriden default action on item" do

      setup do
        Typus::Resources.expects(:default_action_on_item).at_least_once.returns('show')
      end

      should "be show and trash on index" do
        get :index

        expected = [["Show", {"action"=>"show"}, {}],
                    ["Trash", {"action"=>"destroy"}, {"method"=>"delete", "confirm"=>"Trash?"}]]

        assert_equal expected, assigns(:resource_actions)
      end

    end

  end

  context "Forms" do

    setup do
      get :new
    end

    should "verify forms" do
      assert_select "form"
    end

    # We have 3 inputs: 1 hidden which is the UTF8 stuff, one which is the 
    # Post#title and finally the submit button.
    should "have 3 inputs" do
      assert_select "form input", 3

      # Post#title: Input
      assert_select 'label[for="post_title"]'
      assert_select 'input#post_title[type="text"]'
    end

    should "have 1 textarea" do
      assert_select "form textarea", 1

      # Post#body: Text Area
      assert_select 'label[for="post_body"]'
      assert_select 'textarea#post_body'
    end

    should "have 6 selectors" do
      assert_select "form select", 6

      # Post#created_at: Datetime
      assert_select 'label[for="post_created_at"]'
      assert_select 'select#post_created_at_1i'
      assert_select 'select#post_created_at_2i'
      assert_select 'select#post_created_at_3i'
      assert_select 'select#post_created_at_4i'
      assert_select 'select#post_created_at_5i'

      # Post#status: Selector
      assert_select 'label[for="post_status"]'
      assert_select 'select#post_status'
    end

    should "have 1 template" do
      assert_match "templates#datepicker_template_published_at", @response.body
    end

  end

  context "Overwrite action_after_save" do

    setup do
      Typus::Resources.expects(:action_after_save).returns("index")
      @post = Factory(:post)
    end

    should "create an item and redirect to index" do
      assert_difference('Post.count') do
        post :create, :post => @post.attributes
        assert_response :redirect
        assert_redirected_to :action => 'index'
      end
    end

    should "update an item and redirect to index" do
      post :update, :id => @post.id, :post => { :title => 'Updated' }
      assert_response :redirect
      assert_redirected_to :action => 'index'
    end

  end

  context "Formats" do

    should "render index and return xml" do
      get :index, :format => "xml"

      assert_response :success

      assert_match %Q[<?xml version="1.0" encoding="UTF-8"?>], @response.body
      assert_match %Q[<posts type="array">], @response.body
      assert_match "<status>#{@post.status}</status>", @response.body
      assert_match "<title>#{@post.title}</title>", @response.body
    end

    should "render index and return csv" do
      expected = <<-RAW
title;status
#{@post.title};#{@post.status}
       RAW

      get :index, :format => "csv"

      assert_response :success
      assert_equal expected, @response.body
    end

    should "not instantiate resource_actions" do
      get :index, :format => "xml"
      assert assigns(:resource_actions).nil?
    end

    should "not instantiate predefined_filters" do
      get :index, :format => "xml"
      assert assigns(:predefined_filters).nil?
    end

  end

  context "Permissions" do

    context "Root" do

      setup do
        @editor = Factory(:typus_user, :email => "editor@example.com", :role => "editor")
        @post = Factory(:post, :typus_user => @editor)
      end

      should "should list all posts no matter who is the owner" do
        Post.delete_all
        admin = TypusUser.where(:role => 'admin').first
        2.times { Factory(:post, :typus_user => @editor) }
        2.times { Factory(:post, :typus_user => @typus_user) }
        Typus::Resources.expects(:only_user_items).returns(true)

        get :index

        assert_equal 4, Post.count
        assert_equal 4, assigns(:items).size
        assert_equal [@editor.id, @editor.id, @typus_user.id, @typus_user.id], assigns(:items).map(&:typus_user_id)
      end

      should "be able to edit any record" do
        Post.all.each do |post|
          get :edit, :id => post.id
          assert_response :success
          assert_template 'edit'
        end
      end

      should "verify_admin_updating_an_item_does_not_change_typus_user_id_if_not_defined" do
        _post = @post
        post :update, :id => @post.id, :post => { :title => 'Updated by admin' }
        assert_equal _post.typus_user_id, @post.reload.typus_user_id
      end

      should "verify_admin_updating_an_item_does_change_typus_user_id_to_whatever_admin_wants" do
        post :update, :id => @post.id, :post => { :title => 'Updated', :typus_user_id => 108 }
        assert_equal 108, @post.reload.typus_user_id
      end

    end

    context "No root" do

      setup do
        @typus_user = Factory(:typus_user, :email => "editor@example.com", :role => "editor")
        @request.session[:typus_user_id] = @typus_user.id
        @request.env['HTTP_REFERER'] = '/admin/posts'
      end

      should "not be root" do
        assert @typus_user.is_not_root?
      end

      should "verify_editor_can_show_any_record" do
        Post.all.each do |post|
          get :show, :id => post.id
          assert_response :success
          assert_template 'show'
        end
      end

      should "verify_editor_tried_to_edit_a_post_owned_by_himself" do
        get :edit, :id => Factory(:post, :typus_user => @typus_user).id
        assert_response :success
      end

      should "verify_editor_tries_to_edit_a_post_owned_by_the_admin" do
        get :edit, :id => Factory(:post).id
        assert_response :unprocessable_entity
      end

      should "verify_editor_tries_to_show_a_post_owned_by_the_admin" do
        get :show, :id => Factory(:post).id
        assert_response :success
      end

      should "only list editor posts" do
        Post.delete_all
        admin = TypusUser.where(:role => 'admin').first
        2.times { Factory(:post, :typus_user => admin) }
        2.times { Factory(:post, :typus_user => @typus_user) }
        Typus::Resources.expects(:only_user_items).returns(true)

        get :index

        assert_equal 4, Post.count
        assert_equal 2, assigns(:items).size
        assert_equal [@typus_user.id, @typus_user.id], assigns(:items).map(&:typus_user_id)
      end

      should "verify_editor_tries_to_show_a_post_owned_by_the_admin when only user items" do
        Typus::Resources.expects(:only_user_items).returns(true)
        post = Factory(:post)
        get :show, :id => post.id
        assert_response :unprocessable_entity
      end

      should "verify_typus_user_id_of_item_when_creating_record" do
        assert_difference('Post.count') do
          post :create, :post => { :title => "Chunky Bacon", :body => "Lorem ipsum ..." }
        end

        assert_equal @request.session[:typus_user_id], assigns(:item).typus_user_id
      end

      should "verify_editor_updating_an_item_does_not_change_typus_user_id" do
        [ 108, nil ].each do |typus_user_id|
          post_ = Factory(:post, :typus_user => @typus_user)
          post :update, :id => post_.id, :post => { :title => 'Updated', :typus_user_id => @typus_user.id }
          post_updated = Post.find(post_.id)
          assert_equal @request.session[:typus_user_id], post_updated.typus_user_id
        end
      end

    end

  end

  context "Roles" do

    setup do
      @request.env['HTTP_REFERER'] = '/admin/posts'
    end

    context "Admin" do

      should "be able to add posts" do
        assert @typus_user.can?("create", "Post")
      end

      should "be able to destroy posts" do
        get :destroy, :id => Factory(:post).id, :method => :delete

        assert_response :redirect
        assert_equal "Post successfully removed.", flash[:notice]
        assert_redirected_to :action => :index
      end

    end

    context "Designer" do

      setup do
        Typus.user_class.delete_all
        @designer = Factory(:typus_user, :role => "designer")
        @request.session[:typus_user_id] = @designer.id
        @post = Factory(:post)
      end

      should "not be able to add posts" do
        get :new

        assert_response :unprocessable_entity
      end

      should "not be able to destroy posts" do
        assert_no_difference('Post.count') do
          get :destroy, :id => @post.id, :method => :delete
        end
        assert_response :unprocessable_entity
      end

    end

  end

  context "Relationships (relate)" do

    setup do
      @post = Factory(:post)
    end

    should "relate comment to post (has_many)" do
      comment = Factory(:comment, :post => nil)
      @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{@post.id}#comments"

      assert_difference('@post.comments.count') do
        post :relate, { :id => @post.id, :related => { :model => 'Comment', :id => comment.id, :association_name => 'comments' } }
      end

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Post successfully updated.", flash[:notice]
    end

    should "relate category to post (has_and_belongs_to_many)" do
      category = Factory(:category)
      @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{@post.id}#categories"

      assert_difference('category.posts.count') do
        post :relate, { :id => @post.id, :related => { :model => 'Category', :id => category.id, :association_name => 'categories' } }
      end

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Post successfully updated.", flash[:notice]
    end

  end

  context "Views" do

    context "Index" do

      setup do
        get :index
      end

      should "render index and validates_presence_of_custom_partials" do
        assert_match "posts#_index.html.erb", @response.body
      end

      should "render_index_and_verify_page_title" do
        assert_select "title", "Typus &mdash; Posts"
      end

      should "render index_and_show_add_entry_link" do
        assert_select "#sidebar ul" do
          assert_select "li", "Add new"
        end
      end

    end

    context "New" do

      setup do
        get :new
      end

      should "render new and partials_on_new" do
        assert_match "posts#_new.html.erb", @response.body
      end

      should "render new and verify page title" do
        assert_select "title", "Typus &mdash; New Post"
      end

    end

    context "Edit" do

      setup do
        get :edit, :id => Factory(:post).id
      end

      should "render_edit_and_verify_presence_of_custom_partials" do
        assert_match "posts#_edit.html.erb", @response.body
      end

      should "render_edit_and_verify_page_title" do
        assert_select "title", "Typus &mdash; Edit Post"
      end

    end

    context "Show" do

      setup do
        get :show, :id => Factory(:post).id
      end

      should "render_show_and_verify_presence_of_custom_partials" do
        assert_match "posts#_show.html.erb", @response.body
      end

      should "render show and verify page title" do
        assert_select "title", "Typus &mdash; Show Post"
      end

    end

    should "get_index_and_render_edit_or_show_links" do
      %w(edit show).each do |action|
        Typus::Resources.expects(:default_action_on_item).at_least_once.returns(action)
        get :index
        Post.all.each do |post|
          assert_match "/posts/#{action}/#{post.id}", @response.body
        end
      end
    end

    context "Designer" do

      setup do
        @typus_user = Factory(:typus_user, :email => "designer@example.com", :role => "designer")
        @request.session[:typus_user_id] = @typus_user.id
      end

      should "render_index_and_not_show_add_entry_link" do
        get :index
        assert_response :success
        assert_no_match /Add Post/, @response.body
      end

    end

    context "Editor" do

      setup do
        @typus_user = Factory(:typus_user, :email => "editor@example.com", :role => "editor")
        @request.session[:typus_user_id] = @typus_user.id
      end

=begin

      ##
      # This feature is no longer available. I've to decide if I want to take
      # it back.
      #
      should "get_index_and_render_edit_or_show_links_on_owned_records" do
        get :index
        Post.all.each do |post|
          action = post.owned_by?(@typus_user) ? "edit" : "show"
          assert_match "/posts/#{action}/#{post.id}", @response.body
        end
      end

=end

      should "get_index_and_render_edit_or_show_on_only_user_items" do
        %w(edit show).each do |action|
          Typus::Resources.stubs(:only_user_items).returns(true)
          Typus::Resources.stubs(:default_action_on_item).returns(action)
          get :index
          Post.all.each do |post|
            if @typus_user.owns?(post)
              assert_match "/posts/#{action}/#{post.id}", @response.body
            else
              assert_no_match /\/posts\/#{action}\/#{post.id}/, @response.body
            end
          end
        end
      end

    end

  end

  ##
  # We are in a View and we want to create a new Post from there to be able
  # to assign it. There are two cases:
  #
  # - We are creating the view.
  # - We are editing the view.
  #
  context "create_with_back_to" do

    setup do
      @post = { :title => 'This is another title', :body => 'Body' }
    end

    context "when creating an item" do

      ##
      # We click on the "Add new" link and we are redirected to:
      #
      #     /admin/posts/new
      #
      # With a collection of params which will be used to create the
      # association if everything works as expected.
      #
      # Once the association is created we are redirected back to where we
      # started with a param which selects the Post on the View form.
      #
      #     /admin/views/new?post_id=1
      #
      # So we end up having a new Post and if we save the form will be
      # assigned to the view.
      #

      should "create new post and redirect to view" do
        assert_difference('Post.count') do
          post :create, { :post => @post,
                          :resource => "View" }
        end
        assert_response :redirect
        assert_redirected_to "/admin/views/new?post_id=#{Post.last.id}"
      end

    end

    context "when editing an item" do

      ##
      # We click on the "Add new" link and we are redirected to:
      #
      #     /admin/posts/new
      #
      # The important thing here is that we are passing the `resource_id`
      # because we will assign the newly created Post to the View.
      #
      # So we will end up having a new Post assigned to the View.
      #

      setup do
        @view = Factory(:view, :post => nil)
      end

      should "create new post and redirect to view" do
        assert_difference('Post.count') do
          post :create, { :post => @post, :resource => "View", :resource_id => @view.id }
        end
        assert_response :redirect
        assert_redirected_to "/admin/views/edit/#{@view.id}"

        # Make sure the association is created!
        assert @view.reload.post
      end

    end

  end

  context "autocomplete" do

    setup do
      25.times { Factory(:post) }
    end

    should "work and return a json hash with ten items" do
      get :autocomplete, { :term => "Post" }
      assert_response :success
      assert_equal 20, assigns(:items).size
    end

    should "work and return json hash with one item" do
      post = Post.first
      post.update_attributes(:title => "fesplugas")

      get :autocomplete, { :term => "jmeiss" }
      assert_response :success
      assert_equal 0, assigns(:items).size

      get :autocomplete, { :term => "fesplugas" }
      assert_response :success
      assert_equal 1, assigns(:items).size
    end

  end

end
