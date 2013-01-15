require "cohesion/version"
require 'cobweb'
require 'ptools'

require 'cohesion/railtie' if defined?(Rails)

module Cohesion
  class Check

    def self.rails_text
      root_path = Rails.root.to_s
      Dir.glob("**/*").each do |filename|
        unless File.directory?(filename) || File.binary?(filename) || filename.ends_with?(".rdb")
          f = File.open(filename, "r")
          content = f.read()
          f.close
          if content =~ /(https?:\/\/[a-zA-Z0-9\.\/\-_%&\?]+)/
            print "Checking #{$1} "
            begin
              status_code = Cobweb.new(:raise_exceptions => true).head($1)[:status_code].to_i
              if status_code != 200
                puts " [#{status_code}] \e[31m\u2717\e[0m"
              else
                puts "\e[32m\u2713\e[0m"
              end
            rescue SocketError
              status_code = 0
              puts " [DNS Failed] \e[31m\u2717\e[0m"
            end
          end
        end
      end
    end

    def self.rails_object
      root_path = Rails.root.to_s
      #app_name = Rails.application.name
      #puts "Checking #{app_name}..."
      app = CobwebSample::Application
      app.routes.default_url_options = { :host => 'xxx.com' }

      Dir.glob("app/controllers/**/*").each do |filename|
        controller_name = filename.gsub(".rb","").split("/")[-1].classify
        unless controller_name == "ApplicationController"
          puts "Processing #{controller_name}"
          controller = controller_name.constantize.new

          view = ActionView::Base.new(ActionController::Base.view_paths, {}, controller)

          view.view_paths = ActionController::Base.view_paths
          view.extend ApplicationHelper
          view.controller = controller
          view.class_eval do
            include ApplicationHelper
            include app.routes.url_helpers
          end
          begin
            puts view.render(:template => '/tests/index.html.erb')
          rescue => e
            puts "Error rendering view: #{e.message}" 
          end
        end
      end
    end

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
