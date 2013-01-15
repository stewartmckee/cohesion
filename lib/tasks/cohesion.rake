
namespace :cohesion do
  desc 'cohesion rake task'
  task :check, :url do | t, args |
    if args[:url].nil?
      puts
      puts "Usage: rake cohesion:check[url] (eg: check_links[\"http://rubyonrails.org/\"])"
    else
      Cohesion::Check.site(args[:url])
    end
    puts
  end

  desc 'test rails app for broken links'
  task :rails => :environment do
    
    Cohesion::Check.rails_text


  end
end