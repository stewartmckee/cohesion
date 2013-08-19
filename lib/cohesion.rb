require 'bundler/setup'
require "cohesion/version"
require 'cobweb'
require 'ptools'
require 'digest/md5'

require 'cohesion/railtie' if defined?(Rails)

module Cohesion
  class Check

    def self.rails_text
      puts "WARNING - not working yet..."
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
      puts "WARNING - not working yet..."
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

    def self.site(url, options={})
      errors = []
      failures = []

      pages = {}

      options[:cache] = options[:cache].to_i if options[:cache]
      crawler_options = {:cache_type => :full, :crawl_linked_external => true, :store_inbound_links => true}.merge(options)

      statistics = CobwebCrawler.new(crawler_options).crawl(url) do |page|
        print page[:url]

        duplicate = !pages[Digest::MD5.hexdigest(page[:body])].nil?
        pages[Digest::MD5.hexdigest(page[:body])] = [] unless pages[Digest::MD5.hexdigest(page[:body])]
        pages[Digest::MD5.hexdigest(page[:body])] << page[:url]

        # if it was a 404 before, just check again not using the cache this time
        if page[:status_code] == 404
          page = Cobweb.new(crawler_options.merge(:cache => nil)).get(page[:url])
        end

        if page[:status_code] == 404 || duplicate
          if duplicate
            puts " [duplicate] \e[31m\u2717\e[0m"
          else
            puts " [#{page[:status_code]}] \e[31m\u2717\e[0m"
          end
          failures << page
        else
          puts " \e[32m\u2713\e[0m"
        end
      end

      puts statistics.redis.namespace
      puts statistics.get_statistics

      total_inbound_failures = 0
      total_failures = 0

      issues = []
      if failures.count == 0
        puts "All links working!"
      else
        puts "Failed urls:"
        failures.each do |f|
          inbound_links = statistics.inbound_links_for(f[:url])
          issues << {:issue => f, :inbound => inbound_links}

          total_inbound_failures += inbound_links.count
          total_failures += 1

          puts ""
          puts "#{f[:url]} [ #{f[:status_code]} ]"
          inbound_links.each do |inbound_link|
            puts "  - #{inbound_link}"
          end
        end

        puts ""
        puts "Duplicate Content"
        puts ""
        pages.select{|k,v| v.count > 1}.each do |k,v|
          puts "Duplicate: #{k}"
          v.map{|x| puts "  - #{x}" }
        end


        puts ""
        puts "Total Failed URLs: #{total_failures}"
        puts "Total Duplicates: #{pages.map{|d| d[1]}.select{|d| d.count > 1}.inject{|total, d| total + d.count}.count}"
        puts "Total Inbound Failures (Pages linking to a 404): #{total_inbound_failures}"
        puts ""
      end
      puts

      return issues
    end
  end
end
