Feature: View proposals
  In order to let users sign for proposals
  As a user
  I want to view list and details of current proposals

  Scenario: View all proposals
    Given the following proposals:
      |name|problem|howto_solve|
      |Acabar la crisis|description 1|howto 1|
      |Mejorar hipotecas|description 2|howto 3|
	  When I go to the home page
    Then I should see "Acabar la crisis"
	  And I should see "Mejorar hipotecas"

  Scenario: View one proposal
    Given the following proposals:
      |name|problem|howto_solve|
      |Acabar la crisis|description 1|howto 1|
	  When I go to "Acabar la crisis" proposal page
    Then I should see "Acabar la crisis"
	  And I should not see "Mejorar hipotecas"

  Scenario: Go to a proposal from home paga
    Given the following proposals:
      |name|problem|howto_solve|
      |Acabar la crisis|description 1|howto 1|
      |Mejorar hipotecas|description 2|howto 3|
	  When I go to the home page
	  And I follow "Mejorar hipotecas"
	  Then I should be on "Mejorar hipotecas" proposal page
	  And I should see "Mejorar hipotecas"
    And I should not see "Acabar la crisis"

  Scenario: Like MiFirma
  Scenario: Like one proposal
  Scenario: Download proposal pdf
  
