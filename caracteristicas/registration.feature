Feature: Registration

	In order to organize a tribe
	As an organizer
	I want a registration process
	

@current
Scenario: Registration

	  When I go to "/"
	   And I fill in email with "voodoorai2000@gmail.com"
	   And I press the "Registrate" button
	  Then an email will be sent to "voodoorai2000@gmail.com"
	   And the subject will be "Bienvenido a la tribu"
	   
