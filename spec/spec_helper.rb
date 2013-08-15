
# Sets up the environment as test so that exceptions are raised
ENVIRONMENT = "test"
APP_ROOT = File.expand_path(File.dirname(__FILE__) + '/../')

require 'coveralls'
Coveralls.wear!

require "#{APP_ROOT}/lib/cohesion"
require 'rake'

RSpec.configure do |config|
  
  
  config.before(:all) {

    
  
  }
  
  config.before(:each) {
        
  }

end

