require "test_helper"

class FakeUserTest < ActiveSupport::TestCase

  setup do
    @fake_user = FakeUser.new
  end

  should "have the id set to 0" do
    assert_equal 0, @fake_user.id
  end

  should "be able to do anything" do
    assert @fake_user.can?("sing")
    assert !@fake_user.cannot?("sing")
  end

  should "have a locale" do
    assert_equal ::I18n.locale, @fake_user.locale
  end

  should "have status set to true" do
    assert @fake_user.status
  end

  should "be considered as root" do
    assert @fake_user.is_root?
  end

  should "not be considered as no_root" do
    assert !@fake_user.is_not_root?
  end

  should "have access to all applications" do
    assert_equal Typus.applications, @fake_user.applications
  end

  context "application" do

    should "have access to all applications filtered" do
      assert_equal Typus.application("CRUD"), @fake_user.application("CRUD")
    end

    should "make sure I get what I want" do
      expected = ["Animal", "Bird", "Dog", "ImageHolder"]
      assert_equal expected, @fake_user.application("Polymorphic")
    end

  end

  should "be master_role" do
    assert_equal Typus.master_role, @fake_user.role
  end

  should "not respond to resources" do
    assert !@fake_user.respond_to?(:resources)
  end

  should "always be the owner of a resource" do
    assert @fake_user.owns?('a')
  end

end
