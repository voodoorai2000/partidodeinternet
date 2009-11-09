Feature: Editar Perfil

	In order..
	As an...
	I want...
	

@webrat
Scenario: Editar Pefil
   Given a region "Comunidad Valenciana"
 	   And that I'm logged in
	  When I visit the edit page for that user
	   And I fill in name with "Hector Perez"
		 And I fill in url with "http://arpahector.com"
		 And I fill in user_region_id with "Comunidad Valenciana"
	   And I press the "Editar" button
	  Then we will have the following user:
	 			 | name         | url                   |
	 			 | Hector Perez | http://arpahector.com |
		 And that user will have the following associations:
				 | region               |
				 | Comunidad Valenciana |