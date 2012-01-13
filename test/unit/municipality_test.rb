require 'test_helper'

class MunicipalityTest < ActiveSupport::TestCase
 	# Provinces has not the same name
  test "Municipality is not valid without a unique name in the same province" do
    municipality = Municipality.new(:name => municipalities(:madrid).name,
														:id_ine => municipalities(:madrid).id_ine,
														:province_id => municipalities(:madrid).province_id)
		assert !municipality.save
		
	
		#In a different province works
		municipality.province_id = provinces(:alava).id_ine
		assert municipality.save
	end
end
