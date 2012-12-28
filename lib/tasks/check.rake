
namespace :cohesion do
  desc 'cohesion rake task'
  task :check, :url do | t, args |
    if args[:url].nil?
      puts
      puts "Usage: rake cohesion:check[url] (eg: check_links[\"http://rubyonrails.org/\"])"
    else
      errors = []
      failures = []
      CobwebCrawler.new(:cache => 600, :cache_type => :full, :crawl_linked_external => true).crawl(args[:url]) do |page|
        print page[:url]
        if page[:status_code] > 399
          puts " [#{page[:status_code]}] \e[31m\u2717\e[0m"
          failures << page
        else
          puts " \e[32m\u2713\e[0m"
        end
      end

      puts 
      if failures.count == 0
        puts "All links working!"
      else
        puts "Failed urls:"

        failures.map{|f| puts "  -  #{f[:url]} [ #{f[:status_code]} ]"}
        puts 
      end
    end
    puts
  end
end