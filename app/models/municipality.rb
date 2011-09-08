class Municipality < ActiveRecord::Base
	belongs_to :province, :foreign_key => :province_id
	validates_uniqueness_of :name, :scope => :province_id,
		:message => "El nombre del municipio no se debe repetir para una misma provincia"
end
