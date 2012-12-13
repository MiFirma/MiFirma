require "rails/generators/migration"

require "generators/typus/assets_generator"
require "generators/typus/config_generator"
require "generators/typus/controller_generator"
require "generators/typus/initializers_generator"

module Typus
  module Generators
    class TypusGenerator < Rails::Generators::Base

      include Rails::Generators::Migration

      source_root File.expand_path("../../templates", __FILE__)

      namespace "typus"

      desc <<-DESC
Description:
  This generator creates required files to enable an admin panel which allows
  trusted users to edit structured content.

  To enable session authentication run `rails g typus:migration`.

      DESC

      def generate_initializers
        Typus::Generators::InitializersGenerator.new.invoke_all
      end

      def generate_assets
        Typus::Generators::AssetsGenerator.new.invoke_all
      end

      def generate_controllers
        Typus.application_models.each do |model|
          Typus::Generators::ControllerGenerator.new([model.pluralize]).invoke_all
        end
      end

      def generate_config
        Typus::Generators::ConfigGenerator.new.invoke_all
      end

      protected

      def resource
        @resource
      end

      def sidebar
        @sidebar
      end

    end
  end
end
