# http://www.pivotaltracker.com/story/show/1902149
Feature: Delete user

	In order delete users that are not coming to the event
	As an admin
	I want to be able to delete users

  @selenium	
  Scenario: Delete User
      Given 2 users "Hector, Jose"
  	   When I login as an admin
  	    And I go to "/users"
  	    And I click on link "Borrar" next to user "Jose"
        And I confirm the "¿Seguro que te quieres borrar de la lista?" prompt
   	   Then there will not be a user "Jose" in the db