class ProvinceController < ApplicationController

	# Utilizado para obtener los Municipios de una provincia en los combos 
	def municipalities_for_provinceid
      @municipalities = Municipality.find( :all, :conditions => [" province_id = ?", params[:id]]  ).sort_by{ |k| k['name'] }    
      respond_to do |format|
        format.json  { render :json => @municipalities }      
      end
  end
end
