﻿# == Schema Information
#
# Table name: signatures
#
#  id                             :integer         not null, primary key
#  proposal_id                    :integer
#  email                          :string(255)
#  state                          :integer
#  token                          :string(255)
#  tractis_contract_location      :string(255)
#  name                           :string(255)
#  dni                            :string(255)
#  surname                        :string(255)
#  terms                          :boolean
#  created_at                     :datetime
#  updated_at                     :datetime
#  province_id                    :integer
#  municipality_id                :integer
#  address                        :string(255)
#  zipcode                        :string(255)
#  date_of_birth                  :date
#  province_of_birth_id           :integer
#  municipality_of_birth_id       :integer
#  type                           :string(255)
#  surname2                       :string(255)
#  tractis_signature_file_name    :string(255)
#  tractis_signature_content_type :string(255)
#  tractis_signature_file_size    :integer
#  tractis_signature_updated_at   :datetime
#

class EndorsmentSignature < Signature
	belongs_to :province
  belongs_to :proposal, :class_name => 'EndorsmentProposal'
	
	has_attached_file :tractis_signature, 
		{:path => ":rails_root/public/system/firmas/:promoter_name/:province_id/:filename", :s3_permissions => :private}.merge(PAPERCLIP_CONFIG)
	
	validates_presence_of :province
	validate :uniqueness_of_dni
	
	
	def uniqueness_of_dni
		if self.signed? and EndorsmentSignature.where("state > 0 and dni = ? and id <> ?",dni,id).count>0
			errors.add :dni, "Sólo puedes firmar un aval una sola vez."
		end
	end

 
	private
		# interpolate in paperclip
	Paperclip.interpolates :promoter_name  do |attachment, style|
		attachment.instance.proposal.promoter_short_name
	end
	
	Paperclip.interpolates :province_id  do |attachment, style|
		attachment.instance.province_id
	end
end
