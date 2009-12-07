# http://www.pivotaltracker.com/story/show/1902122
Feature: Ranking

	In order to see the regions that are interested in the iWeekend
	As an admin
	I want to see a ranking of registrations by region
	

  @webrat
  Scenario: Ranking
     Given a region "Comunidad Valenciana"
  	   And that region has 5 users
  	   And a region "Islas Baleares"
  		 And that region has 10 users
  
  	  When I go to "/ranking"
  	  Then I will see the regions "Islas Baleares, Comunidad Valenciana" in that order
  	  Then I will see the text "Comunidad Valenciana (5)"
  		Then I will see the text "Islas Baleares (10)"
  		
  Scenario: Viewing ranking with a user that hasn't chosen a region
      Given a user
      When I go to "/ranking"
      Then I will see the text "Ranking"
  