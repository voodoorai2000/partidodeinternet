# http://www.pivotaltracker.com/story/show/1902121
Feature: User list

  In order...
	As a...
	I want...

  @webrat
  Scenario: Ver todos los usuarios
  	 Given the following users:
  				 | name   | email          | url                 |
  				 | Jose   | jose@gmail.com | http://www.jose.com |
  				 | Ana    | ana@gmail.com  | http://www.ana.com  |
  		When I go to "/"
  		 And I click on link "Usuarios registrados"
      Then I will see the text "2 Usuarios Registrados"
  		Then I will see the user "Ana"
			 But I will not see the text "ana@gmail.com"
  		 And I will see the user "Jose"
			 But I will not see the text "jose@gmail.com"
  
