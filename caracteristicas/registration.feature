Feature: Registration

	In order to organize a tribe
	As an organizer
	I want a registration process
	

@webrat
Scenario: Registration

	  When I go to "/"
	   And I fill in email with "voodoorai2000@gmail.com"
	   And I press the "Registrate" button
	  Then I will see the text "¡Gracias! Te hemos mandado un email para activar tu cuenta."
	  Then an email will be sent to "voodoorai2000@gmail.com"
	   And the subject will be "Bienvenido al Partido de Internet"
	   
