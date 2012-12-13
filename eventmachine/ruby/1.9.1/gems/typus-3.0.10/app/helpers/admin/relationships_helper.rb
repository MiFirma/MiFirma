module Admin
  module RelationshipsHelper

    def setup_relationship(field)
      @field = field
      @model_to_relate = @resource.reflect_on_association(field.to_sym).class_name.typus_constantize
      @model_to_relate_as_resource = @model_to_relate.to_resource
      @reflection = @resource.reflect_on_association(field.to_sym)
      @association_name = @reflection.through_reflection ? @reflection.name.to_s : @model_to_relate.model_name
    end

    def typus_form_has_many(field)
      setup_relationship(field)

      options = @reflection.through_reflection ? {} : { @reflection.primary_key_name => @item.id }

      count_items_to_relate = @model_to_relate.order(@model_to_relate.typus_order_by).count - @item.send(field).count

      if set_condition && !count_items_to_relate.zero?
        form = if count_items_to_relate > Typus.autocomplete
                 build_relate_form('admin/templates/relate_form_with_autocomplete')
               else
                 @items_to_relate = @model_to_relate.order(@model_to_relate.typus_order_by) - @item.send(field)
                 build_relate_form
               end
      end

      build_pagination

      # If we are on a through_reflection set the association name!
      @resource_actions = if @reflection.through_reflection
                            [["Edit", {:action=>"edit"}, {}],
                             ["Unrelate", {:resource_id=> @item.id, :resource=> @resource.model_name, :action=>"unrelate", :association_name => @association_name}, {:confirm=>"Unrelate?"}]]
                          else
                            [["Edit", {:action=>"edit"}, {}],
                             ["Trash", {:resource_id=>@item.id, :resource=>@resource.model_name, :action=>"destroy"}, {:confirm=>"Trash?"}]]
                           end

      render "admin/templates/has_n",
             :association_name => @association_name,
             :add_new => build_add_new(options),
             :form => form,
             :table => build_relationship_table
    end

    def typus_form_has_and_belongs_to_many(field)
      setup_relationship(field)

      count_items_to_relate = @model_to_relate.order(@model_to_relate.typus_order_by).count - @item.send(field).count

      if set_condition && !count_items_to_relate.zero?
        form = if count_items_to_relate > Typus.autocomplete
                 build_relate_form('admin/templates/relate_form_with_autocomplete')
               else
                 @items_to_relate = @model_to_relate.order(@model_to_relate.typus_order_by) - @item.send(field)
                 build_relate_form
               end
      end

      build_pagination

      # TODO: Find a cleaner way to add these actions ...
      @resource_actions = [["Edit", {:action=>"edit"}, {}],
                           ["Unrelate", {:resource_id=> @item.id, :resource=> @resource.model_name, :action=>"unrelate"}, {:confirm=>"Unrelate?"}]]

      render "admin/templates/has_n",
             :association_name => @association_name,
             :add_new => build_add_new,
             :form => form,
             :table => build_relationship_table
    end

    def build_pagination
      items_per_page = @model_to_relate.typus_options_for(:per_page)
      data = @item.send(@field).order(@model_to_relate.typus_order_by).where(set_conditions)
      @items = data.paginate(:per_page => items_per_page, :page => params[:page])
    end

    def build_relate_form(template = "admin/templates/relate_form")
      options = { :association_name => @association_name,
                  :items_to_relate => @items_to_relate,
                  :model_to_relate => @model_to_relate }
      render template, options
    end

    def build_relationship_table
      build_list(@model_to_relate,
                 @model_to_relate.typus_fields_for(:relationship),
                 @items,
                 @model_to_relate_as_resource,
                 {},
                 @reflection.macro,
                 @association_name)
    end

    def build_add_new(options = {})
      default_options = { :controller => "/admin/#{@model_to_relate.to_resource}",
                          :action => "new",
                          :resource => @resource.model_name,
                          :resource_id => @item.id }

      if set_condition && admin_user.can?("create", @model_to_relate)
        link_to Typus::I18n.t("Add new"), default_options.merge(options)
      end
    end

    def set_condition
      if @resource.typus_user_id? && admin_user.is_not_root?
        admin_user.owns?(@item)
      else
        true
      end
    end

    def set_conditions
      if @model_to_relate.typus_options_for(:only_user_items) && admin_user.is_not_root?
        { Typus.user_fk => admin_user }
      end
    end

    def typus_form_has_one(field)
      setup_relationship(field)

      @items = Array.new
      if item = @item.send(field)
        @items << item
      end

      # TODO: Find a cleaner way to add these actions ...
      @resource_actions = [["Edit", {:action=>"edit"}, {}],
                           ["Trash", {:resource_id=>@item.id, :resource=>@resource.model_name, :action=>"destroy"}, {:confirm=>"Trash?"}]]

      options = { :resource_id => nil, @reflection.primary_key_name => @item.id }

      render "admin/templates/has_one",
             :association_name => @association_name,
             :add_new => @items.empty? ? build_add_new(options) : nil,
             :table => build_relationship_table
    end

    def typus_belongs_to_field(attribute, form)
      association = @resource.reflect_on_association(attribute.to_sym)
      related = association.class_name.typus_constantize
      related_fk = association.primary_key_name

      # TODO: Use the build_add_new method.
      if admin_user.can?('create', related)
        options = { :controller => "/admin/#{related.to_resource}",
                    :action => 'new',
                    :resource => @resource.model_name }
        # Pass the resource_id only to edit/update because only there is where
        # the record actually exists.
        options.merge!(:resource_id => @item.id) if %w(edit update).include?(params[:action])
        message = link_to Typus::I18n.t("Add new"), options
      end

      # Set the template.
      template = if related.respond_to?(:roots) || !(related.count > Typus.autocomplete)
                   "admin/templates/belongs_to"
                 else
                   "admin/templates/belongs_to_with_autocomplete"
                 end

      # Set the values.
      values = if related.respond_to?(:roots)
                 expand_tree_into_select_field(related.roots, related_fk)
               elsif !(related.count > Typus.autocomplete)
                 related.order(related.typus_order_by).map { |p| [p.to_label, p.id] }
               end

      render template,
             :resource => @resource,
             :attribute => attribute,
             :form => form,
             :related_fk => related_fk,
             :related => related,
             :message => message,
             :label_text => @resource.human_attribute_name(attribute),
             :values => values,
             :html_options => { :disabled => attribute_disabled?(attribute) },
             :options => { :include_blank => true }
    end

  end
end
