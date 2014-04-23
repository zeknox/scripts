#!/usr/bin/env ruby

# gems
require 'nokogiri'

# ensure argument has been passed
unless ARGV.length == 1
  puts "\n\rUSAGE: ./parse_sslscan_weak_keys.rb <sslscan.xml>\n\r"
  exit!
end

# load file into doc nokogiri object
f = File.open(ARGV[0])
doc = Nokogiri::XML(f)
f.close

# display hosts with weak key
doc.xpath('//document/ssltest/certificate/pk').each do |pk|
  if pk['bits'].to_i < 2048
    host = doc.xpath('/document/ssltest').first['host']
    port = doc.xpath('/document/ssltest').first['port']
    puts "[+] #{host}:#{port} - Weak SSL Certificate Key"
  end
end
