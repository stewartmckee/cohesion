
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
end