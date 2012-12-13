require "test_helper"

class ConfigurationTest < ActiveSupport::TestCase

  should "verify typus roles is loaded" do
    assert Typus::Configuration.respond_to?(:roles!)
    assert Typus::Configuration.roles!.is_a?(Hash)
  end

  should "verify typus config file is loaded" do
    assert Typus::Configuration.respond_to?(:config!)
    assert Typus::Configuration.config!.is_a?(Hash)
  end

  should "load configuration files from config broken" do
    Typus.expects(:config_folder).at_least_once.returns("test/fixtures/config/broken")
    assert_not_equal Hash.new, Typus::Configuration.roles!
    assert_not_equal Hash.new, Typus::Configuration.config!
  end

  should "load configuration files from config empty" do
    Typus.expects(:config_folder).at_least_once.returns("test/fixtures/config/empty")
    assert_equal Hash.new, Typus::Configuration.roles!
    assert_equal Hash.new, Typus::Configuration.config!
  end

  should "load configuration files from config ordered" do
    Typus.expects(:config_folder).at_least_once.returns("test/fixtures/config/ordered")
    expected = { "admin" => { "categories" => "read" } }
    assert_equal expected, Typus::Configuration.roles!
  end

  should "load configuration files from config unordered" do
    Typus.expects(:config_folder).at_least_once.returns("test/fixtures/config/unordered")
    expected = { "admin" => { "categories" => "read, update" } }
    assert_equal expected, Typus::Configuration.roles!
  end

  should "load configuration files from config default" do
    Typus.expects(:config_folder).at_least_once.returns("test/fixtures/config/default")
    assert_not_equal Hash.new, Typus::Configuration.roles!
    assert_not_equal Hash.new, Typus::Configuration.config!
    assert Typus.resources.empty?
  end

end
