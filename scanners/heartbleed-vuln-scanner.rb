#!/usr/bin/env ruby
#
# heartbleed-vuln-scanner.rb
# --------------------------------
# Author: Brandon <zeknox> McCann
# --------------------------------

# ruby gems
require 'nokogiri'
require 'open-uri'

# ensure argument has been passed
unless ARGV.length == 1
  puts "\n\rUSAGE: ./heartbleed-vuln-scanner.rb <ips.txt>\n\r"
  exit!
end

# make http request and parse with nokogiri
def http_request(host)
  begin
    response = Nokogiri::HTML(open("http:\/\/bleed-1161785939.us-east-1.elb.amazonaws.com\/bleed\/#{host}"))
    display_result(response, host)
  rescue
    puts "[-] #{host}: Issues connecting to site"
  end
end

# display results to stdout
def display_result(response, host)
  if response.to_s.include? "\"code\":0"
    puts "[+] #{host}: Vulnerable"
  else
    puts "[-] #{host}: Not Vulnerable"
  end
end

# read file and http request each ip
File.open(ARGV[0], "r") do |f|
  f.each_line do |ip|
    http_request(ip.chomp)
  end
end