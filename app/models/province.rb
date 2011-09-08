class Province < ActiveRecord::Base
	has_many :municipalities, :foreign_key => "province_id", :primary_key=>"id_ine"
	validates_uniqueness_of :name
end
