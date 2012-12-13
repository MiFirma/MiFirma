module Typus
  module Generators
    class ViewsGenerator < Rails::Generators::Base

      source_root File.expand_path("../../../../app", __FILE__)

      desc <<-MSG
Description:
  Copies all Typus views to your application.

      MSG

      def copy_views
        directory "views", "app/views"
      end

    end
  end
end
