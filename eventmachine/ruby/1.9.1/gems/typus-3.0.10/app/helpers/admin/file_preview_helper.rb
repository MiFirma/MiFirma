module Admin
  module FilePreviewHelper

    def get_type_of_attachment(attachment)
      if defined?(Paperclip) && attachment.is_a?(Paperclip::Attachment)
        :paperclip
      elsif defined?(Dragonfly) && attachment.is_a?(Dragonfly::ActiveModelExtensions::Attachment)
        :dragonfly
      end
    end

    def link_to_detach_attribute(attribute)
      validators = @item.class.validators.delete_if { |i| i.class != ActiveModel::Validations::PresenceValidator }.map { |i| i.attributes }.flatten.map { |i| i.to_s }

      attachment = @item.send(attribute)

      field = case get_type_of_attachment(attachment)
              when :dragonfly then attribute
              when :paperclip then "#{attribute}_file_name"
              end

      if !validators.include?(field) && attachment
        attribute_i18n = @item.class.human_attribute_name(attribute)
        message = Typus::I18n.t("Remove")
        label_text = <<-HTML
#{attribute_i18n}
<small>#{link_to message, { :action => 'update', :id => @item.id, :attribute => attribute }, :confirm => Typus::I18n.t("Are you sure?")}</small>
        HTML
        label_text.html_safe
      end
    end

    def typus_file_preview(item, attribute, options = {})
      if (attachment = item.send(attribute))
        adapter = get_type_of_attachment(attachment)
        send("typus_file_preview_for_#{adapter}", attachment, options)
      end
    end

    def typus_file_preview_for_dragonfly(attachment, options = {})
      if attachment.mime_type =~ /^image\/.+/
        render "admin/helpers/file_preview",
               :preview => attachment.process(:thumb, Typus.image_preview_size).url,
               :thumb => attachment.process(:thumb, Typus.image_thumb_size).url,
               :options => options
      else
        link_to attachment.name, attachment.url
      end
    end

    def typus_file_preview_for_paperclip(attachment, options = {})
      if attachment.exists?
        styles = attachment.styles.keys
        if styles.include?(Typus.file_preview) && styles.include?(Typus.file_thumbnail)
          render "admin/helpers/file_preview",
                 :preview => attachment.url(Typus.file_preview, false),
                 :thumb => attachment.url(Typus.file_thumbnail, false),
                 :options => options
        else
          link_to attachment.original_filename, attachment.url(:original, false)
        end
      end
    end

  end
end
