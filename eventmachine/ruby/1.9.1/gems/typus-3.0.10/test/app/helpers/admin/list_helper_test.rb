require "test_helper"

class Admin::ListHelperTest < ActiveSupport::TestCase

  include Admin::ListHelper

  def render(*args); args; end

  context "resources_actions" do

    should "return a default value which is an empty array" do
      assert resources_actions.empty?
    end

    should "return a predefined value" do
      @resources_actions = "mock"
      assert_equal "mock", resources_actions
    end

  end

  context "list_actions" do

    should "be empty" do
      assert list_actions.empty?
    end

    should "not include actions that a role cannot perform" do
      @resource = mock
      @resource.stubs(:name).returns("resource")

      self.stubs(:link_to).returns("some_link")
      sample_action = ["a body", {:action => :some_action}, {}]
      self.stubs(:resources_actions).returns([sample_action] * 3)

      admin_user = mock
      admin_user.stubs(:can?).returns(true, false, true)
      self.stubs(:admin_user).returns(admin_user)
      self.stubs(:params).returns({:action => 'some_other_action'})

      results = list_actions.split("/")
      assert_equal 2, results.size
    end

    should_eventually "return an array with our custom actions"

  end

  context "build_list" do

    setup do
      @model = TypusUser
      @fields = %w( email role status )
      @items = TypusUser.all
      @resource = "typus_users"
    end

    should "return a table" do
      expected = [ "admin/typus_users/list", { :items => [] } ]
      output = build_list(@model, @fields, @items, @resource)
      assert_equal expected, output
    end

    should "return a template" do
      self.stubs(:render).returns("a_template")
      File.stubs(:exist?).returns(true)

      expected = "a_template"
      output = build_list(@model, @fields, @items, @resource)

      assert_equal expected, output
    end

  end

end
