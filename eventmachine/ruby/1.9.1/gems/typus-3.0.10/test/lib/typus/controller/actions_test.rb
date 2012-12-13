require "test_helper"

class ActionsTest < ActiveSupport::TestCase

  include Typus::Controller::Actions

  context "add_resource_action" do

    should "work" do
      output = add_resource_action("something")
      assert_equal [["something"]], @resource_actions
    end

    should "work when no params are set" do
      add_resource_action()
      assert @resource_actions.empty?
    end

  end

  context "prepend_resource_action" do

    should "work without args" do
      prepend_resource_action()
      assert @resource_actions.empty?
    end

    should "work with args" do
      prepend_resource_action("something")
      assert_equal [["something"]], @resource_actions
    end

    should "work prepending an action without args" do
      add_resource_action("something")
      prepend_resource_action()
      assert_equal [["something"]], @resource_actions
    end

    should "work prepending an action with args" do
      add_resource_action("something")
      prepend_resource_action("something_else")
      assert_equal [["something_else"], ["something"]], @resource_actions
    end

  end

  context "append_resource_action" do

    should "work without args" do
      append_resource_action()
      assert @resource_actions.empty?
    end

    should "work with args" do
      append_resource_action("something")
      assert_equal [["something"]], @resource_actions
    end

    should "work appending an action without args" do
      add_resource_action("something")
      append_resource_action()
      assert_equal [["something"]], @resource_actions
    end

    should "work appending an action with args" do
      add_resource_action("something")
      append_resource_action("something_else")
      assert_equal [["something"], ["something_else"]], @resource_actions
    end

  end

  # FIXME: Cleanup all test after this line.

  context "add_resources_action" do

    should "work" do
      add_resources_action("something")
      assert_equal [["something"]], @resources_actions
    end

    should "work when no params are set" do
      add_resources_action()
      assert @resources_actions.empty?
    end

  end

  context "prepend_resources_action" do

    should "work without args" do
      prepend_resources_action()
      assert @resources_actions.empty?
    end

    should "work with args" do
      prepend_resources_action("something")
      assert_equal [["something"]], @resources_actions
    end

    should "work prepending an action without args" do
      add_resources_action("something")
      prepend_resources_action()
      assert_equal [["something"]], @resources_actions
    end

    should "work prepending an action with args" do
      add_resources_action("something")
      prepend_resources_action("something_else")
      assert_equal [["something_else"], ["something"]], @resources_actions
    end

  end

  context "append_resources_action" do

    should "work without args" do
      append_resources_action()
      assert @resources_actions.empty?
    end

    should "work with args" do
      append_resources_action("something")
      assert_equal [["something"]], @resources_actions
    end

    should "work appending an action without args" do
      add_resources_action("something")
      append_resources_action()
      assert_equal [["something"]], @resources_actions
    end

    should "work appending an action with args" do
      add_resources_action("something")
      append_resources_action("something_else")
      assert_equal [["something"], ["something_else"]], @resources_actions
    end

  end

end
