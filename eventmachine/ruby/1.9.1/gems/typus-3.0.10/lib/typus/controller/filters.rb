module Typus
  module Controller
    module Filters

      protected

      def add_predefined_filter(*args)
        @predefined_filters ||= []
        @predefined_filters << args unless args.empty?
      end

      def prepend_predefined_filter(*args)
        @predefined_filters ||= []
        @predefined_filters = @predefined_filters.unshift(args) unless args.empty?
      end

      def append_predefined_filter(*args)
        @predefined_filters ||= []
        @predefined_filters = @predefined_filters.concat([args]) unless args.empty?
      end

    end
  end
end
