module Typus

  module Format

    protected

    def generate_html

      items_count = @resource[:class].count(:joins => @joins, :conditions => @conditions)
      items_per_page = @resource[:class].typus_options_for(:per_page).to_i

      @pager = ::Paginator.new(items_count, items_per_page) do |offset, per_page|
        data(:limit => per_page, :offset => offset)
      end

      @items = @pager.page(params[:page])

      select_template :index

    end

    # TODO: Find in batches only works properly if it's used on
    #       models, not controllers, so in this action does nothing.
    #       We should find a way to be able to process data.
    def generate_csv

      fields = @resource[:class].typus_fields_for(:csv).collect { |i| i.first }

      require 'csv'
      if CSV.const_defined?(:Reader)
        # Old CSV version so we enable faster CSV.
        begin
          require 'fastercsv'
        rescue Exception => error
          raise error.message
        end
        csv = FasterCSV
      else
        csv = CSV
      end

      filename = "#{Rails.root}/tmp/export-#{@resource[:self]}-#{Time.now.strftime("%Y%m%d%H%M%S")}.csv"

      options = { :conditions => @conditions, :batch_size => 1000 }

      csv.open(filename, 'w', :col_sep => ';') do |csv|
        csv << fields
        @resource[:class].find_in_batches(options) do |records|
          records.each do |record|
            csv << fields.map { |f| record.send(f) }
          end
        end
      end

      send_file filename

    end

    def generate_xml
      fields = @resource[:class].typus_fields_for(:xml).collect { |i| i.first }
      render :xml => data.to_xml(:only => fields)
    end

    def generate_json
      fields = @resource[:class].typus_fields_for(:json).collect { |i| i.first }
      render :json => data.to_json(:only => fields)
    end

    def data(*args)
      eager_loading = @resource[:class].reflect_on_all_associations(:belongs_to).map { |i| i.name }
      options = { :joins => @joins, :conditions => @conditions, :order => @order, :include => eager_loading }
      options.merge!(args.extract_options!)
      @resource[:class].find(:all, options)
    end

  end

end