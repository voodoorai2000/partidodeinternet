# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'

require 'webrat/rails'

# Comment out the next two lines if you're not using RSpec's matchers (should / should_not) in your steps.
require 'cucumber/rails/rspec'
#require 'webrat/rspec-rails'

require 'mundo_pepino'
require 'chronic'
require 'spec/mocks'

#ActionController::Base.allow_rescue = false

String.add_mapper(:crud_action,
  /^edit$/i                  => 'edit',
  /^alta$/i                  => 'new',
  /^creaci[óo]n$/i           => 'new',
  /^nuev(?:o|a|o\/a|a\/o)$/i => 'new',
  /^cambio$/i                => 'edit',
  /^modificaci[oó]n(?:es)?$/i       => 'edit',
  /^edici[oó]n$/i            => 'edit',
  /^administracion del despacho$/ => 'admin',
  /^administracion del abogado$/ => 'admin')
  
String.add_mapper(:member_action,
  /^administracion$/i        => 'admin')
  
String.add_mapper(:real_value, {
  /^pendientes?$/i => "pending",
  /^verificado$/i  => "verified",
  /^rechazado$/i   => "rejected",
  /^otros$/i       => "other",
  /^abogados$/     => "lawyers",
  /^despachos$/    => "firms",
  /^todos$/        => "all",
  /^oficinas$/     => "offices",
  /^ultimas altas$/           => "recent_registrations",
  /^Ciudades Destacadas$/     => "main_cities",
  /^Provincias Destacadas$/   => "main_provinces",
  /^Abogados de España$/   => "random_lawyers_in_country",
  /^Despachos de España$/   => "random_firms_in_country",
  /^Abogados por ciudad$/   => "random_lawyers_in_cities",

}) { |value| value }

String.add_mapper(:month,
  :enero           => 'January',
  :febrero         => 'February',
  :marzo           => 'March',
  :abril           => 'April',
  :mayo            => 'May',
  :junio           => 'June',
  :julio           => 'July',
  :agosto          => 'August',
  /^sep?tiembre$/i  => 'September',
  :octubre         => 'October',
  :noviembre       => 'November',
  :diciembre       => 'December')


String.add_mapper(:number, { 
  /^(the|a)$/i     => 1
}) { |string| string.to_i }
    
    
String.add_mapper(:url, {
 /^la (portada|home|pagina principal)/i => '/index',
 /^la pagina de abogados pendientes$/i => "/lawyers/pending",
 /^login$/i => "/login"
}) do |string| 
   string if string =~ /^\/.*$|^https?:\/\//i
end

MundoPepino::ModelsToClean = [
    # ENTRADA AUTO-GENERADA PARA Orchard
    
    # (TODO: quitar la coma final si es el primer modelo)

  # MODELOS PARA LIMPIAR antes de cada escenario,
  # por ejemplo:
  # Orchard, Terrace, Crop...
]

String.add_mapper(:model, {
  #/^pendientes?$/i => "pending",
 

}) { |model| model.gsub(" ","_").classify.constantize rescue nil }


String.model_mappings = {
  # MAPEO DE MODELO AUTO-GENERADO (Orchard)
  
  # TRADUCCIÓN DE MODELOS AQUÍ, por ejemplo:
  #  /^requests?$/i                => Petition,
    

    
  # /^huert[oa]s?/i            => Orchard,
  # /^bancal(es)?$/i           => Terrace,
  # /^cultivos?$/i             => Crop...
} 

String.field_mappings = {
  # MAPEO DE CAMPO AUTO-GENERADO (used)
  # MAPEO DE CAMPO AUTO-GENERADO (name)
 # (TODO: validar RegExp para forma plural y coma final)

  # TRADUCCIÓN DE CAMPOS AQUÍ:
    #abogado
    #/^subcategory$/        => :photo_file_name,
    
    # /^[Ááa]reas?$/i    => 'area',
  # /^color(es)?$/i   => 'color',
  # /^latitud(es)?$/i => 'latitude',
  # /^longitud(es)?/i => 'length'
  #
  # TRADUCCIÓN ESPECÍFICA PARA UN MODELO
  #
   #/^Lawyer::nombre foto$/   => 'photo_file_name',
   #/^Firm::nombre logo$/     => 'photo_file_name'
  ## /^Lawyer::nombre$/   => 'name',
  # 
  # /^Firm::nombre$/   => 'name',

}

Before do
  MundoPepino::ModelsToClean.each { |model| model.destroy_all }
  $rspec_mocks ||= Spec::Mocks::Space.new
  empty_database
end

After do
  begin
    $rspec_mocks.verify_all
  ensure
    $rspec_mocks.reset_all
  end
end

Before('@sphinx') do
  system "rake thinking_sphinx:stop RAILS_ENV=development > /dev/null"
  system "rake thinking_sphinx:start > /dev/null"
end

After('@sphinx') do
  system "rake thinking_sphinx:stop > /dev/null"
  system "rake thinking_sphinx:start RAILS_ENV=development > /dev/null"
end


def empty_database
  connection = ActiveRecord::Base.connection
  connection.tables.each do |table|
    connection.execute "DELETE FROM #{table}" 
  end
end


require 'factory_girl'
require File.expand_path(File.dirname(__FILE__) + '../../../db/factories')

#module MundoPepino
#  # Helpers específicos de nuestras features que necesiten estar 
#  # "incluidos" (no extendidos), por ejemplo:
#  include FixtureReplacement # probado!
#  include Machinist # probado!
#end
# # Si utilizas factory_girl # probado!
# require 'factory_girl'
# #Definición de las factorias equivalente a example_data.rb en fixture_replacement
# require File.expand_path(File.dirname(__FILE__) + '/app/db/factories')

World(MundoPepino)
