
# Sets up the environment as test so that exceptions are raised
ENVIRONMENT = "test"
APP_ROOT = File.expand_path(File.dirname(__FILE__) + '/../')

require "#{APP_ROOT}/lib/cohesion"

RSpec.configure do |config|
  
  
  config.before(:all) {

    Mock::Application.initialize!
  
  }
  
  config.before(:each) {
        
  }

end

