require "test_helper"

class StringTest < ActiveSupport::TestCase

  should "extract_settings" do
    assert_equal %w( a b c ), "a, b, c".extract_settings
    assert_equal %w( a b c ), " a  , b,  c ".extract_settings
  end

  context "remove_prefix" do

    should "return strings without default prefix" do
      assert_equal "posts", "admin/posts".remove_prefix
      assert_equal "typus_users", "admin/typus_users".remove_prefix
      assert_equal "delayed/jobs", "admin/delayed/jobs".remove_prefix
    end

    should "return strings without custom prefix" do
      assert_equal "posts", "typus/posts".remove_prefix
      assert_equal "typus_users", "typus/typus_users".remove_prefix
      assert_equal "delayed/tasks", "typus/delayed/tasks".remove_prefix
    end

  end

  context "extract_class" do

    setup do
      class SucursalBancaria; end

      Typus::Configuration.models_constantized = { "Post" => Post,
                                                   "TypusUser" => TypusUser,
                                                   "Delayed::Task" => Delayed::Task,
                                                   "SucursalBancaria" => SucursalBancaria }
    end

    should "work for models" do
      assert_equal Post, "admin/posts".extract_class
      assert_equal TypusUser, "admin/typus_users".extract_class
    end

    should "work for namespaced models" do
      assert_equal Delayed::Task, "admin/delayed/tasks".extract_class
    end

    should "work with inflections" do
      assert_equal SucursalBancaria, "admin/sucursales_bancarias".extract_class
    end

  end

  context "acl_action_mapper" do

    should "return create" do
      %w(new create).each do |action|
        assert_equal "create", action.acl_action_mapper
      end
    end

    should "return read" do
      %w(index show).each do |action|
        assert_equal "read", action.acl_action_mapper
      end
    end

    should "return update" do
      %w(edit update position toggle relate unrelate).each do |action|
        assert_equal "update", action.acl_action_mapper
      end
    end

    should "return delete" do
      %w(destroy trash).each do |action|
        assert_equal "delete", action.acl_action_mapper
      end
    end

    should "return other" do
      %w(other).each do |action|
        assert_equal "other", action.acl_action_mapper
      end
    end

  end

  context "to_resource" do

    should "convert String into resource" do
      assert_equal "entries", "Entry".to_resource
    end

    should "convert namespaced String into resource" do
      assert_equal "category/entries", "Category::Entry".to_resource
    end

  end

end
