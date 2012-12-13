require "test_helper"

class Admin::DashboardHelperTest < ActiveSupport::TestCase

  include Admin::DashboardHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper

  def render(*args); args; end

  context "resources" do

    setup do
      @expected = ["admin/helpers/dashboard/resources", { :resources => ["Git", "Status", "WatchDog"] }]
    end

    should "work for typus_user" do
      admin_user = Factory(:typus_user)
      output = resources(admin_user)
      assert_equal @expected, output
    end

    should "work for fake_user" do
      admin_user = FakeUser.new
      output = resources(admin_user)
      assert_equal @expected, output
    end

  end

end
