require "test_helper"

class Admin::ResourcesHelperTest < ActiveSupport::TestCase

  include Admin::ResourcesHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper

  def render(*args); args; end

  context "display_link_to_previous" do

    setup do
      @resource = Comment
    end

    should "set an url to new when not resource_id is passed" do
      params = { :resource => "Post" }

      expected = ["admin/helpers/resources/display_link_to_previous",
                  {:body=>"Cancel adding a new comment?", :url=>{:controller=>"posts", :action => 'new'}}]

      assert_equal expected, display_link_to_previous(params)
    end

    should "set an url to edit when resource_id is passed" do
      @post = Factory(:post)
      params = { :resource => "Post", :resource_id => @post.id }

      expected = ["admin/helpers/resources/display_link_to_previous",
                  {:body=>"Cancel adding a new comment?", :url=>{:controller=>"posts", :action => 'edit', :id => @post.id}}]

      assert_equal expected, display_link_to_previous(params)
    end

    should "return nil if no resource is passed" do
      params = { :action => "edit" }
      self.expects(:params).at_least_once.returns(params)

      assert_nil display_link_to_previous
    end

  end

end
