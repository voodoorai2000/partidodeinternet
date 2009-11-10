Feature: Editar Perfil

	In order..
	As an...
	I want...
	

@webrat
Scenario: Editar Pefil
   Given a region "Comunidad Valenciana"
	   And a user "Jose"
 	   And that I'm logged in as user "Jose"

	  When I visit the edit page for that user
	   And I fill in name with "Hector Perez"
		 And I fill in url with "http://arpahector.com"
		 And I select user_region_id as "Comunidad Valenciana"
	   And I press the "Enviar" button
	  Then we will have the following user:
	 			 | name         | url                   |
	 			 | Hector Perez | http://arpahector.com |

		 And that user will have the following associations:
				 | region               |
				 | Comunidad Valenciana |