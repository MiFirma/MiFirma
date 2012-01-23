# == Schema Information
#
# Table name: provinces
#
#  id                   :integer         not null, primary key
#  id_ine               :integer
#  name                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  only_circunscription :boolean
#

class Province < ActiveRecord::Base
	has_many :municipalities, :foreign_key => "province_id", :primary_key=>"id_ine"
	validates_uniqueness_of :name
end
