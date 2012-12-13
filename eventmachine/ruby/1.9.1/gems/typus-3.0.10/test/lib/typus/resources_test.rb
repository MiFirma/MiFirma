require "test_helper"

class ResourcesTest < ActiveSupport::TestCase

  should "return action_after_save" do
    assert_equal "edit", Typus::Resources.action_after_save
  end

  should "return default_action_on_item" do
    assert_equal "edit", Typus::Resources.default_action_on_item
  end

  should "return end_year" do
    assert_nil Typus::Resources.end_year
  end

  should "return form_rows" do
    assert_equal 15, Typus::Resources.form_rows
  end

  should "return minute_step" do
    assert_equal 5, Typus::Resources.minute_step
  end

  should "return only_user_items" do
    assert !Typus::Resources.only_user_items
  end

  should "return per_page" do
    assert_equal 15, Typus::Resources.per_page
  end

  should "return sortable" do
    assert Typus::Resources.sortable
  end

  should "return start_year" do
    assert_nil Typus::Resources.start_year
  end

end
