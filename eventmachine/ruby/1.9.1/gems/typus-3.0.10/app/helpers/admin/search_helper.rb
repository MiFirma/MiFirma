module Admin
  module SearchHelper

    def search(resource = @resource, params = params)
      if (typus_search = resource.typus_defaults_for(:search)) && typus_search.any?

        hidden_filters = params.dup
        rejections = %w(controller action locale utf8 sort_order order_by search page)
        hidden_filters.delete_if { |k, v| rejections.include?(k) }

        render "admin/helpers/search/search", :hidden_filters => hidden_filters
      end
    end

  end
end
