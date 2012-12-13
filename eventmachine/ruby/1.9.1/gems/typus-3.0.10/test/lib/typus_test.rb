require "test_helper"

class TypusTest < ActiveSupport::TestCase

  should "verify default_config for autocomplete" do
    assert_equal 100, Typus.autocomplete
  end

  should "verify default_config for admin_title" do
    assert_equal "Typus", Typus.admin_title
  end

  should "verify default_config for admin_sub_title" do
    assert Typus.admin_sub_title.is_a?(String)
  end

  should "verify default_config for authentication" do
    assert_equal :session, Typus.authentication
  end

  should "verify default_config for mailer_sender" do
    assert_nil Typus.mailer_sender
  end

  should "verify default_config for username" do
    assert_equal "admin", Typus.username
  end

  should "verify default_config for password" do
    assert_equal "columbia", Typus.password
  end

  context "file management" do

    context "paperclip" do

      should "verify default_config for file_preview" do
        assert_equal :medium, Typus.file_preview
      end

      should "verify default_config for file_thumbnail" do
        assert_equal :thumb, Typus.file_thumbnail
      end

    end

    context "dragonfly" do

      should "verify default_config for image_preview_size" do
        assert_equal "x450", Typus.image_preview_size
      end

      should "verify default_config for image_thumb_size" do
        assert_equal "150x150#", Typus.image_thumb_size
      end

    end

  end

  should "verify default_config for relationship" do
    assert_equal "typus_users", Typus.relationship
  end

  should "verify default_config for master_role" do
    assert_equal "admin", Typus.master_role
  end

  should "verify config_folder is a Pathname" do
    assert Typus.config_folder.is_a?(Pathname)
  end

  should "return applications sorted" do
    expected = ["Admin", "CRUD", "CRUD Extended", "HasManyThrough", "HasOne", "MongoDB", "Polymorphic", "STI"]
    assert_equal expected, Typus.applications
  end

  should "return modules of the CRUD Extended application" do
    expected = ["Asset", "Category", "Comment", "Page", "Post"]
    assert_equal expected, Typus.application("CRUD Extended")
  end

  should "return models and should be sorted" do
    expected = ["Animal",
                "Asset",
                "Bird",
                "Case",
                "Category",
                "Comment",
                "Dog",
                "Entry",
                "Hit",
                "ImageHolder",
                "Invoice",
                "Order",
                "Page",
                "Post",
                "Project",
                "ProjectCollaborator",
                "TypusUser",
                "User",
                "View"]
    assert_equal expected, Typus.models
  end

  should "verify resources class_method" do
    assert_equal %w(Git Status WatchDog), Typus.resources
  end

  context "user_class" do

    should "return default value" do
      assert_equal TypusUser, Typus.user_class
    end

  end

  context "user_class_name" do

    should "return default value" do
      assert_equal "TypusUser", Typus.user_class_name
    end

    should "be overrided on demand" do
      assert Typus.respond_to?("user_class_name=")
    end

  end

  context "user_fk" do

    should "return default value" do
      assert_equal "typus_user_id", Typus.user_fk
    end

    should "be overrided on demand" do
      assert Typus.respond_to?("user_fk=")
    end

  end

end
