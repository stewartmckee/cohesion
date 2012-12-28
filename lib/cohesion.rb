require "cohesion/version"

Dir["tasks/**/*.rake"].each { |ext| load ext } if defined?(Rake)

module Cohesion
  class Check
  end
end
