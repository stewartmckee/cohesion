#!/Users/stewartmckee/.rvm/rubies/ruby-1.9.3-p362/bin/ruby

require 'rubygems'
require 'json'
require 'csv'

data = JSON.load(File.open("tyre-shopper.json").read)

CSV.open("tyre-shopper.csv" , "wb") do |csv|
  csv << ["404 Url", "Page that contains link"]
  data.each do |line|
    line["inbound_links"].each do |link|
      csv << [line["error_page"], link]
    end
  end
end
