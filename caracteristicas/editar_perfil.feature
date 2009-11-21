Feature: Editar Perfil

	In order..
	As an...
	I want...
	

@current
Scenario: Editar Pefil
   Given a region "Comunidad Valenciana"
	   And a user "Jose"
 	   And that I'm logged in as user "Jose"

	  When I visit the edit page for that user
	   And I fill in name with "Hector Perez"
	   And I fill in last_name with "Perez"
		 And I fill in url with "http://arpahector.com"
		 And I select user_region_id as "Comunidad Valenciana"
		 And I fill in more_info with "I would like to contribute as..."
	   And I press the "Enviar" button
	  Then we will have the following user:
	 			 | name         | last_name | url                   | more_info                        |
	 			 | Hector Perez | Perez     | http://arpahector.com | I would like to contribute as... |

		 And that user will have the following associations:
				 | region               |
				 | Comunidad Valenciana |