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