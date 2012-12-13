module Admin
  module FiltersHelper

    def build_filters(resource = @resource, params = params)
      typus_filters = resource.typus_filters

      return if typus_filters.empty?

      filters = typus_filters.map do |key, value|
                  items = case value
                          when :boolean then boolean_filter(key)
                          when :string then string_filter(key)
                          when :date, :datetime then date_filter(key)
                          when :belongs_to then belongs_to_filter(key)
                          when :has_many, :has_and_belongs_to_many then
                            has_many_filter(key)
                          else
                            string_filter(key)
                          end

                  filter = set_filter(key, value)

        { :filter => filter, :items => items }
      end

      hidden_filters = params.dup

      # Remove default params.
      rejections = %w(controller action locale utf8 sort_order order_by)
      hidden_filters.delete_if { |k, v| rejections.include?(k) }

      # Remove also custom params.
      rejections = filters.map { |i| i[:filter] }
      hidden_filters.delete_if { |k, v| rejections.include?(k) }

      render "admin/helpers/filters/filters", :filters => filters, :hidden_filters => hidden_filters
    end

    def set_filter(key, value)
      case value
      when :belongs_to
        att_assoc = @resource.reflect_on_association(key.to_sym)
        class_name = att_assoc.options[:class_name] || key.capitalize.camelize
        resource = class_name.typus_constantize
        att_assoc.primary_key_name
      else
        key
      end
    end

    def belongs_to_filter(filter)
      att_assoc = @resource.reflect_on_association(filter.to_sym)
      class_name = att_assoc.options[:class_name] || filter.capitalize.camelize
      resource = class_name.typus_constantize

      items = [[Typus::I18n.t("View all %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase.pluralize), ""]]
      items += resource.order(resource.typus_order_by).map { |v| [v.to_label, v.id] }
    end

    def has_many_filter(filter)
      att_assoc = @resource.reflect_on_association(filter.to_sym)
      class_name = att_assoc.options[:class_name] || filter.classify
      resource = class_name.typus_constantize

      items = [[Typus::I18n.t("View all %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase.pluralize), ""]]
      items += resource.order(resource.typus_order_by).map { |v| [v.to_label, v.id] }
    end

    def date_filter(filter)
      values = %w(today last_few_days last_7_days last_30_days)
      items = [[Typus::I18n.t("Show all dates"), ""]]
      items += values.map { |v| [Typus::I18n.t(v.humanize), v] }
    end

    def boolean_filter(filter)
      values  = @resource.typus_boolean(filter)
      items = [[Typus::I18n.t("Show by %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase), ""]]
      items += values.map { |k, v| [Typus::I18n.t(k.humanize), v] }
    end

    def string_filter(filter)
      values = if @resource.const_defined?(filter.to_s.upcase)
                 @resource::const_get(filter.to_s.upcase).to_a
               else
                 @resource.send(filter.to_s).to_a
               end

      items = [[Typus::I18n.t("Show by %{attribute}", :attribute => @resource.human_attribute_name(filter).downcase), ""]]
      array = values.first.is_a?(Array) ? values : values.map { |i| [i, i] }
      items += array
    end

    def predefined_filters
      @predefined_filters ||= []
    end

  end
end
