require "cohesion/version"
require 'cobweb'

Dir["tasks/**/*.rake"].each { |ext| load ext } if defined?(Rake)

module Cohesion
  class Check
    def self.site(url)
      errors = []
      failures = []
      CobwebCrawler.new(:cache => 600, :cache_type => :full, :crawl_linked_external => true).crawl(url) do |page|
        print page[:url]
        if page[:status_code] > 399
          puts " [#{page[:status_code]}] \e[31m\u2717\e[0m"
          failures << page
        else
          puts " \e[32m\u2713\e[0m"
        end
      end

      if failures.count == 0
        puts "All links working!"
      else
        puts "Failed urls:"
        failures.map{|f| puts "  -  #{f[:url]} [ #{f[:status_code]} ]"}
      end
      puts

      failures
    end
  end
end
