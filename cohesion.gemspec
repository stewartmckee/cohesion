# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cohesion/version'

Gem::Specification.new do |gem|
  gem.name          = "cohesion"
  gem.version       = Cohesion::VERSION
  gem.authors       = ["Stewart McKee"]
  gem.email         = ["stewart@theizone.co.uk"]

  gem.description   = %q{Gem to test the cohesion of links within a rails site.  The gem crawls the site and checks that external and internal links are valid}
  gem.summary       = %q{Gem to test the cohesion of links within a rails site.}
  gem.homepage      = "http://github.com/stewartmckee/cohesion"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  #gem.add_dependency "cobweb"
  
end
