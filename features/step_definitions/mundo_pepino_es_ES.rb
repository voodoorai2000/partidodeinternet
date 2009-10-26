require 'mundo_pepino_es_ES'

Webrat.configure do |config|
  config.mode = :rails
end

MundoPepino::ModelsToClean = [
    # ENTRADA AUTO-GENERADA PARA Orchard
    Orchard, # (TODO: quitar la coma final si es el primer modelo)

  # MODELOS PARA LIMPIAR antes de cada escenario,
  # por ejemplo:
  # Orchard, Terrace, Crop...
]

String.model_mappings = {
  # MAPEO DE MODELO AUTO-GENERADO (Orchard)
  /^huertos?$/i => Orchard, # (TODO: validar RegExp para forma plural y coma final)

  # TRADUCCIÓN DE MODELOS AQUÍ, por ejemplo:
  # /^huert[oa]s?/i            => Orchard,
  # /^bancal(es)?$/i           => Terrace,
  # /^cultivos?$/i             => Crop...
}

String.field_mappings = {
  # MAPEO DE CAMPO AUTO-GENERADO (used)
  /^usados?$/i => :used, # (TODO: validar RegExp para forma plural y coma final)

  # MAPEO DE CAMPO AUTO-GENERADO (latitude)
  /^latitud(es)?$/i => :latitude, # (TODO: validar RegExp para forma plural y coma final)

  # MAPEO DE CAMPO AUTO-GENERADO (longitude)
  /^longitud(es)?$/i => :longitude, # (TODO: validar RegExp para forma plural y coma final)

  # MAPEO DE CAMPO AUTO-GENERADO (area)
  /^áreas?$/i => :area, # (TODO: validar RegExp para forma plural y coma final)

  # MAPEO DE CAMPO AUTO-GENERADO (name)
  /^nombres?$/i => :name, # (TODO: validar RegExp para forma plural y coma final)

  # TRADUCCIÓN DE CAMPOS AQUÍ:
  # /^[Ááa]reas?$/i    => 'area',
  # /^color(es)?$/i   => 'color',
  # /^latitud(es)?$/i => 'latitude',
  # /^longitud(es)?/i => 'length'
  #
  # TRADUCCIÓN ESPECÍFICA PARA UN MODELO
  # /^Orchard::longitud(es)?$/   => 'longitude'
}


Before do
  MundoPepino::ModelsToClean.each { |model| model.destroy_all }
end

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
