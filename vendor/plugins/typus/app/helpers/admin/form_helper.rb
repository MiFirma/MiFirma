module Admin::FormHelper

  def build_form(fields, form)

    options = { :form => form }

    returning(String.new) do |html|

      html << (error_messages_for :item, :header_tag => 'h3')

      fields.each do |key, value|

        if template = @resource[:class].typus_template(key)
          html << typus_template_field(key, template, options)
          next
        end

        html << case value
                when :belongs_to  then typus_belongs_to_field(key, options)
                when :tree        then typus_tree_field(key, :form => options[:form])
                when :boolean, :date, :datetime, :string, :text, :time,
                     :file, :password, :selector, :rich_text
                  typus_template_field(key, value, options)
                else
                  typus_template_field(key, :string, options)
                end
      end

    end.html_safe!

  end

  # OPTIMIZE: Remove returning(String.new) and return directly the html.
  def typus_belongs_to_field(attribute, options)

    form = options[:form]

    ##
    # We only can pass parameters to 'new' and 'edit', so this hack makes
    # the work to replace the current action.
    #
    params[:action] = (params[:action] == 'create') ? 'new' : params[:action]

    back_to = url_for(:controller => params[:controller], :action => params[:action], :id => params[:id])

    related = @resource[:class].reflect_on_association(attribute.to_sym).class_name.constantize
    related_fk = @resource[:class].reflect_on_association(attribute.to_sym).primary_key_name

    confirm = [ _("Are you sure you want to leave this page?"),
                _("If you have made any changes to the fields without clicking the Save/Update entry button, your changes will be lost."), 
                _("Click OK to continue, or click Cancel to stay on this page.") ]

    returning(String.new) do |html|

      message = link_to _("Add"), { :controller => "admin/#{related.class_name.tableize}", 
                                    :action => 'new', 
                                    :back_to => back_to, 
                                    :selected => related_fk }, 
                                    :confirm => confirm.join("\n\n") if @current_user.can?('create', related)

      if related.respond_to?(:roots)
        html << typus_tree_field(related_fk, :items => related.roots, 
                                             :attribute_virtual => related_fk, 
                                             :form => form)
      else
        values = related.find(:all, :order => related.typus_order_by).collect { |p| [p.to_label, p.id] }
        options = { :include_blank => true }
        html_options = { :disabled => attribute_disabled?(attribute) }
        label_text = @resource[:class].human_attribute_name(attribute)
        html << <<-HTML
<li>
  #{form.label related_fk, "#{label_text} <small>#{message}</small>"}
  #{form.select related_fk, values, options, html_options }
</li>
        HTML
      end

    end

  end

  # OPTIMIZE: Move html code to partial.
  def typus_tree_field(attribute, *args)

    options = args.extract_options!
    options[:items] ||= @resource[:class].roots
    options[:attribute_virtual] ||= 'parent_id'

    form = options[:form]

    values = expand_tree_into_select_field(options[:items], options[:attribute_virtual])

    label_text = @resource[:class].human_attribute_name(attribute)

    <<-HTML
<li>
  #{form.label label_text}
  #{form.select options[:attribute_virtual], values, { :include_blank => true }}
</li>
    HTML

  end

  # OPTIMIZE: Cleanup the case statement.
  def typus_relationships

    @back_to = url_for(:controller => params[:controller], :action => params[:action], :id => params[:id])

    returning(String.new) do |html|
      @resource[:class].typus_defaults_for(:relationships).each do |relationship|

        association = @resource[:class].reflect_on_association(relationship.to_sym)

        next if @current_user.cannot?('read', association.class_name.constantize)

        case association.macro
        when :has_and_belongs_to_many
          html << typus_form_has_and_belongs_to_many(relationship)
        when :has_many
          if association.options[:through]
            # Here we will shot the relationship. Better this than raising an error.
          else
            html << typus_form_has_many(relationship)
          end
        when :has_one
          html << typus_form_has_one(relationship)
        end

      end
    end.html_safe!

  end

  # OPTIMIZE: Move html code to partial.
  def typus_form_has_many(field)
    returning(String.new) do |html|

      model_to_relate = @resource[:class].reflect_on_association(field.to_sym).class_name.constantize
      model_to_relate_as_resource = model_to_relate.name.tableize

      reflection = @resource[:class].reflect_on_association(field.to_sym)
      association = reflection.macro
      foreign_key = reflection.through_reflection ? reflection.primary_key_name.pluralize : reflection.primary_key_name

      link_options = { :controller => "admin/#{model_to_relate_as_resource.pluralize}", 
                       :action => 'new', 
                       :back_to => "#{@back_to}##{field}", 
                       :resource => @resource[:self].singularize, 
                       :resource_id => @item.id, 
                       foreign_key => @item.id }

      condition = if @resource[:class].typus_user_id? && !@current_user.is_root?
                    @item.owned_by?(@current_user)
                  else
                    true
                  end

      if condition && @current_user.can?('create', model_to_relate)
        add_new = <<-HTML
  <small>#{link_to _("Add new"), link_options}</small>
        HTML
      end

      html << <<-HTML
<a name="#{field}"></a>
<div class="box_relationships" id="#{model_to_relate_as_resource}">
  <h2>
  #{link_to model_to_relate.typus_human_name.pluralize, { :controller => "admin/#{model_to_relate_as_resource}", foreign_key => @item.id }, :title => _("{{model}} filtered by {{filtered_by}}", :model => model_to_relate.typus_human_name.pluralize, :filtered_by => @item.to_label)}
  #{add_new}
  </h2>
      HTML

      ##
      # It's a has_many relationship, so items that are already assigned to another
      # entry are assigned to that entry.
      #
      items_to_relate = model_to_relate.find(:all, :conditions => ["#{foreign_key} is ?", nil])
      if condition && !items_to_relate.empty?
        html << <<-HTML
  #{form_tag :action => 'relate', :id => @item.id}
  #{hidden_field :related, :model, :value => model_to_relate}
  <p>#{select :related, :id, items_to_relate.collect { |f| [f.to_label, f.id] }.sort_by { |e| e.first } } &nbsp; #{submit_tag _("Add"), :class => 'button'}</p>
  </form>
        HTML
      end

      conditions = if model_to_relate.typus_options_for(:only_user_items) && !@current_user.is_root?
                    { Typus.user_fk => @current_user }
                  end

      options = { :order => model_to_relate.typus_order_by, :conditions => conditions }
      items_count = @resource[:class].find(params[:id]).send(field).count(:conditions => conditions)
      items_per_page = model_to_relate.typus_options_for(:per_page).to_i

      @pager = ::Paginator.new(items_count, items_per_page) do |offset, per_page|
        options.merge!({:limit => per_page, :offset => offset})
        items = @resource[:class].find(params[:id]).send(field).find(:all, options)
      end

      @items = @pager.page(params[:page])

      unless @items.empty?
        options = { :back_to => "#{@back_to}##{field}", :resource => @resource[:self], :resource_id => @item.id }
        html << build_list(model_to_relate, 
                           model_to_relate.typus_fields_for(:relationship), 
                           @items, 
                           model_to_relate_as_resource, 
                           options, 
                           association)
        html << pagination(:anchor => model_to_relate.name.tableize) unless pagination.nil?
      else
        message = _("There are no {{records}}.", 
                    :records => model_to_relate.typus_human_name.pluralize.downcase)
        html << <<-HTML
  <div id="flash" class="notice"><p>#{message}</p></div>
        HTML
      end
      html << <<-HTML
</div>
      HTML
    end
  end

  # OPTIMIZE: Move html code to partial.
  def typus_form_has_and_belongs_to_many(field)
    returning(String.new) do |html|

      model_to_relate = @resource[:class].reflect_on_association(field.to_sym).class_name.constantize
      model_to_relate_as_resource = model_to_relate.name.tableize

      reflection = @resource[:class].reflect_on_association(field.to_sym)
      association = reflection.macro

      condition = if @resource[:class].typus_user_id? && !@current_user.is_root?
                    @item.owned_by?(@current_user)
                  else
                    true
                  end

      if condition && @current_user.can?('create', model_to_relate)
        add_new = <<-HTML
  <small>#{link_to _("Add new"), :controller => field, :action => 'new', :back_to => @back_to, :resource => @resource[:self], :resource_id => @item.id}</small>
        HTML
      end

      html << <<-HTML
<a name="#{field}"></a>
<div class="box_relationships" id="#{model_to_relate_as_resource}">
  <h2>
  #{link_to model_to_relate.typus_human_name.pluralize, :controller => "admin/#{model_to_relate_as_resource}"}
  #{add_new}
  </h2>
      HTML

      if model_to_relate.count < 500

        items_to_relate = (model_to_relate.find(:all) - @item.send(field))

        if condition && !items_to_relate.empty?
          html << <<-HTML
    #{form_tag :action => 'relate', :id => @item.id}
    #{hidden_field :related, :model, :value => model_to_relate}
    <p>#{select :related, :id, items_to_relate.collect { |f| [f.to_label, f.id] }.sort_by { |e| e.first } } &nbsp; #{submit_tag _("Add"), :class => 'button'}</p>
    </form>
          HTML
        end

      end

      conditions = if model_to_relate.typus_options_for(:only_user_items) && !@current_user.is_root?
                    { Typus.user_fk => @current_user }
                  end

      options = { :order => model_to_relate.typus_order_by, :conditions => conditions }
      items_count = @resource[:class].find(params[:id]).send(field).count(:conditions => conditions)
      items_per_page = model_to_relate.typus_options_for(:per_page).to_i

      @pager = ::Paginator.new(items_count, items_per_page) do |offset, per_page|
        options.merge!({:limit => per_page, :offset => offset})
        items = @resource[:class].find(params[:id]).send(field).find(:all, options)
      end

      @items = @pager.page(params[:page])

      unless @items.empty?
        html << build_list(model_to_relate, 
                           model_to_relate.typus_fields_for(:relationship), 
                           @items, 
                           model_to_relate_as_resource, 
                           {}, 
                           association)
        html << pagination(:anchor => model_to_relate.name.tableize) unless pagination.nil?
      else
        message = _("There are no {{records}}.", 
                    :records => model_to_relate.typus_human_name.pluralize.downcase)
        html << <<-HTML
  <div id="flash" class="notice"><p>#{message}</p></div>
        HTML
      end
      html << <<-HTML
</div>
      HTML
    end
  end

  # OPTIMIZE: Move html code to partial.
  def typus_form_has_one(field)
    returning(String.new) do |html|

      model_to_relate = @resource[:class].reflect_on_association(field.to_sym).class_name.constantize
      model_to_relate_as_resource = model_to_relate.name.tableize

      reflection = @resource[:class].reflect_on_association(field.to_sym)
      association = reflection.macro

      html << <<-HTML
<a name="#{field}"></a>
<div class="box_relationships">
  <h2>
  #{link_to model_to_relate.typus_human_name, :controller => "admin/#{model_to_relate_as_resource}"}
  </h2>
      HTML
      items = Array.new
      items << @resource[:class].find(params[:id]).send(field) unless @resource[:class].find(params[:id]).send(field).nil?
      unless items.empty?
        options = { :back_to => @back_to, :resource => @resource[:self], :resource_id => @item.id }
        html << build_list(model_to_relate, 
                           model_to_relate.typus_fields_for(:relationship), 
                           items, 
                           model_to_relate_as_resource, 
                           options, 
                           association)
      else
        message = _("There is no {{records}}.", 
                    :records => model_to_relate.typus_human_name.downcase)
        html << <<-HTML
  <div id="flash" class="notice"><p>#{message}</p></div>
        HTML
      end
      html << <<-HTML
</div>
      HTML
    end
  end

  # OPTIMIZE: Cleanup the rescue ...
  def typus_template_field(attribute, template, options = {})

    template_name = File.join('admin', 'templates', "#{template}")

    custom_options = { :start_year => @resource[:class].typus_options_for(:start_year), 
                       :end_year => @resource[:class].typus_options_for(:end_year), 
                       :minute_step => @resource[:class].typus_options_for(:minute_step), 
                       :disabled => attribute_disabled?(attribute), 
                       :include_blank => true }

    render template_name, :resource => @resource, 
                          :attribute => attribute, 
                          :options => custom_options, 
                          :html_options => {}, 
                          :form => options[:form], 
                          :label_text => @resource[:class].human_attribute_name(attribute)

  rescue ActionView::TemplateError => error
    raise error
  rescue Exception => error
    locale = @current_user.preferences[:locale]
    message = <<-HTML
Missing translation file <strong>#{locale}.yml</strong>. Download it <a href="http://github.com/svenfuchs/rails-i18n/blob/master/rails/locale/#{locale}.yml">here</a> and place it on `config/locales`.
    HTML
    flash[:error] = message
    I18n.locale = :en
    retry
  end

  def attribute_disabled?(attribute)
    accessible = @resource[:class].accessible_attributes
    return accessible.nil? ? false : !accessible.include?(attribute)
  end

  ##
  # Tree builder when model +acts_as_tree+
  #
  def expand_tree_into_select_field(items, attribute)
    returning(String.new) do |html|
      items.each do |item|
        html << %{<option #{"selected" if @item.send(attribute) == item.id} value="#{item.id}">#{"&nbsp;" * item.ancestors.size * 2} &#8627; #{item.to_label}</option>\n}
        html << expand_tree_into_select_field(item.children, attribute) unless item.children.empty?
      end
    end
  end

end