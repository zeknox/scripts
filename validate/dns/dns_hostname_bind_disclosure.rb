#!/usr/bin/env ruby
#
# dns_hostname_bind_disclosure.rb
# --------------------------------
# Author: Brandon <zeknox> McCann
# --------------------------------
#
# attempt to obtain hostname through dns info disclosure
# vulnerability 

# ensure argument has been passed
unless ARGV.length == 1
  puts "\n\rUSAGE: ./dns_hostname_bind_disclosure.rb <ips.txt>\n\r"
  exit!
end

# send dns_request
def dns_request(ip)
  puts "[*] Testing #{ip}"
  system("dig @#{ip} hostname.bind chaos txt")
end

# greet user
puts "=== Testing for DNS Hostname Info Disclosure ===\n\r"

# read file and make dns request
File.open(ARGV[0], "r") do |f|
  f.each_line do |ip|
    dns_request(ip.chomp)
  end
end