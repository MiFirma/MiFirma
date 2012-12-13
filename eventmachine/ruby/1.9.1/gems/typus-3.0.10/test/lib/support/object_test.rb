require "test_helper"

class ObjectTest < ActiveSupport::TestCase

  context "is_sti?" do

    should "return false" do
      assert !Entry.is_sti?
    end

    should "return true" do
      assert Case.is_sti?
    end

  end

end
