# -*- encoding: utf-8 -*-

require "test_helper"

class Admin::FiltersHelperTest < ActiveSupport::TestCase

  include Admin::FiltersHelper

  def render(*args); args; end

  context "build_filters" do

    # FIXME: Should work without this ...
    setup do
      @resource = Entry
      @expected = ["admin/helpers/filters/filters",
                  {:filters=>[{:filter=>"published",
                               :items=>[["Show by published", ""], ["Yes", "true"], ["No", "false"]]}],
                   :hidden_filters=>{}}]
    end

    should "reject controller and action params" do
      parameters = {"controller"=>"admin/posts", "action"=>"index"}
      assert_equal @expected, build_filters(Entry, parameters)
    end

    # TODO: I want to think about it ...
    should "reject locale params" do
      parameters = {"locale"=>"jp"}
      assert_equal @expected, build_filters(Entry, parameters)
    end

    # TODO: I want to think about it ...
    should "reject to sort_order and order_by" do
      parameters = {"sort_order"=>"asc", "order_by"=>"title"}
      assert_equal @expected, build_filters(Entry, parameters)
    end

    should "reject the utf8 param because the form already contains it" do
      parameters = {"utf8"=>"✓"}
      assert_equal @expected, build_filters(Entry, parameters)
    end

    should "not reject the search param" do
      parameters = {"search"=>"Chunky Bacon"}

      expected = ["admin/helpers/filters/filters",
                 {:filters=>[{:filter=>"published",
                              :items=>[["Show by published", ""], ["Yes", "true"], ["No", "false"]]}],
                  :hidden_filters=>{"search"=>"Chunky Bacon"}}]

      assert_equal expected, build_filters(Entry, parameters)
    end

    should "not reject applied filters" do
      parameters = {"user_id"=>"1"}

      expected = ["admin/helpers/filters/filters",
                 {:filters=>[{:filter=>"published",
                              :items=>[["Show by published", ""], ["Yes", "true"], ["No", "false"]]}],
                  :hidden_filters=>{"user_id"=>"1"}}]

      assert_equal expected, build_filters(Entry, parameters)
    end

    should "reject applied filter" do
      parameters = {"published"=>"true"}

      expected = ["admin/helpers/filters/filters",
                 {:filters=>[{:filter=>"published",
                              :items=>[["Show by published", ""], ["Yes", "true"], ["No", "false"]]}],
                  :hidden_filters=>{}}]

      assert_equal expected, build_filters(Entry, parameters)
    end

  end

  should "relationship_filter"

  context "date_filter" do

    should "return an array" do
      output = date_filter("filter")
      expected = [["Show all dates", ""],
                  ["Today", "today"],
                  ["Last few days", "last_few_days"],
                  ["Last 7 days", "last_7_days"],
                  ["Last 30 days", "last_30_days"]]
      assert_equal expected, output
    end

  end

  context "boolean_filter" do

    setup do
      @resource = Post
    end

    should "return an array" do
      output = boolean_filter("filter")
      expected = [["Show by filter", ""],
                  ["True", "true"],
                  ["False", "false"]]
      assert_equal expected, output
    end

  end

  context "string_filter" do

    setup do
      @resource = Post
    end

    should "return an array from status which is a Hash" do
      output = string_filter("status")
      expected = [["Show by status", ""],
                  ["Unpublished", "unpublished"],
                  ["<div class=''>Something special</div>", "special"],
                  ["Draft", "draft"],
                  ["Published", "published"]]

      expected.each { |e| assert output.include?(e) }
    end

    should "return an array from an ARRAY_SELECTOR" do
      output = string_filter("array_selector")
      expected = [["Show by array selector", ""],
                  ["item1", "item1"],
                  ["item2", "item2"]]
      assert_equal expected, output
    end

    should "return an array from an ARRAY_HASH_SELECTOR" do
      output = string_filter("array_hash_selector")
      expected = [["Show by array hash selector", ""],
                  ["Draft", "draft"],
                  ["Custom Status", "custom"]]
      assert_equal expected, output
    end

  end

  context "predefined_filters" do

    should "be empty" do
      assert predefined_filters.empty?
    end

    should "return my filter" do
      @predefined_filters = "mock"
      assert_equal "mock", predefined_filters
    end

  end

  def link_to(*args); args; end

end
