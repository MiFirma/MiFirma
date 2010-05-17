Given /^exist a proposal with name "([^\"]*)", problem "([^\"]*)" and how to solve "([^\"]*)"$/ do |name, problem, howto_solve|
  Proposal.create :name => name, :problem => problem, :howto_solve => howto_solve 
end
