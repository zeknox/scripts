#!/usr/bin/env ruby
#
# ssh_weak_mac_algos.rb
# --------------------------------
# Author: Brandon <zeknox> McCann
# --------------------------------
#
# enumerate the list of supported ssh algos
# from a list of ip addresses

# ensure argument has been passed
unless ARGV.length == 1
  puts "\n\rUSAGE: ./ssh_weak_mac_algos.rb <ips.txt>\n\r"
  exit!
end

@weak_algos = ['hmac-md5', 'hmac-md5-96', 'hmac-sha1-96']

def parse_ssh_algos(output, ip=nil)
  @weak_algos.each do |algo|
    if output.include? algo
      puts "[+] #{ip} - #{algo} Enabled"
    end
  end
end

# send dns_request
def ssh_enumeration(ip)
  begin
    puts "[*] Enumerating SSH algorithms against #{ip}"
    nmap_output = `nmap -p 22 -sV #{ip} --script=ssh2-enum-algos`
    parse_ssh_algos(nmap_output, ip)
  rescue SystemExit, Interrupt
    puts "\n\rExiting..."
    exit!
  rescue Exception => e
    puts "[-] Error #{ip} - #{e}"
    return
  end
end

# greet user
puts "\n\r=== Testing for Weak SSH Algorithms ===\n\r"

# read file and make dns request
File.open(ARGV[0], "r") do |f|
  f.each_line do |ip|
    ssh_enumeration(ip.chomp)
  end
end