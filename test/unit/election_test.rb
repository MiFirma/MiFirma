require 'test_helper'

class ElectionTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    election = Election.new(:name => elections(:e20N).name,
														:signatures_end_date => elections(:e20N).signatures_end_date)
		assert !election.save
  end
end
