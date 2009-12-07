# http://www.pivotaltracker.com/story/show/1902150
Feature: Edit user

	In order..
	As an...
	I want...

  @webrat
  Scenario: Editar Pefil
     Given a region "Comunidad Valenciana"
       And 3 areas "Legal, Marketing, Software"
  	   And a user "Jose"
   	   And that I'm logged in as user "Jose"
  
  	  When I visit the edit page for that user
  	   And I fill in name with "Hector Perez"
  	   And I fill in last_name with "Perez"
  		 And I fill in url with "http://arpahector.com"
  		 And I select user_region_id as "Comunidad Valenciana"
  		 And I fill in more_info with "I would like to contribute as..."
  		 
  		 And I check "Software"
  		 And I check "Marketing"
  		 
  	   And I press the "Enviar" button
  	  Then we will have the following user:
  	 			 | name         | last_name | url                   | more_info                        |
  	 			 | Hector Perez | Perez     | http://arpahector.com | I would like to contribute as... |
  
  		 And that user will have the following associations:
  				 | region               |
  				 | Comunidad Valenciana |
  				 
  		 And that user will be associated to the following areas:
        	 | name      |
        	 | Software  |
        	 | Marketing |
  