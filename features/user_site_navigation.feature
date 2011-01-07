Feature: User site navigation
  In order to browse the site
  As a user
  I want to be able to access all pages
  
  Scenario: View all MiFirma sections
    Given I am on the home page
    When I follow "¿Cómo funciona?"
    Then I should be on how works page
    When I follow "Sobre nosotros"
    Then I should be on about us page
    When I follow "Propuestas"
    Then I should be on the home page
  
  
