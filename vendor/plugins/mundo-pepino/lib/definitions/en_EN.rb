numero = '(the|two|three|a|\d+)'
numbers = '(the|two|three|a|\d+)'
cuyo = '(?:cuy[oa]s?|que tienen? como)'
model_names = "(regions?|users?|areas?)"

# Creación simple con nombre opcional
#Given /^(?:que tenemos )?(#{numero}) (?!.+ #{cuyo})(.+?)(?: (?:llamad[oa]s? )?['"](.+)["'])?$/i do |numero, modelo, nombre|
#that we have the course template "Ruby Introduction"
Given /^(?:that we have )?#{numero} #{model_names}(?: ['"](.+)["'])?$/i do |numero, modelo, nombre|
  if model = modelo.to_unquoted.to_model
    number = numero.to_number
    attribs = names_for_simple_creation(model, number, nombre)
    add_resource(model, attribs, :force_creation => true)
  else
    raise MundoPepino::ModelNotMapped.new(modelo)
  end
end

# Creación con asignación de valor en campo
Given /^(?:que tenemos )?(#{numero}) (.+) #{cuyo} (.+?) (?:(?:es|son) (?:de )?)?['"](.+)["'](?: .+)?$/i do |numero, modelo, campo, valor|
  Given "que tenemos #{numero} #{modelo}"
  Given "que dichos #{modelo} tienen como #{campo} '#{valor}'"
end

#Given /^(?:que tenemos )?(?:el|la|los|las|el\/la|los\/las) (?:siguientes? )?(.+):$/ do |modelo, tabla|
Given /^(?:that we have )?the following (.+)(?: available)?:$/ do |modelo, tabla|   
  model = modelo.to_unquoted.to_model
  tabla.hashes.each do |hash|
    resource = Factory(model.name.underscore.to_sym, hash)
    pile_up resource
  end
  #add_resource model, translated_hashes(tabla.raw, :model => model), :force_creation => true
end 

Given /^que (?:el|la) (.+) ['"](.+)["'] tiene como (.+) ['"](.+)["'](?: \w+)?$/ do |modelo, nombre, campo, valor|
  if resource = last_mentioned_of(modelo, nombre)
    if field = field_for(resource.class, campo)
      resource.update_attribute field, real_value_for(valor)
      pile_up resource
    else
      raise MundoPepino::FieldNotMapped.new(campo)
    end
  end
end

#cambiando + por * para permitir rellenar campos en blanco
Given /^que dich[oa]s? (.+) tienen? como (.+) ['"](.*)["'](?:.+)?$/i do |modelo, campo, valor|
  if res = last_mentioned_of(modelo)
    resources, field, values = resources_array_field_and_values(res, campo, valor)
    if field
      resources.each_with_index do |r, i| 
        r.update_attribute field, real_value_for(values[i])
      end
      pile_up res
    else
      raise MundoPepino::FieldNotMapped.new(campo)
    end
  end
end

#Given /^que dich[oa]s? (.+) tienen? (un|una|dos|tres|cuatro|cinco|\d+) (.+?)(?: (?:llamad[oa]s? )?['"](.+)["'])?$/i do |modelo_padre, numero, modelo_hijos, nombres|
#that region has 5 users
Given /^that #{model_names} has #{numbers} (.+?)(?: (?:llamad[oa]s? )?['"](.+)["'])?$/i do |modelo_padre, numero, modelo_hijos, nombres|
  if mentioned = last_mentioned_of(modelo_padre.to_unquoted)
    children_model = modelo_hijos.to_unquoted.to_model
    resources = (mentioned.is_a?(Array) ? mentioned : [mentioned])
    resources.each do |resource|
      attribs = names_for_simple_creation(children_model, 
        numero.to_number, nombres, parent_options(resource, children_model))
      add_resource children_model, attribs, :force_creation => nombres.nil?
    end
    pile_up mentioned
  end
end

#In the process of extendeding to take into account multiple associations to different models
#Given /^que dich[ao]s? (.+) tienen? (?:el|la|los|las) siguientes? (.+):$/i do |modelo_padre, modelo_hijos, tabla|
Given /^that #{model_names} has the following #{model_names}:$/i do |modelo_padre, modelo_hijos, tabla|
  if mentioned = last_mentioned_of(modelo_padre.to_unquoted)
    children_model = modelo_hijos.to_unquoted.to_model
    resources = (mentioned.is_a?(Array) ? mentioned : [mentioned])
    resources.each do |resource|
      add_resource children_model, translated_hashes(tabla.raw, parent_options(resource, children_model))
    end
  end
end


###############################################################################

pagina_re = '(?:p[áa]gina|portada|[íi]ndice|listado|colecci[óo]n)'
When /^(?:que )?(visito|voy a) (?:el|la) #{pagina_re} de ([\w]+|['"][\w ]+["'])$/i do |modelo_en_crudo|
  modelo = modelo_en_crudo.to_unquoted
  if model = modelo.to_model
    pile_up model.new
    do_visit eval("#{model.table_name}_path")
  elsif url = "la página de #{modelo_en_crudo}".to_url
    do_visit url
  else
    raise MundoPepino::ModelNotMapped.new(modelo)
  end
end

When /^(?:que )?(?:visito|voy a) (?:el|la) #{pagina_re} (?:del|de la) (.+) ['"](.+)["']$/i do |modelo, nombre|
  if resource = last_mentioned_of(modelo, nombre)
    do_visit eval("#{resource.class.name.underscore}_path(resource)")
  else
    raise MundoPepino::ResourceNotFound.new("model #{modelo}, name #{nombre}")
  end
end

When /^(?:que )?visito la p[áa]gina de (?!la)([\w\/]+) (?:de |de la |del )?(.+?)(?: (['"].+["']))?$/i do |accion, modelo, nombre|
  action = accion.to_crud_action or raise(MundoPepino::CrudActionNotMapped.new(accion))
  if action != 'new'
    nombre, modelo = modelo, nil unless nombre
    resource = if modelo && modelo.to_unquoted.to_model
      last_mentioned_of(modelo, nombre.to_unquoted)
    else
      last_mentioned_called(nombre.to_unquoted)
    end
    if resource
      do_visit eval("#{action}_#{resource.mr_singular}_path(resource)")
    else
      MundoPepino::ResourceNotFound.new("model #{modelo}, name #{nombre}")
    end
  else
    model = modelo.to_unquoted.to_model or raise(MundoPepino::ModelNotMapped.new(modelo))
    pile_up model.new
    do_visit eval("#{action}_#{model.name.underscore}_path")
  end
end

#I visit the edit page for that edition
When /^I visit the ([\w\/]+) page for that (.+)$/i do |accion, modelo|
  action = accion.to_crud_action or raise(MundoPepino::CrudActionNotMapped.new(accion))
  resource = last_mentioned_of(modelo)
  if resource
    #do_visit eval("#{action}_#{resource.mr_singular}_path(resource)")
    do_visit eval("#{action}_#{resource.class.name.underscore}_path(resource)")
  else
    MundoPepino::ResourceNotFound.new("model #{modelo}")
  end
end

#I visit the edit page for user "Peter"
When /^I visit the ([\w\/]+) page of #{model_names} ['"]([^\"]+)["']$/i do |accion, modelo, nombre|
  action = accion.to_crud_action or raise(MundoPepino::CrudActionNotMapped.new(accion))
  resource = last_mentioned_of(modelo, nombre)
  if resource
    #do_visit eval("#{action}_#{resource.mr_singular}_path(resource)")
    do_visit eval("#{action}_#{resource.class.name.underscore}_path(resource)")
  else
    MundoPepino::ResourceNotFound.new("model #{modelo}")
  end
end

When /^(?:que )?visito su (?:p[áa]gina|portada)$/i do
  do_visit last_mentioned_url
end

negative_lookahead = '(?:la|el) \w+ del? |su p[aá]gina|su portada'
#I go to "course_templates"
#When /^(?:que )?visito (?!#{negative_lookahead})(.+)$/i do |pagina|
When /^I go to ['"]([^\"]+)["']$/i do |pagina|
  do_visit pagina.to_unquoted.to_url
end

#When /^(?:que )?(?:pulso|pincho|hago click) (?:en )?el bot[oó]n (.+)$/i do |boton|
When /^I (?:click|press) the ['"]([^\"]+)["'] button$/i do |button|
  click_button(button)
end

# When I press the "Delete" button next to subcategory "Sinatra"
When /^I (?:click|press) the ['"]([^\"]+)["'] button next to #{model_names} ['"]([^\"]+)["']$/i do |button, model_class, model_name|
  model = model_class.to_model
  resource = model.find_by_name(model_name)
  within "##{resource.class.name.underscore}_#{resource.id}" do
    click_button button
  end
end

#me da un timeout con ajax o efectos
#le pongo un segundo de espera  
#no basta hay que ponerselo en el step
#que mira el texto despues de hacer click en el link
# When /^(?:que )?(?:pulso|pincho|hago click) (?:en )?el (|enlace ajax|enlace con efectos|enlace) (.+)$/i do |tipo, enlace|
When /^I click on (ajax link|link) ['"]([^\"]+)["']$/i do |link_type, link_text|
  options = {}
  options[:wait] = case link_type.downcase
  when 'ajax link' then :ajax
  else :page
  end
  click_link(link_text.to_unquoted, options)
  #if options[:wait] == :effects or options[:wait] == :ajax
  #  sleep(3)
  #end
end

#Pongo (.*) en vez de (.+)
#para poder simular dejar el campo vacio
#para testear los mensajes de error
# When /^(?:que )?(?:completo|relleno) (.+) con (?:el valor )?['"](.*)["']$/i do |campo, valor|
When /^I fill in (.+) (?:with|as) (?:value )?['"](.*)["']$/i do |field, value|
  find_field_and_do_with_webrat :fill_in, field, :with => value
  system "rake thinking_sphinx:index > /dev/null" if field.to_unquoted == "search"
end


#I fill in name with "new_name" for student with name "Peter"
#I fill in email with "new_email" for student with name "student_name" 
#When /^I fill in (.+) (?:with|as) (?:value )?['"](.*)["']$/i do |field, value|
When /^I replace (.+) (?:with|as) ['"](.*)["'] for #{model_names} with (.+) ['"](.*)["']$/i do |field_to_save, value_to_save, model_name, field_to_search, value_to_search|
  resource = model_name.to_model.send("find_by_#{field_to_search}", value_to_search)
  fill_in "#{model_name.to_model.name.underscore}_#{resource.id}_#{field_to_save}", 
          :with => value_to_save
end

#I fill in "name" with "Roland Crim" in the section "new_student_1"
When /^in the section ['"](.*)["'] I fill in (.+) (?:with|as) (?:value )?['"](.*)["']$/i do |section, field, value|
  within("##{section}") do
    find_field_and_do_with_webrat :fill_in, field, :with => value
  end
end

When /^(?:que )?(?:completo|relleno):$/i do |tabla|
  tabla.raw[1..-1].each do |row|
    When "relleno \"#{row[0].gsub('"', '\"')}\" con \"#{row[1].gsub('"', '\"')}\""
  end
end

When /^(?:que )?elijo (?:la|el)? ?(.+) ['"](.+)["']$/i do |campo, valor|
  choose(campo_to_field(campo).to_s + '_' + valor.downcase.to_underscored)
end

#When /^(?:que )?marco (?:las|los|la|el|)? ?(.+)$/i do |campo|
When /^I check (.+)$/i do |campo|
  find_field_and_do_with_webrat :check, campo
end

When /^(?:que )?desmarco (?:las|los|la|el|)? ?(.+)$/i do |campo|
  find_field_and_do_with_webrat :uncheck, campo
end

When /^(?:que )?adjunto el fichero ['"](.*)["'] (?:a|en) (.*)$/ do |ruta, campo|
  find_field_and_do_with_webrat :attach_file, campo, 
    {:path => "#{RAILS_ROOT}/caracteristicas/" + ruta, :content_type => ruta.to_content_type}
end

#When /^(?:que )?selecciono ["']([^"']+?)["'](?: en (?:el listado de )?(.+))?$/i do |valor, campo|
When /^I select (.+) as ["']([^"']+?)["']$/i do |field, value|
  select(value, :from => field) 
end

When /^(?:que )?selecciono ['"]?(\d\d?) de (\w+) de (\d{4}), (\d\d?:\d\d)["']? como fecha y hora(?: (?:de )?['"]?(.+?)["']?)?$/ do |dia, mes, anio, hora, etiqueta|
# When selecciono "25 de diciembre de 2008, 10:00" como fecha y hora
# When selecciono 23 de noviembre de 2004, 11:20 como fecha y hora "Preferida"
# When selecciono 23 de noviembre de 2004, 11:20 como fecha y hora de "Publicación"
  time = Time.parse("#{mes.to_month} #{dia}, #{anio} #{hora}")
  options = etiqueta ? { :from => etiqueta } : {}
  select_datetime(time, options)
end

When /^(?:que )?selecciono ['"]?(.*)["']? como (?:la )?hora(?: (?:(?:del?|para) (?:la |el )?)?['"]?(.+?)["']?)?$/ do |hora, etiqueta|
  options = etiqueta ? { :from => etiqueta } : {}
  select_time(hora, options)
end

When /^(?:que )?selecciono ['"]?(\d\d?) de (\w+) de (\d{4})["']? como (?:la )?fecha(?: (?:(?:del?|para) (?:la |el )?)?['"]?(.+?)["']?)?$/ do |dia, mes, anio, etiqueta|
  time = Time.parse("#{mes.to_month} #{dia}, #{anio} 12:00")
  options = etiqueta ? { :from => etiqueta } : {}
  select_date(time, options)
end

When /^borro (?:el|la|el\/la) (.+) en (?:la )?(\w+|\d+)(?:ª|º)? posición$/ do |modelo, posicion|
  pile_up modelo.to_unquoted.to_model.new
  do_visit last_mentioned_url
  within("table > tr:nth-child(#{posicion.to_number+1})") do
    click_link "Borrar"
  end
end

#############################################################################
#añadido ver[eé]
veo_o_no = '(?:no )?(?:veo|debo ver|deber[ií]a ver|ver[eé])'
I_will_or_will_not_see = '(?:no )?(?:veo|debo ver|deber[ií]a ver|ver[eé])'

#Then /^(#{veo_o_no}) el texto (.+)?$/i do |should, text|
#And I will see the text "Registration created succesfully."
Then /^I (will not|will) see the text ['"](.*)["']$/i do |should, text|
  sleep(1) #para selenium
  eval('response.body.send(shouldify(should))') =~ /#{Regexp.escape(text.to_unquoted.to_translated)}/mi
end

#next to user "Hector" I will see the text "edit" 
Then /^next to #{model_names} ['"]?(.*)["'] I (will not|will) see the text ['"](.*)["']$/i do |model, name, should, text|
  resource = last_mentioned_of(model, name)
  resource_html_id = "##{model.to_model.name.underscore}_#{resource.id}"
  response.body.send(shouldify(should), have_tag(resource_html_id, /#{text}/i))
end

leo_o_no = '(?:no )?(?:leo|debo leer|deber[íi]a leer)'
Then /^(#{leo_o_no}) el texto (.+)?$/i do |should, text|
  begin
    HTML::FullSanitizer.new.sanitize(response.body).send(shouldify(should)) =~ /#{Regexp.escape(text.to_unquoted.to_translated)}/m
  rescue Spec::Expectations::ExpectationNotMetError
    webrat.save_and_open_page
    raise
  end
end

Then /^(#{veo_o_no}) los siguientes textos:$/i do |should, texts|
  texts.raw.each do |row|
    Then "#{should} el texto #{row[0]}"
  end
end

Then /^(#{leo_o_no}) los siguientes textos:$/i do |should, texts|
  texts.raw.each do |row|
    Then "#{should} el texto #{row[0]}"
  end
end

Then /^(#{veo_o_no}) (?:en )?(?:el selector|la etiqueta|el tag) (["'].+?['"]|[^ ]+)(?:(?: con)? el (?:valor|texto) )?["']?([^"']+)?["']?$/ do |should, tag, value |
  lambda {
    if value
      response.should have_tag(tag.to_unquoted, /.*#{value.to_translated}.*/i)
    else
      response.should have_tag(tag.to_unquoted)
    end
  }.send(not_shouldify(should), raise_error)  
end

Then /^(#{veo_o_no}) (?:las|los) siguientes (?:etiquetas|selectores):$/i do |should, texts|
  check_contents, from_index = texts.raw[0].size == 2 ? [true, 1] : [false, 0]
  texts.raw[from_index..-1].each do |row|
    if check_contents
      Then "#{should} el selector \"#{row[0]}\" con el valor \"#{row[1]}\""
    else
      Then "#{should} el selector \"#{row[0]}\""
    end
  end
end



#Hacer que mire en las acciones member y crud
Then /^(#{veo_o_no}) un enlace (?:a|para) (.+)?$/i do |should, pagina|
  lambda {
    href = relative_page(pagina) || pagina.to_unquoted.to_url
    response.should have_tag('a[href=?]', href)
  }.send(not_shouldify(should), raise_error)
end


Then /^(#{veo_o_no}) marcad[ao] (?:la casilla|el checkbox)? ?(.+)$/ do |should, campo|
  field_labeled(campo.to_unquoted).send shouldify(should), be_checked
end

Then /^(#{veo_o_no}) (?:una|la) tabla (?:(["'].+?['"]|[^ ]+) )?con (?:el|los) (?:siguientes? )?(?:valore?s?|contenidos?):$/ do |should, table_id, valores|
  table_id = "##{table_id.to_unquoted}" if table_id
  shouldified = shouldify(should)
  response.send shouldified, have_selector("table#{table_id}")

  if have_selector("table#{table_id} tbody").matches?(response)
    start_row = 1
    tbody = "tbody"
  else
    start_row = 2
    tbody = ""
  end

  valores.raw[1..-1].each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.send shouldified, 
      have_selector("table#{table_id} #{tbody} tr:nth-child(#{i+start_row})>td:nth-child(#{j+1})") { |td|
        td.inner_text.should =~ /#{cell == '.*' ? cell : Regexp.escape((cell||"").to_translated)}/
      }
    end
  end
end

Then /^(#{veo_o_no}) un formulario con (?:el|los) (?:siguientes? )?(?:campos?|elementos?):$/ do |should, elementos|
  shouldified = shouldify(should)
  response.send(shouldified, have_tag('form')) do
    elementos.raw[1..-1].each do |row|
      label, type = row[0].to_translated, row[1]
      case type
        when "submit":
          with_tag "input[type='submit'][value='#{label}']"
        when "radio":
          with_tag('div') do
            with_tag "label", label
            with_tag "input[type='radio']"
          end  
        when "select", "textarea":
          field_labeled(label).element.name.should == type
        else  
          field_labeled(label).element.attributes['type'].to_s.should == type
      end
    end
  end
end

#BBDD
en_bbdd_tenemos = '(?:en (?:la )?(?:bb?dd?|base de datos) tenemos|tenemos en (?:la )?(?:bb?dd?|base de datos))'
tiene_en_bbdd = '(?:tiene en (?:la )?bbdd|en (?:la )?bbdd tiene|tiene en (?:la )?base de datos|en (?:la )?base de datos tiene)'
Then /^#{en_bbdd_tenemos} (un|una|dos|tres|cuatro|cinco|\d+) ([^ ]+)(?: (?:llamad[oa]s? )?['"](.+)["'])?$/ do |numero, modelo, nombre|
  model = modelo.to_unquoted.to_model
  conditions = if nombre
    {:conditions => [ "#{field_for(model, 'nombre')}=?", nombre ]}
  else
    {}
  end
  resources = model.find(:all, conditions)
  resources.size.should == numero.to_number
  if resources.size > 0
    pile_up (resources.size == 1 ? resources.first : resources)
  end
end


#Then /^#{en_bbdd_tenemos} (un|una|dos|tres|cuatro|cinco|\d+) ([^ ]+)(?: (?:llamad[oa]s? )?['"](.+)["'])?$/ do |numero, modelo, nombre|
Then /^there (will not|will) be a #{model_names} (?:['"](.+)["'])?(?: in the db)?$/ do |should, modelo, nombre|
# there will not be a course "Ruby Introduction" in the db
  sleep(1) #selenium
  model = modelo.to_unquoted.to_model
  conditions = if nombre
    {:conditions => [ "#{field_for(model, 'nombre')}=?", nombre ]}
  else
    {}
  end
  resources = model.find(:all, conditions)
  resources.size.send not_shouldify(should), be_zero
#  shouldify.send should, (resources.size.should == numero.to_number)
  if resources.size > 0
    pile_up (resources.size == 1 ? resources.first : resources)
  end
end

# there will not be a course with location "Ruby Introduction" in the db
Then /^there (will not|will) be a #{model_names} with (.+) (?:['"](.+)["'])?(?: in the db)?$/ do |should, modelo, campo, valor|

sleep 1

  model = modelo.to_unquoted.to_model
  resources = model.find(:all, {:conditions => [ "#{campo}=?", valor ] })
  resources.size.send not_shouldify(should), be_zero
#  shouldify.send should, (resources.size.should == numero.to_number)
  if resources.size > 0
    pile_up (resources.size == 1 ? resources.first : resources)
  end
end

#mundo pepino this step reloads the last mentinoned the one like this
#tiene en bbdd como nombre foto "martin-sanchez-lopez.jpg" doesn't
#for example, after uploading an image, to check that is was uploaded for that model
#we need to use this step not the next one
#maybe we should add
#add_resource_from_database(modelo, nombre)
#to the step
#Then /^#{tiene_en_bbdd} como (.+) "(.+)"(?: \w+)?$/ do |campo, valor|
#?
Then /^(?:el|la) (.+) "(.+)" #{tiene_en_bbdd} como (.+) "(.+)"(?: \w+)?$/ do |modelo, nombre, campo, valor|
  add_resource_from_database(modelo, nombre)
  last_mentioned_should_have_value(campo, valor.to_real_value)
end

#I've added the method add_resource_from_database(modelo, nombre) 
#so that it can check for attributes that have recently changed
#Then /^#{tiene_en_bbdd} como (.+) "(.+)"(?: \w+)?$/ do |campo, valor|
#  last_mentioned_should_have_value(campo, valor.to_real_value)
#end

Then /^(?:el|la) (.+) "(.+)" #{tiene_en_bbdd} una? (.+) "(.+)"$/ do |padre, nombre_del_padre, hijo, nombre_del_hijo|
  add_resource_from_database(padre, nombre_del_padre)
  last_mentioned_should_have_child(hijo, nombre_del_hijo)
end

Then /^#{tiene_en_bbdd} una? (.+) "(.+)"$/ do |hijo, nombre_del_hijo|
  last_mentioned_should_have_child(hijo, nombre_del_hijo)
end


### parches ####
articulo_definido = '(?:los|las|el|la)?'
articulo_indeterminado = '(?:unos|unas|un|una)?'
##GIVENS

#vistiar member pages
Given /^que estoy en su pagina de datos profesionales$/ do
  resource = last_mentioned
  do_visit eval("register_professional_info_#{resource.mr_singular}_path(resource)")
end

Given /^relleno el resto de campos del formulario de datos personales del abogado correctamente$/ do
   Given 'relleno "nombre" con "Juan"'
   Given 'relleno "apellidos" con "Martinez"'
   Given 'relleno "email" con "juan_martinez@gmail.com"'
   Given 'relleno "telefono" con "696123123"'
   Given 'relleno "cargo" con "Socio Abogado"'
   Given 'relleno "codigo postal" con "08001"'
   Given 'relleno "direccion" con "Diagonal 33"'
   Given 'marco las "condiciones de uso"'
end

Given /^relleno el resto de campos del formulario de datos personales del despacho correctamente$/ do
  Given 'relleno "nombre" con "Despachos"'
  Given 'relleno "email" con "juan_martinez@despacho.com"'
	Given 'relleno "telefono" con "934421098"'  
	Given 'relleno "direccion" con "Consejo de Ciento 334"'
  Given 'relleno "codigo postal" con "08001"'
	Given 'relleno "contacto" con "Juan"'  
	Given 'marco las "condiciones de uso"'
end

#LOGIN
Given /^que estoy logeado como (?:el |la |un |una )?([^\"]*)$/ do |modelo|
  user = Factory(modelo.to_model.name.underscore.to_sym)
  visit "login"
  fill_in "login", :with => user.email
  fill_in "password", :with => "secret"
  click_button "Acceder"
end

Given /^that I'm logged in$/ do
  user = Factory(:user)
  pile_up user
  visit "login"
  fill_in "login", :with => user.login
  fill_in "password", :with => "secret"
  click_button "Log in"
end

#Given /^que estoy logeado como (?:el |la )?([^\"]*) "([^\"]*)"$/ do |modelo, nombre|
Given /^that I'm logged in as (?:the)?([^\"]*) "([^\"]*)"$/ do |model, name|
  resource = last_mentioned_of(model, name)
  visit "login"
  fill_in "login", :with => resource.email
  fill_in "password", :with => "secret"
  click_button "Log in"
end

Given /^that I'm logged in as "([^\"]*)"$/ do |name|
  resource = last_mentioned_of("user", name)
  visit "login"
  fill_in "login", :with => resource.email
  fill_in "password", :with => "secret"
  click_button "Log in"
end

#Why is this method so specfici? Am I doing something wrong in my design?
#maybe the routes should have the same name?
Given /^que #{articulo_definido} (.+) tiene asociad[oa] #{articulo_definido} (?:foto|logo) "(.+)"$/ do |modelo, nombre_imagen|
  Dado "que estoy logeado como un admin"
  resource = last_mentioned_of(modelo)
  case modelo.to_model.name
  when "Firm"
    visit logo_admin_firm_url(resource)
  when "Lawyer"
    visit photo_admin_lawyer_url(resource)
  else
    raise MundoPepino::ModelNotMapped.new(modelo.to_model.name)
  end
  When "adjunto el fichero '#{nombre_imagen}' en logo"
  When 'hago click en el boton "Subir imagen"'
end

###Time Steps
Given /^que estamos a ['"]?(\d\d?) de (\w+) de (\d{4})["']? a las "([^\"]*)"$/ do |dia, mes, anio, hora|
  now = Time.now
  Time.stub!(:now).and_return(Chronic.parse("#{mes.to_month} #{dia} #{anio} at #{hora}"))
end

####

#DB STEPS
Given /^que borramos al abogado "([^\"]*)" de la base de datos$/ do |nombre|
  Lawyer.find_by_name(nombre).delete
end

#When /^me logeo como (?:ese|el) ([^\"]*)$/ do |modelo|
When /^I login as (?:ese|el) ([^\"]*)$/ do |modelo|
  resource = last_mentioned_of(modelo)
  visit "login"
  fill_in "login", :with => resource.email
  fill_in "password", :with => resource.password
  click_button "Acceder"
end

When /^I login as "([^\"]*)"$/ do |name|
  resource = last_mentioned_of("user", name)
  visit "login"
  fill_in "login", :with => resource.email
  fill_in "password", :with => "secret"
  click_button "Log in"
end

When /^I login as an admin$/ do
  resource = Factory(:admin)
  visit "login"
  fill_in "login", :with => resource.email
  fill_in "password", :with => "secret"
  click_button "Log in"
end

#"Extended to take into account multiple associations to different belongs_to models
#Not yet implemented
#Try to find a better regexp and break it into 2 steps
#Given /^que dich[ao]s? (.+) tienen? (?:el|la|los|las) siguientes? (.+):$/i do |modelo_padre, modelo_hijos, tabla|
#  if modelo_hijos == "asociaciones"
#    resource = last_mentioned_of(modelo_padre)
#    tabla.hashes.each do |hash|
#      hash.each do |attribute, value|
#        model = attribute.to_model
#        parent_resource = add_resource model, {:name => value }, :force_creation => true
#        #resource.send(model.name.underscore) = parent_resource
#        resource.save
#      end
#    end
#  else
#    if mentioned = last_mentioned_of(modelo_padre.to_unquoted)
#      children_model = modelo_hijos.to_unquoted.to_model
#      resources = (mentioned.is_a?(Array) ? mentioned : [mentioned])
#      resources.each do |resource|
#        add_resource children_model, 
#          translated_hashes(tabla.raw, parent_options(resource, children_model))
#      end
#    end
#  end
#end

#WHENS

#me logeo como el despacho "Cuatre Cases"
When /^me logeo como el (.+) "([^\"]*)"$/ do |modelo, nombre|
  resource = last_mentioned_of(modelo, nombre)
  visit "login"
  fill_in "login", :with => resource.email
  fill_in "password", :with => resource.password
  click_button "Acceder"
end

#voy a la pagina de administracion del despacho "Faus"
When /^voy a la pagina de (.+) del (.+) "([^\"]*)"$/ do |accion, modelo, nombre|
  action = accion.to_member_action or raise(MundoPepino::MemberActionNotMapped.new(accion))
  resource = last_mentioned_of(modelo, nombre)
  #hmm.. mr_singular not definied for When steps?
  visit eval("#{action}_#{resource.class.name.underscore}_path(resource)")
end



#Muy especifico
#habria que definir los campos en algo como to_url?
When /^relleno el formulario de contato correctamente$/ do 
  When "hago click en el enlace \"Contacto\""
  When "relleno \"nombre\" con \"Juan\""
  When "relleno \"email\" con \"juan@gmail.com\""
  When "relleno \"asunto\" con \"Me interesan sus servicios\""
  When "relleno \"mensaje\" con \"Por favor pongase en contacto conmigo\""
end

#en la seccion "oficinas" hago click en el enlace "Palma De Mallorca"
#cambiar, suena mejor
#hago click en el enlace "Palma De Mallorca" en la seccion "oficinas" 
#When /^en la seccion "([^\"]*)" (?:pulso|pincho|hago click) (?:en )?el (enlace|enlace ajax|enlace con efectos) (.+)$/ do |seccion, tipo, enlace|
When /^I click on (ajax link|link) "([^\"]*)" next to #{model_names} "([^\"]*)"$/ do |link_type, link_text, model_class, model_name|
  model = model_class.to_model
  resource = model.find_by_name(model_name)
  #hmm, solo me deja pasar dos parametros, no puedo pasar las opciones
  click_link_within("##{resource.class.name.underscore}_#{resource.id}", link_text)
end


#Selenium
When /^I confirm the "([^\"]*)" prompt$/ do |message|
  selenium.get_confirmation.should == unquote(message)
end

#THENS

#comprobacion en base de datos de atributos de un modelo desde fit table
#Then tenemos la siguiente oficina

#Then /^(?:tenemos|tendremos) #{articulo_definido} siguiente (.+):$/ do |modelo, tabla|
Then /^(?:there will be|we will have) the following (.+)(?: in the db)?:$/ do |model_name, table|
  sleep(1) #selenium
  model = model_name.to_model
  resource = model.last #hmm, aqui igual un modelo en plan, last_model_of(model) que haga un model.last y si no suelte una excepcion de que no hay ninguno recurso para este modelo
  pile_up resource #extract these three steps to a method
  table.hashes.each do |hash|
    hash.each do |attribute, value|
      column = model.columns.select{ |column| column.name == attribute }.first
      value = value.to_i if column.type == :integer
      value = value.to_date if column.type == :date
      resource.send(attribute).should == value
    end
  end
end

#comprobacion de has_many desde fit table 
#estará asociado a los siguientes idiomas:
Then /^estará asociado a #{articulo_definido} siguientes (.+):$/ do |child, tabla|
  tabla.hashes.each do |hash|
    hash.each do |attribute, value|
      last_mentioned_should_have_child(child, value)
    end
  end
end

#Merge with the step above
#supongo que Then seria:
#should have_child(child, value)
#y
#should_not have_child(child, value)
#comprobacion de no has_many desde fit table 
#no estará asociado a los siguientes idiomas:
Then /^no estará asociado a #{articulo_definido} siguientes (.+):$/ do |child, tabla|
  tabla.hashes.each do |hash|
    hash.each do |attribute, value|
      last_mentioned_should_not_have_child(child, value)
    end
  end
end

#comprobacion de belongs_to desde fit table
#tendrá las siguientes asociaciones:
#Then /^(?:tendr[aá]|con)? las siguientes asociaciones:$/ do |tabla|
#that registration will have the following associations:
Then /^that #{model_names} will have the following associations:$/ do |model_name, tabla|  
  tabla.hashes.each do |hash|
    hash.each do |attribute, value|
      last_mentioned_should_have_parent(attribute, value)
    end
  end
end

Then /^it will be associated to the #{model_names} with (.+) "([^\"]*)"$/ do |parent_model, field, value|
  last_mentioned_should_have_parent(parent_model, value, field)
end


Then /^veré el mensaje de error "([^\"]*)"$/ do |mensaje|
  #TODO: dentro de el div de errores
  response.should contain(mensaje)
end

#tendremos una cuenta con email "juan_martinez@gmail.com"

Then /^(?:tendremos|tenemos) #{articulo_indeterminado} (.+) con (.+) "([^\"]*)"$/ do |modelo, campo, valor|
  model = model_for(modelo)
  resource = model.last #hmm, aqui igual un modelo en plan, last_model_of(model) que haga un model.last y si no suelte una excepcion de que no hay ninguno recurso para este modelo
  pile_up resource #extract these three steps to a method
  resource.send(campo).should == real_value_for(valor)
end

#sere redirigido a la pagina de administracion del despacho
estare_en = '(?:sere redirigido a|estar[eé] en)'
will_be_in = '(?:I will be redirected to|I will be in|I will be at)'
Then /^#{estare_en} (.+) page of the ([^\"]+)$/ do |accion, model|
  action = accion.to_member_action or raise(MundoPepino::MemberActionNotMapped.new(accion))
  resource = last_mentioned_of(model)
  URI.parse(current_url).path.should == eval("#{action}_#{resource.mr_singular}_path(resource)")
end

#I will be at the edit page of user "Hector"
#Then /^#{estare_en} la pagina de (.+) del (.+) "([^\"]*)"$/ do |accion, model, nombre|
Then /^#{will_be_in} the (.+) page of (.+) "([^\"]*)"$/ do |accion, model, nombre|
  action = accion.to_crud_action or raise(MundoPepino::MemberActionNotMapped.new(accion))
  resource = last_mentioned_of(model, nombre)
  URI.parse(current_url).path.should == eval("#{action}_#{resource.class.name.underscore}_path(resource)")
end

#sere redirigido a la pagina del despacho "Faus"
Then /^#{estare_en} la pagina (?:del|de la) (.+) "([^\"]*)"$/ do |modelo, nombre|
  resource = last_mentioned_of(modelo, nombre)
  URI.parse(current_url).path.should == eval("#{resource.class.name.underscore}_path(resource)")
end

#sere redirigido a "/login"
#Then /^#{estare_en} "(.+)"$/ do |pagina|
Then /^#{will_be_in} "(.+)"$/ do |page|
  URI.parse(current_url).path.should == page.to_unquoted.to_url
end

#Vista sin utilizar tablas solo ids
#Then /^vere las siguientes (.+):$/ do |modelo, table|
#  
#end
#

#la oficina tiene en bbdd como direccion "Avda. Diagonal. 550"
Then /^#{articulo_definido} ([^\"]+) #{tiene_en_bbdd} como (.+) "(.+)"(?: \w+)?$/ do |modelo, campo, valor|
  add_last_resource_from_database_of(modelo)
  last_mentioned_should_have_value(campo, valor.to_real_value)
end

Then /^#{articulo_definido} (.+) no tendr[aá] ninguna? (.+)$/ do |modelo, modelo_hijo|
  add_last_resource_from_database_of(modelo)
  last_mentioned_should_not_have_child(modelo_hijo)
end


#comprobacion de un recurso hijo desde fit-table
#dicha oficina tendra en bbdd el siguiente abogado:
#Then /^dich[oa] (.+) tendr[áa] #{articulo_definido} siguientes? (.+):$/ do |modelo, modelo_hijo, tabla|
#that registration will be associated with the following course:
Then /^that (.+) will be associated (?:to|with) the following (.+):$/ do |modelo, modelo_hijo, tabla|
  add_last_resource_from_database_of(modelo)
  resource = last_mentioned_of(modelo) 
  child_model = modelo_hijo.to_unquoted.to_model
  tabla = translated_hashes(tabla.raw, :model => child_model)
  tabla.each do |hash|
    #this works with STI
    child = resource.send(child_model.name.underscore.downcase.pluralize).find_by_name(hash["name"])
    hash.each do |attribute, value|
      child.send(attribute).should == real_value_for(value)
    end
  end
end


#not used yet
Then /^vere los siguientes (.+) dentro de la seccion "([^\"]*)"$/ do |modelo, seccion, tabla|
  model = modelo.to_unquoted.to_model
  tabla = translated_hashes(tabla.raw, :model => model)
  within("##{seccion}") do |html|
    tabla.each do |hash|
      resource = resource.find_by_name(hash['name'])
      html.should have_tag("##{modelo.name}_#{resource.id}") do
        hash.each do |attribute, value|  
          with_tag("##{modelo.name}_#{resource.id}_#{atributo}", real_value_for(value))
        end
      end
    end
  end
end


#comprobacion del valor de una etiqueta la vista utilizando el nombre del campo como id
#vere que la "web" del despacho de la abogado es "http://www.herrero-abogados.com"
Then /^ver[eé] que #{articulo_definido} "(.+)" (?:del|de la|de el|) (.+) (?:son|es) "(.+)"$/ do |atributo, modelo, valor|
  model_name = modelo.to_model.name.underscore
  if has_tag?("##{model_name}")
    
    response.body.should have_tag("##{model_name}") do |html|
      case atributo
      when "foto", "logo"
        within("##{model_name}_#{atributo.to_field}") do |div_imagen|
          div_imagen.should have_tag("img[src*=#{real_value_for(valor)}]")
        end
      else
        html.should have_tag("##{model_name}_#{atributo.to_field}", real_value_for(valor))
      end
    end
  else
    response.body.should have_tag("##{modelo}_#{@producto.id}") do |html|
      case atributo
      when "foto", "logo"
        within("##{modelo}_#{@producto.id}_#{atributo}") do |div_imagen|
          div_imagen.should have_tag("img[src*=#{valor}]")
        end
      else
        html.should have_tag("##{modelo}_#{@producto.id}_#{atributo}", /#{valor}/)
      end
    end
  end
end


Then /^ver[eé] los atributos de (.+) "(.+)"$/ do |modelo, atributos|
  if has_tag?("##{modelo}")
    split_and_strip(atributos).each do |atributo|
      response.body.should have_tag("##{modelo}") do
          with_tag("##{modelo}_#{atributo}")
      end
    end
  else
    response.body.should have_tag("##{modelo}_#{@producto.id}") do
      split_and_strip(atributos).each do |atributo|
        case atributo
        when "color", "capacidad"
          propiedad = Propiedad.find_by_nombre(atributo)
          especificacion = Especificacion.find_by_producto_id_and_propiedad_id(@producto.id, propiedad.id)
          with_tag("##{modelo}_#{@producto.id}_especificacion_#{especificacion.id}_valor")
        when "cantidad"
          with_tag("#linea_pedido_#{atributo}")
        else
          with_tag("##{modelo}_#{@producto.id}_#{atributo}")
        end
      end
    end
  end
end

#mapear collection routes al igual que member routes
#por ejemplo este collection route
#cuando visito la pagina de abogados pendientes
#deberia traducirse a /abogados/pendientes
#o mejor aun en ingles
#/lawyers/pending
#otro caso similar
#cuando visito la pagina de casas recomendadas
#/casas/recomendadas
#es un collection => {:recomendadas => :get}

#find a way to load this automatically

#vere a el abogado "Ana, Juana"
Then /^(#{veo_o_no}) (?:al|a el|el|a la|la) #{model_names} "([^\"]*)"$/ do |should, modelo, nombre|
  model_name = modelo.to_model.name.underscore
  resource = modelo.to_model.find_by_name(nombre)
  response.body.send shouldify(should), have_tag("##{model_name}_#{resource.id}")
end

#vere a los abogado "Ana, Juana"
#Then /^(#{veo_o_no}) (?:a )?(?:los|las) #{model_names} "([^\"]*)"$/ do |should, modelo, nombres|
Then /^I will (not see|see) the #{model_names} "([^\"]*)"$/ do |should, modelo, nombres|
  model_name = modelo.to_model.name.underscore
  split_and_strip(nombres).each do |nombre, index|
    resource = modelo.to_model.find_by_name(nombre)
    response.body.send shouldify(should), have_tag("##{model_name}_#{resource.id}")
  end
end

#vere a la abogado "Ana" en la seccion "otros"
Then /^(#{veo_o_no}) (?:al|a el|a la) #{model_names} "([^\"]*)" en la seccion "([^\"]*)"?$/ do |should, modelo, nombre, seccion|
#I will see the course templates "Ruby Intro and Ruby on Rails" in the section "results"
#plurals are not said the same in english
#Then /^I (will not|will) see the #{model_names} "([^\"]*)" in the section "([^\"]*)"?$/ do |should, modelo, nombre, seccion|
  model_name = modelo.to_model.name.underscore
  resource = modelo.to_model.find_by_name(nombre)
  within("##{real_value_for(seccion)}") do |html|
    html.send shouldify(should), have_tag("##{model_name}_#{resource.id}")
  end
end

#vere a los abogado "Ana, Juana" en la seccion "abogados"
#Then /^(#{veo_o_no}) (?:a) (?:los|las) #{model_names} "([^\"]*)" en la seccion "([^\"]*)"?$/ do |should, modelo, nombres, seccion|
#I will see the course templates "Ruby Intro and Ruby on Rails" in the section "results"
Then /^I (will not|will) see the #{model_names} "([^\"]*)" in the section "([^\"]*)"?$/ do |should, modelo, nombres, seccion|
  model_name = modelo.to_model.name.underscore
  within("##{real_value_for(seccion)}") do |html|
    split_and_strip(nombres).each do |nombre|
      resource = modelo.to_model.find_by_name(nombre)
      html.send shouldify(should), have_tag("##{model_name}_#{resource.id}")
    end
  end
end

#vere a los abogado "Ana, Juana" en la seccion "abogados" en ese orden
Then /^(#{veo_o_no}) (?:a) (?:los|las) ([^\"]+) "([^\"]*)" en la seccion "([^\"]*)"? en ese orden$/ do |should, modelo, nombres, seccion|
  model_name = modelo.to_model.name.underscore
  within("##{real_value_for(seccion)}") do |html|
    split_and_strip(nombres).each_with_index do |nombre, index|
      resource = modelo.to_model.find_by_name(nombre)
      html.send shouldify(should), have_tag("##{model_name}_#{resource.id}:nth-child(#{index+1})")
    end
  end
end

#vere a los abogado "Ana, Juana" en ese orden
#Then /^(#{veo_o_no}) (?:a) (?:los|las) ([^\"]+) "([^\"]*)" en ese orden$/ do |should, modelo, nombres|
#I will see the regions "Islas Baleares, Comunidad Valenciana" in that order
Then /^I (will not|will) see (?:the )?([^\"]+) "([^\"]*)" in that order$/ do |should, modelo, nombres|
  model_name = modelo.to_model.name.underscore
  split_and_strip(nombres).each_with_index do |nombre, index|
    resource = modelo.to_model.find_by_name(nombre)
    response.body.send shouldify(should), have_tag("##{model_name}_#{resource.id}:nth-child(#{index+1})")
  end
end

#vere los campos "direccion, ciudad, codigo postal y areas de practica" para el despacho "Faus"
Then /^vere los campos "([^\"]*)" para #{articulo_definido} (.+) "([^\"]*)"$/ do |campos, modelo, nombre|
  model_name = modelo.to_model.name.underscore
  resource = modelo.to_model.find_by_name(nombre)
  response.body.should have_tag("##{model_name}_#{resource.id}") do
    split_and_strip(campos).each do |campo|
      with_tag("##{model_name}_#{resource.id}_#{campo.to_field}")
    end
  end
end


Then /^dicho (.+) tendra #{articulo_indeterminado} (.+) a las "([^\"]*)"$/ do |modelo, modelo_hijo, creado_a|
  add_last_resource_from_database_of(modelo)
  resource = last_mentioned_of(modelo)
  child_model = modelo_hijo.to_model
  child_resource = resource.send(child_model.name.underscore.downcase.pluralize).find_by_created_at(creado_a)
  resource.send(child_model.name.underscore.downcase.pluralize).should include(child_resource)
end


#use to_member_action to make it reusable,
#think about how to find out the name of the firm,
#we probably need to identify the resource so we don't have to
#pass in the resource's name
Then /^el cuerpo contendra un link a la lista de abogados del despacho$/ do
  resource = last_mentioned_of("despacho")
  url = admin_firm_lawyers_url(@firm)
  Email.all.each {|email| email.mail.should have_tag("a[href=?]", /#{url}/) }
end

##



## MAPS
Then /^vere un google maps de la oficina$/ do
  add_last_resource_from_database_of("oficina")
  resource = last_mentioned_of("oficina")
  response.should have_tag("#office_#{resource.id}_map")
end

Then /^vere un google maps de la oficina "([^\"]*)"$/ do |nombre|
  resource = Office.find_by_name(nombre)
  response.should have_tag("#office_#{resource.id}_map")
end

Then /^vere el google map de la abogada$/ do
  response.should have_tag("#lawyer_map")
end

Then /^vere (\d+) perfiles en la seccion "([^\"]*)"$/ do |numero, seccion|
  within("##{real_value_for(seccion)}") do |html|
    html.should have_tag(".brief_profile", :count => numero.to_i)
  end
end

#


##Breadcrums 

Then /^el breadcrum sera "([^\"]*)"$/ do |breadcrums|
  response.body.should have_tag("#breadcrum") do |breadcrums_div|
    breadcrum_links = split_and_strip(breadcrums, ">")[0..-2]
    current_breadcrum = split_and_strip(breadcrums, ">")[-1]
    breadcrum_links.each_with_index do |breadcrum, index|
      breadcrums_div.should have_tag("a:nth-child(#{index+1})", breadcrum)
    end
    breadcrums_div.should have_tag("#current_breadcrum", current_breadcrum)
  end
end


#Footer
Then /^vere (\d+) #{model_names} en la seccion "([^\"]*)"$/ do |numero, modelo, seccion|
  model_name = modelo.to_model.name.singularize.underscore
  within("##{real_value_for(seccion)}") do |html|
    html.should have_tag(".#{model_name}", :count => numero.to_i)
  end
end

# Specific ones:
#I check the edition with start_date "09/09/2009"
When /^I check the #{model_names} with (.+) "([^\"]*)"$/i do |model, field, value|
  resource = model.to_model.send("find_by_#{field}", value)
  model_id = "#{model.to_model.name.underscore}_#{resource.id}"
  choose model_id
end

When /^I mark the delete checkbox for the #{model_names} with (.+) "([^\"]*)"$/i do |model, field, value|
  resource = model.to_model.send("find_by_#{field}", value)
  model_id = "#{model.to_model.name.underscore}_#{resource.id}_delete"
  check model_id
end


When /^I correctly fill out the captcha$/ do
  #save_and_open_page
end



##MAIL

Then /^an email will be sent to "([^\"]*)"$/ do |emails|
  #sleep(1)
  Email.all.map(&:to).sort.should == split_and_strip(emails).sort
end

Then /^an email will not be send$/ do
  #sleep(1)
  Email.count.should be_zero
end

Then /^the subject will be "([^\"]*)"$/ do |subject|
  Email.all.each {|email| email.mail.should have_text(/Subject: #{subject}/) }
end

Then /^the body will contain the text "([^\"]*)"$/ do |cuerpo|
  Email.all.each {|email| email.mail.should have_text(/#{cuerpo}/) }
end

##Breadcrums 

#Then /^el breadcrum sera "([^\"]*)"$/ do |breadcrums|
Then /^the breadcrumb will be "([^\"]*)"$/ do |breadcrumbs|
  response.body.should have_tag("#breadcrumb") do |breadcrumbs_div|
    breadcrumb_links = split_and_strip(breadcrumbs, ">")[0..-2]
    current_breadcrumb = split_and_strip(breadcrumbs, ">")[-1]
    breadcrumb_links.each_with_index do |breadcrumb, index|
      breadcrumbs_div.should have_tag("a:nth-child(#{index+1})", breadcrumb)
    end
    breadcrumbs_div.should have_tag("#current_breadcrumb", current_breadcrumb)
  end
end



Then /^show me the page$/ do
  save_and_open_page
end

Then /^debug$/ do
  debugger
end