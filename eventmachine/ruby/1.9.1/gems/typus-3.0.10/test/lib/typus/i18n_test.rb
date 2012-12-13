require "test_helper"

class I18nTest < ActiveSupport::TestCase

  should "work" do
    assert_equal "Missing Translation", Typus::I18n.t("Missing Translation")
  end

end
