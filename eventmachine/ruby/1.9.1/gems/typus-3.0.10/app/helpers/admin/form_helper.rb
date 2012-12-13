module Admin
  module FormHelper

    def build_form(fields, form)
      String.new.tap do |html|
        fields.each do |key, value|
          value = :template if (template = @resource.typus_template(key))
          html << case value
                  when :belongs_to
                    typus_belongs_to_field(key, form)
                  when :tree
                    typus_tree_field(key, form)
                  when :boolean, :date, :datetime, :file, :text, :time, :password, :selector
                    typus_template_field(key, value, form)
                  when :template
                    typus_template_field(key, template, form)
                  else
                    typus_template_field(key, :string, form)
                  end
        end
      end.html_safe
    end

    def typus_tree_field(attribute, form)
      render "admin/templates/tree",
             :attribute => attribute,
             :form => form,
             :label_text => @resource.human_attribute_name(attribute),
             :values => expand_tree_into_select_field(@resource.roots, "parent_id")
    end

    def typus_relationships
      String.new.tap do |html|
        @resource.typus_defaults_for(:relationships).each do |relationship|
          association = @resource.reflect_on_association(relationship.to_sym)
          next if association.macro == :belongs_to
          next if admin_user.cannot?('read', association.class_name.typus_constantize)
          html << send("typus_form_#{association.macro}", relationship)
        end
      end.html_safe
    end

    def typus_template_field(attribute, template, form)
      options = { :start_year => @resource.typus_options_for(:start_year),
                  :end_year => @resource.typus_options_for(:end_year),
                  :minute_step => @resource.typus_options_for(:minute_step),
                  :disabled => attribute_disabled?(attribute),
                  :include_blank => true }

      render "admin/templates/#{template}",
             :resource => @resource,
             :attribute => attribute,
             :options => options,
             :html_options => {},
             :form => form,
             :label_text => @resource.human_attribute_name(attribute)
    end

    def attribute_disabled?(attribute)
      @resource.protected_attributes.include?(attribute)
    end

    ##
    # Tree builder when model +acts_as_tree+
    #
    def expand_tree_into_select_field(items, attribute)
      String.new.tap do |html|
        items.each do |item|
          html << %{<option #{"selected" if @item.send(attribute) == item.id} value="#{item.id}">#{"&nbsp;" * item.ancestors.size * 2} #{item.to_label}</option>\n}
          html << expand_tree_into_select_field(item.children, attribute) unless item.children.empty?
        end
      end
    end

  end
end
