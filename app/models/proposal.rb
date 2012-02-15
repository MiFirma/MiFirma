# == Schema Information
#
# Table name: proposals
#
#  id                      :integer         not null, primary key
#  name                    :string(255)
#  position                :integer
#  tractis_template_code   :string(255)
#  pdf_file_name           :string(255)
#  pdf_content_type        :string(255)
#  pdf_file_size           :integer
#  pdf_updated_at          :datetime
#  num_required_signatures :integer
#  promoter_name           :string(255)
#  promoter_url            :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  handwritten_signatures  :integer
#  banner_file_name        :string(255)
#  banner_content_type     :string(255)
#  banner_file_size        :integer
#  banner_updated_at       :datetime
#  promoter_short_name     :string(255)
#  signatures_end_date     :date
#  type                    :string(255)
#  howto_solve             :text
#  election_type           :string(255)
#  problem                 :text
#  election_id             :integer
#  attestor_template_code  :string(255)
#  user_id                 :integer
#

class Proposal < ActiveRecord::Base
	belongs_to 	:user
	has_many 		:signatures
	has_attached_file :banner, PAPERCLIP_CONFIG
	acts_as_list
	
	validates_presence_of :name, :problem, :howto_solve, 
		:promoter_name, :promoter_url, :tractis_template_code,
		:promoter_short_name


	def on_signature_time?
		return signatures_end_date >= Time.now.to_date
	end
	
	def num_signatures_signed
		return signatures.signed.size
	end
	
end
