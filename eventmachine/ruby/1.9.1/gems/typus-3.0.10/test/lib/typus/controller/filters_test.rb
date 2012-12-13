require "test_helper"

class FiltersTest < ActiveSupport::TestCase

  include Typus::Controller::Filters

  context "add_predefined_filter" do

    should "work without args" do
      add_predefined_filter()
      assert @predefined_filters.empty?
    end

    should "work with args" do
      add_predefined_filter("something")
      assert_equal [["something"]], @predefined_filters
    end

  end

  context "prepend_predefined_filter" do

    should "work without args" do
      prepend_predefined_filter()
      assert @predefined_filters.empty?
    end

    should "work with args" do
      prepend_predefined_filter("something")
      assert_equal [["something"]], @predefined_filters
    end

    should "work prepending an action without args" do
      add_predefined_filter("something")
      prepend_predefined_filter()
      assert_equal [["something"]], @predefined_filters
    end

    should "work prepending an action with args" do
      add_predefined_filter("something")
      prepend_predefined_filter("something_else")
      assert_equal [["something_else"], ["something"]], @predefined_filters
    end

  end

  context "append_predefined_filter" do

    should "work without args" do
      append_predefined_filter()
      assert @predefined_filters.empty?
    end

    should "work with args" do
      append_predefined_filter("something")
      assert_equal [["something"]], @predefined_filters
    end

    should "work appending an action without args" do
      add_predefined_filter("something")
      append_predefined_filter()
      assert_equal [["something"]], @predefined_filters
    end

    should "work appending an action with args" do
      add_predefined_filter("something")
      append_predefined_filter("something_else")
      assert_equal [["something"], ["something_else"]], @predefined_filters
    end

  end

end
