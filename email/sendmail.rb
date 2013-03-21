#!/usr/bin/env ruby
# This script takes a .txt file as an argument. It will iterate through each emailaddress
# in the file and send an email to each target
# Authors: zeknox & R3dy
##########################################################################
require 'net/smtp'
require 'base64'

username = 		'greg.olson@issds.com'
password = 		'password'
from = 			'greg.olson@issds.com'
display_from =	'Greg Olson'
subject = 		'Microsoft Security Update'
date =			'Thursday, January 18, 2013'
url = 			'www.example.com/index.php?'
smtp =			'secureserver.net'
smtpout =		'smtpout.secureserver.net'
port =			'3535'
message = []	

def sendemail(username, password, from, message, email, port, smtpout, smtp)
	# code to send email
	begin
		Net::SMTP.start("#{smtpout}", "#{port}", "#{smtp}","#{username}", "#{password}", :plain) do |smtp|
			smtp.send_message message, "#{from}", email.chomp
		end
		puts "\tSent to: #{email}"
	rescue => e
		puts "\tIssues Sending to: #{email}\r\n#{e.class}\r\n#{e}"
	end
end

unless ARGV.length == 2
	puts "./sendmail.rb <email-addys.txt> <email_message.txt>\n"
	exit!
else
	emails = File.open(ARGV[0], 'r')
end

count = 1
puts "Sending Emails:"
emails.each_line do |email|
	message = []
	# base64 encode email address
	encode = "#{Base64.encode64("#{email}")}"

	email_message = File.open(ARGV[1], 'r')
	email_message.each_line do |line|
		if line =~ /\#{url}/
			message << line.gsub(/\#{url}/, "#{url}#{encode.chomp}")
		elsif line =~ /\#{to}/
			message << line.gsub(/\#{to}/, "#{email.chomp}")
		elsif line =~ /\#{from}/ and line =~ /\#{display_from}/
			message << line.gsub(/\#{display_from} <\#{from}>/, "#{display_from} <#{from}>")
		elsif line =~ /\#{display_from}/ and not line =~ /\#{from}/
			message << line.gsub(/\#{display_from}/, "#{display_from}")
		elsif line =~ /\#{subject}/
			message << line.gsub(/\#{subject}/, "#{subject}")
		elsif line =~ /\#{date}/
			message << line.gsub(/\#{date}/, "#{date}")
		else
			message << line
		end
	end
	email_message.close

	text = message.join

	# send emails
	sendemail(username, password, from, text, email, port, smtpout, smtp)
end

# close files
emails.close
