Given /^the following proposals:$/ do |proposal|
  Proposal.create!(proposal.hashes)
end

Then /^I should see button image with alt "([^"]*)"$/ do |arg1|
  assert_select "div.sign input[alt='#{arg1}']"
end

Then /^A pending signature must be created$/ do
  pending
end
