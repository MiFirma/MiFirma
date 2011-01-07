Feature: Sign proposal
  In order to show my interest in a proposal
  As a user
  I want sign a proposal

  Scenario: Sign a proposal from proposal page
    Given the following proposals:
      |name|problem|howto_solve|tractis_template_code|
      |Acabar la crisis|description 1|howto 1|249186096|
    When I go to "Acabar la crisis" proposal page
    Then I should see "Acabar la crisis"
    And I should see button image with alt "Firmar"
    When fill in "email" with "my@email.com"
    And I press "Firmar"
    Then A pending signature must be created
    And I should be redirected to tractis contract template "249186096" with a signature return_to url
    When I return to signature url from signing the proposal in tractis
    Then my signature must be count
    And the contract must be downloaded and saved
  
  
