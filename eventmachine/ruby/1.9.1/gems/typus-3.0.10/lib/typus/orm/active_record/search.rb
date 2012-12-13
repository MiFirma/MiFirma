module Typus
  module Orm
    module ActiveRecord
      module Search

        def build_search_conditions(key, value)
          Array.new.tap do |search|
            query = ::ActiveRecord::Base.connection.quote_string(value.downcase)

            search_fields = typus_search_fields
            search_fields = search_fields.empty? ? { "name" => "@" } : search_fields

            search_fields.each do |key, value|
              _query = case value
                       when "=" then query
                       when "^" then "#{query}%"
                       when "@" then "%#{query}%"
                       end

              column_name = (key.match('\.') ? key : "#{table_name}.#{key}")
              table_key = (adapter == 'postgresql') ? "LOWER(TEXT(#{column_name}))" : "#{column_name}"

              search << "#{table_key} LIKE '#{_query}'"
            end
          end.join(" OR ")
        end

        def build_boolean_conditions(key, value)
          { key => (value == 'true') ? true : false }
        end

        def build_datetime_conditions(key, value)
          tomorrow = Time.zone.now.beginning_of_day.tomorrow

          interval = case value
                     when 'today'         then 0.days.ago.beginning_of_day..tomorrow
                     when 'last_few_days' then 3.days.ago.beginning_of_day..tomorrow
                     when 'last_7_days'   then 6.days.ago.beginning_of_day..tomorrow
                     when 'last_30_days'  then 30.days.ago.beginning_of_day..tomorrow
                     end

          ["#{table_name}.#{key} BETWEEN ? AND ?", interval.first.to_s(:db), interval.last.to_s(:db)]
        end

        def build_date_conditions(key, value)
          tomorrow = 0.days.ago.tomorrow.to_date

          interval = case value
                     when 'today'         then 0.days.ago.to_date..tomorrow
                     when 'last_few_days' then 3.days.ago.to_date..tomorrow
                     when 'last_7_days'   then 6.days.ago.to_date..tomorrow
                     when 'last_30_days'  then 30.days.ago.to_date..tomorrow
                     end

          ["#{table_name}.#{key} BETWEEN ? AND ?", interval.first.to_s(:db), interval.last.to_s(:db)]
        end

        def build_string_conditions(key, value)
          { key => value }
        end

        alias :build_integer_conditions :build_string_conditions
        alias :build_belongs_to_conditions :build_string_conditions

        def build_has_many_conditions(key, value)
          # TODO: Detect the primary_key for this object.
          ["#{key}.id = ?", value]
        end

        ##
        # To build conditions we reject all those params which are not model
        # fields.
        #
        # Note: We still want to be able to search so the search param is not
        #       rejected.
        #
        def build_conditions(params)
          Array.new.tap do |conditions|
            query_params = params.dup

            query_params.reject! do |k, v|
              !model_fields.keys.include?(k.to_sym) &&
              !model_relationships.keys.include?(k.to_sym) &&
              !(k.to_sym == :search)
            end

            query_params.compact.each do |key, value|
              filter_type = model_fields[key.to_sym] || model_relationships[key.to_sym] || key
              conditions << send("build_#{filter_type}_conditions", key, value)
            end
          end
        end

        def build_joins(params)
          query_params = params.dup
          query_params.reject! { |k, v| !model_relationships.keys.include?(k.to_sym) }
          query_params.compact.map { |k, v| k.to_sym }
        end

      end
    end
  end
end
