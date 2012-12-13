require "test_helper"

class TypusUserTest < ActiveSupport::TestCase

  [ %Q(this_is_chelm@example.com\n<script>location.href="http://spammersite.com"</script>),
    'admin',
    'TEST@EXAMPLE.COM',
    'test@example',
    'test@example.c',
    'testexample.com' ].each do |value|
    should "not allow #{value}" do
      assert !Factory.build(:typus_user, :email => value).valid?
    end
  end

  [ 'test+filter@example.com',
    'test.filter@example.com',
    'test@example.co.uk',
    'test@example.es' ].each do |value|
    should "allow #{value}" do
      assert Factory.build(:typus_user, :email => value).valid?
    end
  end

  should "validate_presence_of :email" do
    assert !Factory.build(:typus_user, :email => nil).valid?
  end

  should "validate_presence_of :role" do
    assert !Factory.build(:typus_user, :role => nil).valid?
  end

  should "validate password length" do
    assert !Factory.build(:typus_user, :password => "0"*5).valid?, "5"
    assert Factory.build(:typus_user, :password => "0"*6).valid?, "6"
    assert Factory.build(:typus_user, :password => "0"*40).valid?, "40"
    assert !Factory.build(:typus_user, :password => "0"*41).valid?, "41"
  end

  should "not allow_mass_assignment_of :status" do
    assert TypusUser.attr_protected.include?("status")
  end

  should "verify columns" do
    expected = %w(id first_name last_name email role status salt crypted_password token preferences created_at updated_at).sort
    output = TypusUser.columns.map(&:name).sort
    assert_equal expected, output
  end

  context "generate" do

    should "not be valid if email is not passed" do
      assert TypusUser.generate.invalid?
    end

    should "be valid when email is passed" do
      options = { :email => 'demo@example.com' }
      assert TypusUser.generate(options).valid?
    end

    should "accept password" do
      options = { :email => 'demo@example.com', :password => 'XXXXXXXX' }
      assert TypusUser.generate(options).valid?
    end

    should "accept role" do
      options = { :email => 'demo@example.com', :role => 'admin' }
      assert TypusUser.generate(options).valid?
    end

    should "have set a default locale" do
      options = { :email => 'demo@example.com', :role => 'admin' }
      assert_equal :en, TypusUser.generate(options).locale
    end

  end

  context "TypusUser" do

    setup do
      @typus_user = Factory(:typus_user)
    end

    should "return email" do
      assert_equal @typus_user.email, @typus_user.to_label
    end

    should "return first_name" do
      @typus_user.first_name = "John"
      assert_equal "John", @typus_user.to_label
    end

    should "return last_name" do
      @typus_user.last_name = "Locke"
      assert_equal "Locke", @typus_user.to_label
    end

    should "return name when first_name and last_name are set" do
      @typus_user.first_name, @typus_user.last_name = "John", "Locke"
      assert_equal "John Locke", @typus_user.to_label
    end

    should "return name when first_name and last_name are set to nil" do
      @typus_user.first_name, @typus_user.last_name = nil
      assert_equal @typus_user.email, @typus_user.to_label
    end

    should "verify salt never changes" do
      expected = @typus_user.salt
      @typus_user.update_attributes(:password => '11111111', :password_confirmation => '11111111')
      assert_equal expected, @typus_user.salt
    end

    should "verify authenticated? returns true or false" do
      assert @typus_user.authenticated?('12345678')
      assert !@typus_user.authenticated?('87654321')
    end

    should "verify can? accepts a Class" do
      assert @typus_user.can?('delete', TypusUser)
    end

    should "verify can? accepts an String" do
      assert @typus_user.can?('delete', 'TypusUser')
    end

    should "verify cannot? acccepts a Class" do
      assert !@typus_user.cannot?('delete', TypusUser)
    end

    should "verify cannot? acccepts an String" do
      assert !@typus_user.cannot?('delete', 'TypusUser')
    end

    should "verify preferences are nil by default" do
      assert @typus_user.preferences.nil?
    end

    should "return default_locale when no preferences are set" do
      assert_equal :en, @typus_user.locale
    end

    should "be able to set a locale" do
      @typus_user.locale = :jp

      expected = {:locale => :jp}
      assert_equal expected, @typus_user.preferences
      assert_equal :jp, @typus_user.locale
    end

    should "be able to set preferences" do
      @typus_user.preferences = {:chunky => "bacon"}
      assert @typus_user.preferences.present?
    end

    should "set locale preference without overriding previously set preferences" do
      @typus_user.preferences = {:chunky => "bacon"}
      @typus_user.locale = :jp

      expected = {:locale => :jp, :chunky => "bacon"}
      assert_equal expected, @typus_user.preferences
    end

  end

  context "Admin Role" do

    setup do
      @typus_user = Factory(:typus_user)
    end

    should "respond true and false to is_root? and is_not_root?" do
      assert @typus_user.is_root?
      assert !@typus_user.is_not_root?
    end

    should "get a list of all applications" do
      assert_equal Typus.applications, @typus_user.applications
    end

    should "get a list of application resources for CRUD Extended application" do
      expected = ["Asset", "Category", "Comment", "Page", "Post"]
      assert_equal expected, @typus_user.application("CRUD Extended")
    end

    should "get a list of application resources for Admin application" do
      assert_equal %w(TypusUser), @typus_user.application("Admin")
    end

  end

  context "Editor Role" do

    setup do
      @typus_user = Factory(:typus_user, :role => "editor")
    end

    should "respond true and false to is_no_root? and is_root?" do
      assert @typus_user.is_not_root?
      assert !@typus_user.is_root?
    end

    should "get a list of all applications" do
      expected = ["Admin", "CRUD Extended"]
      assert_equal expected, @typus_user.applications
    end

    should "get a list of application resources" do
      assert_equal %w(Category Comment Post), @typus_user.application("CRUD Extended")
      assert_equal %w(TypusUser), @typus_user.application("Admin")
    end

  end

  should "owns a resource" do
    typus_user = Factory(:typus_user)
    resource = Factory(:post, :typus_user_id => typus_user.id)
    assert typus_user.owns?(resource)
  end

  should "not own a resource" do
    typus_user = Factory(:typus_user)
    typus_user_2 = Factory(:typus_user)
    resource = Factory(:post, :typus_user_id => typus_user_2.id)
    assert !typus_user.owns?(resource)
  end

end
