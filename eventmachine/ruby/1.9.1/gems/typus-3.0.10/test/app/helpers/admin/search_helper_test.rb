# -*- encoding: utf-8 -*-

require "test_helper"

class Admin::SearchHelperTest < ActiveSupport::TestCase

  include Admin::SearchHelper

  def render(*args); args; end

  context "search" do

    should "reject controller and action params" do
      parameters = {"controller"=>"admin/posts", "action"=>"index"}
      expected = ["admin/helpers/search/search", {:hidden_filters => {}}]
      assert_equal expected, search(Entry, parameters)
    end

    # Why do you need the pagination page for a new search?
    should "reject the page param" do
      parameters = {"page"=>"1"}
      expected = ["admin/helpers/search/search", {:hidden_filters => {}}]
      assert_equal expected, search(Entry, parameters)
    end

    # TODO: I want to think about it ...
    should "reject locale params" do
      parameters = {"locale"=>"jp"}
      expected = ["admin/helpers/search/search", {:hidden_filters => {}}]
      assert_equal expected, search(Entry, parameters)
    end

    # TODO: I want to think about it ...
    should "reject to sort_order and order_by" do
      parameters = {"sort_order"=>"asc", "order_by"=>"title"}
      expected = ["admin/helpers/search/search", {:hidden_filters => {}}]
      assert_equal expected, search(Entry, parameters)
    end

    should "reject the utf8 param because the form already contains it" do
      parameters = {"utf8"=>"✓"}
      expected = ["admin/helpers/search/search", {:hidden_filters => {}}]
      assert_equal expected, search(Entry, parameters)
    end

    should "reject the search param because the form already contains it" do
      parameters = {"search"=>"Chunky Bacon"}
      expected = ["admin/helpers/search/search", {:hidden_filters => {}}]
      assert_equal expected, search(Entry, parameters)
    end

    should "not reject applied filters" do
      parameters = {"published"=>"true", "user_id"=>"1"}
      expected = ["admin/helpers/search/search", {:hidden_filters=>{"published"=>"true", "user_id"=>"1"}}]
      assert_equal expected, search(Entry, parameters)
    end

  end

end
