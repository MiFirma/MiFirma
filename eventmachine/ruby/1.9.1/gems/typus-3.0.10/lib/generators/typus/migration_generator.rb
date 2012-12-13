require "rails/generators/migration"
require "generators/typus/controller_generator"

module Typus
  module Generators
    class MigrationGenerator < Rails::Generators::Base

      include Rails::Generators::Migration

      source_root File.expand_path("../../templates", __FILE__)

      class_option :user_class_name, :default => "AdminUser", :aliases => "-u"
      class_option :user_fk, :default => "admin_user_id", :aliases => "-fk"

      desc <<-DESC
Description:
  This generator creates required configuration files and a migration to
  enable authentication on the admin panel.

Examples:

  `rails generate typus:migration`

    creates needed files with `AdminUser` as the Typus user.

  `rails generate typus:migration -u User`

    creates needed files with `User` as the Typus user.

      DESC

      def self.next_migration_number(path)
        Time.zone.now.to_s(:number)
      end

      def generate_model
        unless model_exists?
          invoke "active_record:model", [options[:user_class_name]], :migration => false
        end
      end

      def inject_mixins_into_model
        inject_into_class "app/models/#{model_filename}.rb", options[:user_class_name] do
          <<-MSG

  ROLE = Typus::Configuration.roles.keys.sort
  LOCALE = Typus.locales

  enable_as_typus_user

          MSG
        end
      end

      def generate_initializer
        template "config/initializers/typus_authentication.rb", "config/initializers/typus_authentication.rb"
      end

      def generate_typus_yaml
        template "config/typus/typus.yml", "config/typus/typus.yml"
      end

      def generate_typus_roles_yaml
        template "config/typus/typus_roles.yml", "config/typus/typus_roles.yml"
      end

      def generate_controller
        Typus::Generators::ControllerGenerator.new([options[:user_class_name].pluralize]).invoke_all
      end

      def generate_migration
        migration_template "migration.rb", "db/migrate/create_#{admin_users_table_name}"
      end

      protected

      def admin_users_table_name
        options[:user_class_name].tableize
      end

      def migration_name
        "Create#{options[:user_class_name]}s"
      end

      def model_exists?
        File.exists?(File.join(destination_root, model_path))
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{model_filename}.rb")
      end

      def model_filename
        options[:user_class_name].underscore
      end

    end
  end
end
