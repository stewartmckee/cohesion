require 'cohesion'
require 'rails'

module Cohesion
  class Railtie < Rails::Railtie
    railtie_name :cohesion

    rake_tasks do
      load "tasks/cohesion.rake"
    end
  end
end