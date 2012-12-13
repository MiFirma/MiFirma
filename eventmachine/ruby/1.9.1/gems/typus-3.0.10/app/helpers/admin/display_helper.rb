module Admin
  module DisplayHelper

    def build_display(item, fields)
      fields.map do |attribute, type|
        value = if (type == :boolean) || (data = item.send(attribute))
                  send("display_#{type}", item, attribute)
                else
                  "&mdash;".html_safe
                end

        [@resource.human_attribute_name(attribute), value]
      end
    end

    def display_boolean(item, attribute)
      data = item.send(attribute)
      boolean_assoc = item.class.typus_boolean(attribute)
      (data ? boolean_assoc.rassoc("true") : boolean_assoc.rassoc("false")).first
    end

    def display_belongs_to(item, attribute)
      data = item.send(attribute)
      link_to data.to_label, { :controller => data.class.to_resource,
                               :action => data.class.typus_options_for(:default_action_on_item),
                               :id => data.id }
    end

    def display_file(item, attribute)
      typus_file_preview(item, attribute)
    end

    def display_selector(item, attribute)
      item.mapping(attribute)
    end

    def display_datetime(item, attribute)
      I18n.l(item.send(attribute), :format => @resource.typus_date_format(attribute))
    end

    def display_string(item, attribute)
      item.send(attribute)
    end

    alias_method :display_text, :display_string
    alias_method :display_position, :display_string
    alias_method :display_integer, :display_string
    alias_method :display_decimal, :display_string

  end
end
