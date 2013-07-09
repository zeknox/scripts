#!/usr/bin/env ruby
require 'base64'

unless ARGV.length > 0
	puts "USAGE: ./parselogs.rb [apache-access.log]\r\n\r\n"
	exit!
end

def clean_line(line)
	if line.include?('id=')
		first = line.split('id=')[0]
		second = line.split('id=')[1]
		junk = second.split(" ")
		junk[0] = Base64.decode64(junk[0])
		second = "id="
		junk.each { |element| second << element.to_s.chomp + " " }
		return first +  second
	else
		return line
	end
end

File.open(ARGV[0], 'r').each_line do |line|
	puts clean_line(line)
end
