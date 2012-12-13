module Typus
  module Controller
    module Associations

      protected

      ##
      #     >> Order.relationship_with(Invoice)
      #     => :has_one
      #
      def set_has_one_association(item_class, options)
        association_name = item_class.model_name.underscore.to_sym
        options.merge!(:action => 'edit', :id => @item.send(association_name).id)
        notice = Typus::I18n.t("%{model} successfully updated.", :model => item_class.model_name.human)

        redirect_to options, :notice => notice
      end

      ##
      #     >> Entry.relationship_with(Comment)
      #     => :has_many
      #
      def set_has_many_association(item_class, options)
        item = item_class.find(params[:resource_id])
        association_name = @resource.model_name.tableize.to_sym

        if item.send(association_name).push(@item)
          notice = Typus::I18n.t("%{model} successfully updated.", :model => item_class.model_name.human)
        else
          alert = @item.errors.full_messages
        end

        options.merge!(:action => 'edit', :id => item.id)

        redirect_to options, :notice => notice, :alert => alert
      end

      ##
      #     >> Entry.relationship_with(Category)
      #     => :has_and_belongs_to_many
      #
      def set_has_and_belongs_to_many_association(item_class, options)
        # In this case we DO need to get the remote item to make to association.
        item = item_class.find(params[:resource_id])
        association_name = @resource.model_name.tableize.to_sym
        options.merge!(:action => 'edit', :id => item.id)

        if item.send(association_name).push(@item)
          notice = Typus::I18n.t("%{model} successfully updated.", :model => item_class.model_name.human)
        else
          alert = @item.errors.full_messages
        end

        redirect_to options, :notice => notice, :alert => alert
      end

      ##
      #     >> Invoice.relationship_with(Order)
      #     => :belongs_to
      #
      def set_belongs_to_association(item_class, options)
        association_name = item_class.model_name.tableize.to_sym
        foreign_key = @resource.reflect_on_association(association_name).primary_key_name

        if params[:resource_id]
          item = item_class.find(params[:resource_id])
          options.merge!(:action => 'edit', :id => item.id)
          if @item.send(association_name).push(item)
            notice = Typus::I18n.t("%{model} successfully updated.", :model => item_class.model_name.human)
          else
            alert = @item.errors.full_messages
          end
        else
          options.merge!(:action => 'new', foreign_key => @item.id)
        end

        redirect_to options, :notice => notice, :alert => alert
      end

    end
  end
end
