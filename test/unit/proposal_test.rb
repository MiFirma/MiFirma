require 'test_helper'

class ProposalTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "Proposals attributes must not be empty" do
		proposal = Proposal.new
    assert proposal.invalid?
		assert proposal.errors[:name].any?
		assert proposal.errors[:problem].any?
		assert proposal.errors[:howto_solve].any?
		assert proposal.errors[:position].any?
		assert proposal.errors[:tractis_template_code].any?
		assert proposal.errors[:pdf_file_name].any?
		assert proposal.errors[:pdf_content_type].any?
		assert proposal.errors[:pdf_file_size].any?
		assert proposal.errors[:pdf_updated_at].any?
		assert proposal.errors[:num_required_signatures].any?
		assert proposal.errors[:promoter_name].any?
		assert proposal.errors[:promoter_url].any?
  end
	
	test "Proposal is not valid without a unique name" do
		assert true
	end
	
end
