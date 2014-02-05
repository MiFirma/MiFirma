class ProvinceController < ApplicationController

	# Return the municipalities of province with id params[:id]
	def municipalities_for_provinceid
			@municipalities = Province.find(params[:id]).municipalities.order("name")
      # @municipalities = Municipality.find( :all, :conditions => [" province_id = ?", params[:id]]  ).sort_by{ |k| k['name'] }    
         render :json => @municipalities       
  end
end
