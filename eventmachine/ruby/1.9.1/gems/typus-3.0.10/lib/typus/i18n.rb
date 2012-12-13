module Typus
  module I18n

    class << self

      ##
      # Instead of having to translate strings and defining a default value:
      #
      #     Typus::I18n.t("Hello World!", :default => 'Hello World!')
      #
      # We define this method to define the value only once:
      #
      #     Typus::I18n.t("Hello World!")
      #
      # Note that interpolation still works:
      #
      #     Typus::I18n.t("Hello %{world}!", :world => @world)
      #
      def t(msg, *args)
        options = args.extract_options!
        options[:default] = msg
        ::I18n.t(msg, options)
      end

    end

  end
end
