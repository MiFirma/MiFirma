module Admin
  module TableHelper

    def build_table(model, fields, items, link_options = {}, association = nil, association_name = nil)
      render "admin/helpers/table/table",
             :model => model,
             :fields => fields,
             :items => items,
             :link_options => link_options,
             :headers => table_header(model, fields),
             :association_name => association_name
    end

    def table_header(model, fields, params = params)
      fields.map do |key, value|

        key = key.gsub(".", " ") if key.to_s.match(/\./)
        content = model.human_attribute_name(key)

        if params[:action].eql?('index') && model.typus_options_for(:sortable)
          association = model.reflect_on_association(key.to_sym)
          order_by = association ? association.primary_key_name : key

          if (model.model_fields.map(&:first).map { |i| i.to_s }.include?(key) || model.reflect_on_all_associations(:belongs_to).map(&:name).include?(key.to_sym))
            sort_order = case params[:sort_order]
                         when 'asc' then ['desc', '&darr;']
                         when 'desc' then ['asc', '&uarr;']
                         else [nil, nil]
                         end
            switch = sort_order.last if params[:order_by].eql?(order_by)
            options = { :order_by => order_by, :sort_order => sort_order.first }
            message = [content, switch].compact.join(" ").html_safe
            link_to message, params.merge(options)
          else
            content
          end

        else
          content
        end

      end
    end

    def table_fields_for_item(item, fields)
      fields.map { |k, v| send("table_#{v}_field", k, item) }
    end

    def resource_actions
      @resource_actions ||= []
    end

    def table_actions(model, item, association_name = nil)
      resource_actions.map do |body, url, options|
        if admin_user.can?(url[:action], model.name)
          link_to Typus::I18n.t(body),
                  params.dup.cleanup.merge(url).merge(:controller => model.to_resource, :id => item.id),
                  options
        end
      end.join(" / ").html_safe
    end

    def table_belongs_to_field(attribute, item)
      if att_value = item.send(attribute)
        action = item.send(attribute).class.typus_options_for(:default_action_on_item)
        if admin_user.can?(action, att_value.class.name)
          link_to att_value.to_label, :controller => "/admin/#{att_value.class.to_resource}", :action => action, :id => att_value.id
        else
          att_value.to_label
        end
      else
        "&mdash;".html_safe
      end
    end

    def table_has_and_belongs_to_many_field(attribute, item)
      item.send(attribute).map { |i| i.to_label }.join(", ")
    end

    alias :table_has_many_field :table_has_and_belongs_to_many_field

    def table_text_field(attribute, item)
      (raw_content = item.send(attribute)).present? ? truncate(raw_content) : "&mdash;".html_safe
    end

    def table_generic_field(attribute, item)
      (raw_content = item.send(attribute)).present? ? raw_content : "&mdash;".html_safe
    end

    alias :table_float_field :table_generic_field
    alias :table_integer_field :table_generic_field
    alias :table_decimal_field :table_generic_field
    alias :table_virtual_field :table_generic_field
    alias :table_string_field :table_generic_field

    def table_selector_field(attribute, item)
      item.mapping(attribute)
    end

    def table_file_field(attribute, item)
      typus_file_preview(item, attribute, { :height => 60, :width => 60})
    end

    def table_tree_field(attribute, item)
      item.parent ? item.parent.to_label : "&mdash;".html_safe
    end

    def table_position_field(attribute, item, connector = " / ")
      html_position = []

      [ [:move_to_top, "Top"],
        [:move_higher,  "Up"],
        [:move_lower,   "Down"],
        [:move_to_bottom, "Bottom"] ].each do |key, value|

        options = { :controller => "/admin/#{item.class.to_resource}", :action => "position", :id => item.id, :go => key }
        should_be_inactive = (item.respond_to?(:first?) && ([:move_higher, :move_to_top].include?(key) && item.first?)) ||
                             (item.respond_to?(:last?) &&  ([:move_lower, :move_to_bottom].include?(key) && item.last?))
        html_position << link_to_unless(should_be_inactive, Typus::I18n.t(value), params.merge(options)) do |name|
          %w(<span class="inactive">#{name}</span>)
        end
      end

      "#{item.position}<br/><br/>#{html_position.compact.join(connector)}".html_safe
    end

    def table_datetime_field(attribute, item)
      if field = item.send(attribute)
        I18n.localize(field, :format => item.class.typus_date_format(attribute))
      end
    end

    alias :table_date_field :table_datetime_field
    alias :table_time_field :table_datetime_field

    def table_boolean_field(attribute, item)
      status = item.send(attribute)
      boolean_assoc = item.class.typus_boolean(attribute)
      human_boolean = (status ? boolean_assoc.rassoc("true") : boolean_assoc.rassoc("false")).first

      options = { :controller => "/admin/#{item.class.to_resource}",
                  :action => "toggle",
                  :id => item.id,
                  :field => attribute.gsub(/\?$/, '') }
      confirm = Typus::I18n.t("Change %{attribute}?", :attribute => item.class.human_attribute_name(attribute).downcase)
      link_to Typus::I18n.t(human_boolean), options, :confirm => confirm
    end

    def table_transversal_field(attribute, item)
      field_1, field_2 = attribute.split(".")

      if related_item = item.send(field_1)
        related_item.send(field_2)
      else
        "&mdash;".html_safe
      end
    end

  end
end
