require 'bundler/setup'
require "cohesion/version"
require 'cobweb'
require 'ptools'
require 'digest/md5'

require 'cohesion/check'
require 'cohesion/cache'
require 'cohesion/railtie' if defined?(Rails)

module Cohesion

end
