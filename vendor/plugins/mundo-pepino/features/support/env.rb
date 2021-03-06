# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + '/app/config/environment')
require 'cucumber/rails/world'

require 'cucumber/formatter/unicode' # Comment out this line if you don't want Cucumber Unicode support
Cucumber::Rails.use_transactional_fixtures

# Comment out the next two lines if you're not using RSpec's matchers (should / should_not) in your steps.
require 'cucumber/rails/rspec'
require 'webrat/core/matchers'

Cucumber::Rails.bypass_rescue # Comment out this line if you want Rails own error handling
                              # (e.g. rescue_action_in_public / rescue_responses / rescue_from)
require 'mundo_pepino'
require 'webrat/rails'

Webrat.configure do |config|
  config.mode = :rails
end

MundoPepino::ModelsToClean = [
  Orchard,
  Terrace,
  Crop,
  Fertilizer,
  Tomato,
  Chard,
  Pepino,
  Lettuce,
  Sprinkler
]

String.model_mappings = {
  /^huert[oa]s?$/i            => Orchard,
  /^bancal(es)?$/i            => Terrace,
  /^cultivos?$/i              => Crop,
  /^(abono|fertilizante)s?$/i => Fertilizer,
  /^tomates?$/i		            => Tomato,
  /^acelgas?$/i		            => Chard,
  /^pepinos?$/i		            => Pepino,
  /^aspersor(es)?$/i          => Sprinkler,
  /^lechugas?$/i              => Lettuce,
  /^huerto de nacimiento$/i   => Orchard
}

String.field_mappings = {
  /^[Ááa]reas?$/i    => :area,
  /^color(es)?$/i   => :color,
  /^latitud(es)?$/i => :latitude,
  /^longitud(es)?/i => :length,
  /^pesos?/i        => :weight,
  /^di[áa]metros?/i => :diameter,
  /^matas?$/i       => :plants,
  /^variedad(es)?$/i           => :variety,
  /^campos? de texto/i         => :text_field,
  /^[áa]reas? de texto/i       => :textarea,
  /^tipos? de cultivos?/i      => :orchard_type,
  /^nacionalidad/i             => :nationality,
  /^fichero adjunto/i          => :file_field,
  /^casilla seleccionada/i     => :selected_check,
  /^casilla sin seleccionar/i  => :unselected_check,
  /^Orchard::longitud(es)?$/   => :longitude,
  /^cultivad[oa]$/             => :cultivated,
  /^caudal(es)?$/i             => :flow,
  /^unidad(es)? caudal(es)?$/i => :flow_units,
  /^estaci[oó]n(es)?$/i        => :season,
  /^huerto de nacimiento$/i    => :orchard_of_birth,
  /^hora de comenzar a regar$/i => :start_watering,
  /^hora de terminar de regar$/i => :stop_watering,
  /^precio$/i                  => :price
}

String.relation_model_mappings = {
  /^orchard_of_birth$/i => Orchard
}

String.url_mappings.merge!(
  /^la página de registro/i    => '/welcome/signup'
)

Before do
  MundoPepino::ModelsToClean.each { |model| model.destroy_all }
end

module MundoPepino
  include FixtureReplacement
end

World(MundoPepino)
