Feature: Listado de Usuarios

  Para que...
  Como un...
  Quiero...

  @current
  Scenario: Ver todos los usuarios
  	 Given the following users:
  				 | name   | email          | url                 |
  				 | Jose   | jose@gmail.com | http://www.jose.com |
  				 | Ana    | ana@gmail.com  | http://www.ana.com  |
  		When I go to "/users"
      Then I will see the text "2 Usuarios Registrados"
  		Then I will see the user "Ana"
  		 And I will see the user "Jose"
  	 		