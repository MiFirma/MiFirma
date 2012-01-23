# == Schema Information
#
# Table name: municipalities
#
#  id          :integer         not null, primary key
#  id_ine      :integer
#  name        :string(255)
#  province_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

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
