##
# FIXME: Somehow I want to cleanup this module, for the moment has tests and
#        works as expected, but there's a lot of duplication here.
#

module Typus
  module Controller
    module Actions

      protected

      ##
      # @resource_actions is used to customize the actions which appear under
      # each item on the tables. This is really a nice feature because allows
      # us to enable actions for items without much effort. For example adding
      # a "Recover from Trash" action:
      #
      #     def index
      #       add_resource_action('Recover', {:action => 'untrash'}, {:confirm => Typus::I18n.t("Recover %{resource}?", :resource => @resource.model_name.human)})
      #       super
      #     end
      #

      def add_resource_action(*args)
        @resource_actions ||= []
        @resource_actions << args unless args.empty?
      end

      def prepend_resource_action(*args)
        @resource_actions ||= []
        @resource_actions = @resource_actions.unshift(args) unless args.empty?
      end

      def append_resource_action(*args)
        @resource_actions ||= []
        @resource_actions = @resource_actions.concat([args]) unless args.empty?
      end

      ##
      # @resources_actions is used to build a list of custom actions which will
      # be appended beside "<h2></h2>" all the actions.
      #
      # Let's say for example that I want to be able to run the application
      # without sidebars and headers (headless mode). In this case I need to
      # somehow add custom actions to the page so I can navigate.
      #
      # Instead of having this code here, maybe it's better to duplicate the
      # actions on the pages. So for example: Admin::PostsController#index will
      # show a link to add new in the sidebar and beside the "<h2>" header.
      #

      def add_resources_action(*args)
        @resources_actions ||= []
        @resources_actions << args unless args.empty?
      end

      def prepend_resources_action(*args)
        @resources_actions ||= []
        @resources_actions = @resources_actions.unshift(args) unless args.empty?
      end

      def append_resources_action(*args)
        @resources_actions ||= []
        @resources_actions = @resources_actions.concat([args]) unless args.empty?
      end

    end
  end
end
