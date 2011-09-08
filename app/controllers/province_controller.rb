class ProvinceController < ApplicationController

	# Return the municipalities of province with id params[:id]
	def municipalities_for_provinceid
      @municipalities = Municipality.find( :all, :conditions => [" province_id = ?", params[:id]]  ).sort_by{ |k| k['name'] }    
      respond_to do |format|
        format.json  { render :json => @municipalities }      
      end
  end
end
