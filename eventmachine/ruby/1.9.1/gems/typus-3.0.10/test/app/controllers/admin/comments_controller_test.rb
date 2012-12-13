require "test_helper"

=begin

  What's being tested here?

    - Unrelate "Comment" from "Post" (Post#comments)
    - Search by "Posts.title" (Post#comments)

=end

class Admin::CommentsControllerTest < ActionController::TestCase

  setup do
    @request.session[:typus_user_id] = Factory(:typus_user).id
    @request.env['HTTP_REFERER'] = '/admin/categories'
  end

  context "Unrelate" do

    ##
    # We are in:
    #
    #   /admin/posts/edit/1
    #
    # And we see a list of comments under it:
    #
    #   /admin/comments/unrelate/1?resource=Post&resource_id=1
    #   /admin/comments/unrelate/2?resource=Post&resource_id=1
    #
    # Notice that unrelating an item doesn't remove it from database unless
    # defined on the model.
    #
    ##

    should "unrelate comment from post" do
      comment = Factory(:comment)
      @post = comment.post

      assert_difference('@post.comments.count', -1) do
        post :unrelate, :id => comment.id, :resource => 'Post', :resource_id => @post.id
      end

      assert comment.reload.post.nil?

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Post successfully updated.", flash[:notice]
    end

  end

  context "Search" do

    ##
    # We are in:
    #
    #   /admin/posts
    #
    # And we can search by "posts.title" because "Comment" is belongs_to :post
    #
    #
    ##

    should "search in Posts.title from Comments list" do
      post_1 = Factory(:post, :title => "A title with_keyword")
      comment_1 = Factory(:comment, :post => post_1)

      post_2 = Factory(:post, :title => "A title without_keyword")
      comment_2 = Factory(:comment, :post => post_2)

      post :index, {:search => "with_keyword" }
      assert_equal [comment_1], assigns(:items)
      assert_not_equal [comment_2], assigns(:items)
    end

  end

end
