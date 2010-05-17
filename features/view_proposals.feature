Feature: View proposals
  In order to let users sign for proposals
  As a user
  I want to view list and details of current proposals

  Scenario: View all proposals
    Given exist a proposal with name "Acabar la crisis", description "description 1" and how to solve "howto 1"
	And exist a proposal with name "Mejorar hipotecas", description "description 2" and how to solve "howto 2"
	When I go to home page
    Then I should see "Acabar la crisis"
	And I should see "Mejorar hipotecas"

  Scenario: View one proposal
  	Given exist a proposal with name "Acabar la crisis", description "description 1" and how to solve "howto 1"
	When I go to "Acabar la crisis" proposal page
    Then I should see "Acabar la crisis"
	And I should not see "Mejorar hipotecas"
	And I should see "Firmar"

