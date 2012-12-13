require "test_helper"

class Admin::FormHelperTest < ActiveSupport::TestCase

  include Admin::FormHelper
  include Admin::ResourcesHelper

  should_eventually "verify_belongs_to_field" do

    params = { :controller => '/admin/post', :id => 1, :action => :create }
    self.stubs(:params).returns(params)

    admin_user = mock
    admin_user.stubs(:can?).with('create', Post).returns(false)
    @resource = Comment

    expected = <<-HTML
<li><label for="comment_post">Post
    <small></small>
    </label>
<select id="comment_post_id" name="comment[post_id]"><option value=""></option>
<option value="3">Post#3</option>
<option value="4">Post#4</option>
<option value="1">Post#1</option>
<option value="2">Post#2</option></select></li>
    HTML

    assert_equal expected, typus_belongs_to_field('post')

  end

  should_eventually "test_typus_belongs_to_field_with_different_attribute_name" do

    params = { :controller => '/admin/post', :id => 1, :action => :edit }
    self.stubs(:params).returns(params)

    admin_user = mock
    admin_user.stubs(:can?).with('create', Comment).returns(true)
    @resource = Post

    expected = <<-HTML
<li><label for="post_favorite_comment">Favorite comment
    <small><a href="http://test.host/admin/comments/new?back_to=%2Fadmin%2Fpost%2Fedit%2F1&selected=favorite_comment_id" onclick="return confirm('Are you sure you want to leave this page?\\n\\nIf you have made any changes to the fields without clicking the Save/Update entry button, your changes will be lost.\\n\\nClick OK to continue, or click Cancel to stay on this page.');">Add</a></small>
    </label>
<select id="post_favorite_comment_id" name="post[favorite_comment_id]"><option value=""></option>
<option value="1">John</option>
<option value="2">Me</option>
<option value="3">John</option>
<option value="4">Me</option></select></li>
    HTML

    assert_equal expected, typus_belongs_to_field('favorite_comment')

  end

  should_eventually "test_typus_tree_field" do

    self.stubs(:expand_tree_into_select_field).returns('expand_tree_into_select_field')

    @resource = Page

    expected = <<-HTML
<li><label for="page_parent">Parent</label>
<select id="page_parent"  name="page[parent]">
  <option value=""></option>
  expand_tree_into_select_field
</select></li>
    HTML

    assert_equal expected, typus_tree_field('parent')

  end

  context "attribute_disabled?" do

    setup do
      @resource = Post
    end

    should "work for non protected_attributes" do
      assert !attribute_disabled?('test')
    end

    should "work for protected_attributes" do
      Post.expects(:protected_attributes).returns(['test'])
      assert attribute_disabled?('test')
    end

  end

  context "expand_tree_into_select_field" do

    setup do
      @page = Factory(:page)
      @children = Factory(:page, :parent => @page)
      @subchildren = Factory(:page, :parent => @children)
      @items = Page.roots
    end

    should "verify it works" do
      @item = Page.first

      expected = <<-HTML
<option  value="#{@page.id}"> #{@page.to_label}</option>
<option  value="#{@children.id}">&nbsp;&nbsp; #{@children.to_label}</option>
<option  value="#{@subchildren.id}">&nbsp;&nbsp;&nbsp;&nbsp; #{@subchildren.to_label}</option>
      HTML

      assert_equal expected, expand_tree_into_select_field(@items, 'parent_id')
    end

    should "verify if selects an item" do
      @item = Page.last

      expected = <<-HTML
<option  value="#{@page.id}"> #{@page.to_label}</option>
<option selected value="#{@children.id}">&nbsp;&nbsp; #{@children.to_label}</option>
<option  value="#{@subchildren.id}">&nbsp;&nbsp;&nbsp;&nbsp; #{@subchildren.to_label}</option>
      HTML

      assert_equal expected, expand_tree_into_select_field(@items, 'parent_id')
    end

  end

end
