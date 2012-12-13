require "test_helper"

class FakeController
  attr_accessor :request

  def config
    @config ||= ActiveSupport::InheritableOptions.new(ActionController::Base.config)
  end
end

class Admin::TableHelperTest < ActiveSupport::TestCase

  include Admin::TableHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::RawOutputHelper

  include ActionView::Context

  include Rails.application.routes.url_helpers

  def render(*args); args; end
  def params; {} end
  def admin_user; end

  setup do
    default_url_options[:host] = "test.host"
    self.stubs(:controller).returns(FakeController.new)
  end

  context "table_header" do

    should "work" do
      params = { :controller => "/admin/typus_users", :action => "index" }
      fields = TypusUser.typus_fields_for(:list)

      expected = [ %(<a href="/admin/typus_users?order_by=email">Email</a>),
                   %(<a href="/admin/typus_users?order_by=role">Role</a>),
                   %(<a href="/admin/typus_users?order_by=status">Status</a>) ]

      assert_equal expected, table_header(TypusUser, fields, params)
    end

    should "work with params" do
      params = { :controller => "/admin/typus_users", :action => "index", :search => "admin" }
      fields = TypusUser.typus_fields_for(:list)

      expected = [ %(<a href="/admin/typus_users?order_by=email&amp;search=admin">Email</a>),
                   %(<a href="/admin/typus_users?order_by=role&amp;search=admin">Role</a>),
                   %(<a href="/admin/typus_users?order_by=status&amp;search=admin">Status</a>) ]

      assert_equal expected, table_header(TypusUser, fields, params)
    end

  end

  context "resource_actions" do

    should "return a default value which is an empty array" do
      assert resource_actions.empty?
    end

    should "return a predefined value" do
      @resource_actions = "mock"
      assert_equal "mock", resource_actions
    end

  end

  context "table_belongs_to_field" do

    should "work without associated model" do
      comment = Factory(:comment, :post => nil)
      assert_equal "&mdash;", table_belongs_to_field("post", comment)
    end

    should "work with associated model when user has access" do
      admin_user.expects(:can?).returns(true)
      comment = Factory(:comment)
      post = comment.post
      assert_equal %(<a href="/admin/posts/edit/#{post.id}">#{post.to_label}</a>), table_belongs_to_field("post", comment)
    end

    should "work with associated model when user does not have access" do
      admin_user.expects(:can?).returns(false)
      comment = Factory(:comment)
      post = comment.post
      assert_equal post.to_label, table_belongs_to_field("post", comment)
    end

  end

  should "test_table_has_and_belongs_to_many_field" do
    post = Factory(:post)
    post.comments << Factory(:comment, :name => "John")
    post.comments << Factory(:comment, :name => "Jack")
    assert_equal "John, Jack", table_has_and_belongs_to_many_field("comments", post)
  end

  context "table_string_field" do

    should "work" do
      post = Factory(:post)
      assert_equal post.title, table_string_field(:title, post)
    end

    should "work when attribute is empty" do
      post = Factory(:post)
      post.title = ""
      assert_equal "&mdash;", table_string_field(:title, post)
    end

  end

  context "table_integer_field" do

    should "work" do
      post = Factory(:post)
      assert_equal post.id, table_integer_field(:id, post)
    end

    should "work when attribute is empty" do
      post = Factory(:post)
      post.id = nil
      assert_equal "&mdash;", table_integer_field(:id, post)
    end

  end

  context "table_tree_field" do

    should "work when no parent" do
      page = Factory(:page)
      assert_equal "&mdash;", table_tree_field("title", page)
    end

    should "work when parent" do
      parent = Factory(:page)
      page = Factory(:page, :parent => parent)
      assert_equal parent.to_label, table_tree_field("title", page)
    end

  end

  should "test_table_datetime_field" do
    post = Factory(:post)
    assert_equal post.created_at.strftime("%d %b %H:%M"), table_datetime_field(:created_at, post)
  end

  context "table_boolean_field" do

    should "work when default status is true" do
      post = Factory(:typus_user)
      expected = %(<a href="/admin/typus_users/toggle/#{post.id}?field=status" data-confirm="Change status?">Active</a>)
      assert_equal expected, table_boolean_field("status", post)
    end

    should "work when default status is false" do
      post = Factory(:typus_user, :status => false)
      expected = %(<a href="/admin/typus_users/toggle/#{post.id}?field=status" data-confirm="Change status?">Inactive</a>)
      assert_equal expected, table_boolean_field("status", post)
    end

    should "work when default status is nil" do
      post = Factory(:typus_user, :status => nil)
      assert post.status.nil?
      expected = %(<a href="/admin/typus_users/toggle/#{post.id}?field=status" data-confirm="Change status?">Inactive</a>)
      assert_equal expected, table_boolean_field("status", post)
    end

  end

  context "table_transversal_field" do

    should "work" do
      comment = Factory(:comment)
      output = table_transversal_field("post.title", comment)
      expected = comment.post.title
      assert_equal expected, output
    end

    should "return a dash if the association does not exist" do
      comment = Factory(:comment, :post => nil)
      assert_equal "&mdash;", table_transversal_field("post.title", comment)
    end

  end

  should "test_table_position_field" do
    first_category = Factory(:category, :position => 0)
    second_category = Factory(:category, :position => 1)
    last_category = Factory(:category, :position => 2)

    output = table_position_field(nil, first_category)
    expected = <<-HTML
1<br/><br/><a href="/admin/categories/position/#{first_category.id}?go=move_lower">Down</a> / <a href="/admin/categories/position/#{first_category.id}?go=move_to_bottom">Bottom</a>
    HTML
    assert_equal expected.strip, output

    output = table_position_field(nil, second_category)
    expected = <<-HTML
2<br/><br/><a href="/admin/categories/position/#{second_category.id}?go=move_to_top">Top</a> / <a href="/admin/categories/position/#{second_category.id}?go=move_higher">Up</a> / <a href="/admin/categories/position/#{second_category.id}?go=move_lower">Down</a> / <a href="/admin/categories/position/#{second_category.id}?go=move_to_bottom">Bottom</a>
    HTML
    assert_equal expected.strip, output

    output = table_position_field(nil, last_category)
    expected = <<-HTML
3<br/><br/><a href="/admin/categories/position/#{last_category.id}?go=move_to_top">Top</a> / <a href="/admin/categories/position/#{last_category.id}?go=move_higher">Up</a>
    HTML
    assert_equal expected.strip, output
  end

end
