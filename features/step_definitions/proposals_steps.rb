Given /^the following proposals:$/ do |proposal|
  Proposal.create!(proposal.hashes)
end
