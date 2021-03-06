# http://www.pivotaltracker.com/story/show/1902123
Feature: Registration

	In order to organize a tribe
	As an organizer
	I want a registration process
	

  @webrat
  Scenario: Registration
  
  	  When I go to "/"
  	   And I fill in email with "voodoorai2000@gmail.com"
  	   And I fill in name with "Raimond"
  	   And I fill in last_name with "Garcia"
  	   And I press the "Registrate" button
  	  Then I will see the text "¡Gracias! Te hemos mandado un email para activar tu cuenta."
  	  Then an email will be sent to "voodoorai2000@gmail.com"
  	   And the subject will be "Bienvenido al Partido de Internet"
  	   And we will have the following user:
  	       | email                   | name    | last_name |
  	       | voodoorai2000@gmail.com | Raimond | Garcia    |
  
  	   
  