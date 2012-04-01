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

require 'test_helper'

class ProposalTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "Proposals attributes must not be empty" do
		proposal = IlpProposal.new
    assert proposal.invalid?
		assert proposal.errors[:name].any?
		assert proposal.errors[:problem].any?
		assert proposal.errors[:howto_solve].any?
		assert proposal.errors[:pdf_file_name].any?
		assert proposal.errors[:pdf_content_type].any?
		assert proposal.errors[:pdf_file_size].any?
		assert proposal.errors[:pdf_updated_at].any?
		assert proposal.errors[:num_required_signatures].any?
		assert proposal.errors[:promoter_name].any?
		assert proposal.errors[:promoter_url].any?
		assert proposal.errors[:promoter_short_name].any?
		assert proposal.errors[:handwritten_signatures].any?
		assert proposal.errors[:signatures_end_date].any?
  end
	
	test "Proposal is not valid without a unique name" do
		assert true
	end

	test "IlpProposal ilp is valid" do
		proposal = IlpProposal.find_by_name(proposals(:ilp).name)
		assert proposal.valid?
	end
	
end
