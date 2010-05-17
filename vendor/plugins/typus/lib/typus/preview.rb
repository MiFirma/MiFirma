module Typus

  module InstanceMethods

    include ActionView::Helpers::UrlHelper

    # OPTIMIZE: Move html code to helper.
    def typus_preview_on_table(attribute)

      attachment = attribute.split('_file_name').first
      file_preview = Typus::Configuration.options[:file_preview]
      file_thumbnail = Typus::Configuration.options[:file_thumbnail]

      if send(attachment).styles.member?(file_preview) && send("#{attachment}_content_type") =~ /^image\/.+/
        <<-HTML
<script type="text/javascript" charset="utf-8">
  $(document).ready(function() { $("##{to_dom}_#{attribute}_preview").fancybox(); });
</script>
<a id="#{to_dom}_#{attribute}_preview" href="#{send(attachment).url(file_preview)}" title="#{to_label}">#{send(attribute)}</a>
        HTML
      else
        <<-HTML
<a href="#{send(attachment).url}">#{send(attribute)}</a>
        HTML
      end
    end

    # OPTIMIZE: Move html code to helper.
    def typus_preview(attribute)

      attachment = attribute.split('_file_name').first

      case send("#{attachment}_content_type")
      when /^image\/.+/
        file_preview = Typus::Configuration.options[:file_preview]
        file_thumbnail = Typus::Configuration.options[:file_thumbnail]
        if send(attachment).styles.member?(file_preview) && send(attachment).styles.member?(file_thumbnail)
          <<-HTML
<script type="text/javascript" charset="utf-8">
  $(document).ready(function() { $("##{to_dom}_#{attribute}_preview").fancybox(); });
</script>
<a id="#{to_dom}_#{attribute}_preview" href="#{send(attachment).url(file_preview)}" title="#{to_label}">
<img src="#{send(attachment).url(file_thumbnail)}" />
        </a>
          HTML
        elsif send(attachment).styles.member?(file_thumbnail)
          <<-HTML
<a href="#{send(attachment).url}" title="#{to_label}">
<img src="#{send(attachment).url(file_thumbnail)}" />
        </a>
          HTML
        elsif send(attachment).styles.member?(file_preview)
          <<-HTML
<script type="text/javascript" charset="utf-8">
  $(document).ready(function() { $("##{to_dom}_#{attribute}_preview").fancybox(); });
</script>
<a id="#{to_dom}_#{attribute}_preview" href="#{send(attachment).url(file_preview)}" title="#{to_label}">
#{send(attribute)}
        </a>
          HTML
        else
          <<-HTML
<a href="#{send(attachment).url}">#{send(attribute)}</a>
          HTML
        end
      else
        <<-HTML
<a href="#{send(attachment).url}">#{send(attribute)}</a>
        HTML
      end

    end

  end

end

ActiveRecord::Base.send :include, Typus::InstanceMethods