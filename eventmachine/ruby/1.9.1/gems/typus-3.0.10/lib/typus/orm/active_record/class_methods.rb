module Typus
  module Orm
    module ActiveRecord
      module ClassMethods

        include Typus::Orm::Base

        # Model fields as an <tt>ActiveSupport::OrderedHash</tt>.
        def model_fields
          ActiveSupport::OrderedHash.new.tap do |hash|
            columns.map { |u| hash[u.name.to_sym] = u.type.to_sym }
          end
        end

        # Model relationships as an <tt>ActiveSupport::OrderedHash</tt>.
        def model_relationships
          ActiveSupport::OrderedHash.new.tap do |hash|
            reflect_on_all_associations.map { |i| hash[i.name] = i.macro }
          end
        end

        # Form and list fields
        def typus_fields_for(filter)
          ActiveSupport::OrderedHash.new.tap do |fields_with_type|
            data = read_model_config['fields']

            ##
            # Let's say for example we want to get the fields for actions
            # related with editing stuff.
            #

            fields = case filter.to_sym
                     when :list, :form
                       # TODO: This statement is for backwards compatibility
                       #       with the current tests, so can be removed in
                       #       the near future.
                       data[filter.to_s] || data['default'] || ""
                     when :index
                       data['index'] || data['list'] || data['default'] || ""
                     when :new, :create
                       data['new'] || data['form'] || data['default'] || ""
                     when :edit, :update, :toggle
                       data['edit'] || data['form'] || data['default'] || ""
                     else
                       data[filter.to_s] || data['default'] || ""
                     end

            virtual_fields = instance_methods.map { |i| i.to_s } - model_fields.keys.map { |i| i.to_s }

            fields.extract_settings.map { |f| f.to_sym }.each do |field|
              if reflect_on_association(field)
                fields_with_type[field.to_s] = reflect_on_association(field).macro
                next
              end

              if typus_field_options_for(:selectors).include?(field)
                fields_with_type[field.to_s] = :selector
                next
              end

              dragonfly = respond_to?(:dragonfly_apps_for_attributes) && dragonfly_apps_for_attributes.try(:has_key?, field)
              paperclip = respond_to?(:attachment_definitions) && attachment_definitions.try(:has_key?, field)

              if dragonfly || paperclip
                fields_with_type[field.to_s] = :file
                next
              end

              if virtual_fields.include?(field.to_s)
                fields_with_type[field.to_s] = :virtual
              end

              fields_with_type[field.to_s] = case field.to_s
                                             when 'parent', 'parent_id' then :tree
                                             when /password/            then :password
                                             when 'position'            then :position
                                             when /\./                  then :transversal
                                             else
                                               if fields_with_type[field.to_s]
                                                 fields_with_type[field.to_s]
                                               else
                                                 model_fields[field]
                                               end
                                             end

            end
          end
        end

        def typus_filters
          ActiveSupport::OrderedHash.new.tap do |fields_with_type|
            if data = read_model_config['filters']
              data.extract_settings.map { |i| i.to_sym }.each do |field|
                attribute_type = model_fields[field.to_sym]
                if reflect_on_association(field.to_sym)
                  attribute_type = reflect_on_association(field.to_sym).macro
                end
                fields_with_type[field.to_s] = attribute_type
              end
            end
          end
        end

      end
    end
  end
end
