# 
@webrat
Feature: Security

	So that only the right person can edit a profile
	As an admin
	I want to setup permissions

	Scenario Outline: Access to edit a profile
		  Given 2 users "Hector, Jose"
		 	 When I login as <login>
 	   	  And I visit the edit page of user "<usuario>"
	     Then <action>
	
	Examples:
	        | login    | usuario | action                                      |
	        | "Hector" | Hector  | I will be at the edit page of user "Hector" |
	        | an admin | Hector  | I will be at the edit page of user "Hector" |
	        | "Hector" | Jose    | I will be redirected to "/login"            |
	
	
	Scenario Outline: Access to edit a profile
		  Given a user "Hector"
		 	 When I login as <login>
	   	And I go to "/users"
	     Then <action>
  			 And <action2> 
  
	Examples:
	        | login    | action                         | action2                          |
	        | "Hector" | I will not see the text "edit" | I will not see the text "delete" |
	        | an admin | I will see the text "edit"     | I will see the text "delete"     |
  
