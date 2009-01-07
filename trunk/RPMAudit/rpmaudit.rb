#!/usr/local/bin/ruby 
require "../servers"
require 'net/ssh'
require 'rpmlist'
require 'rpmmysql'
require 'rpm'
#require 'profile'

class RPMAudit
	serversObj = Servers.new()
puts serversObj.inspect
	serversObj.all.each { |x|
		hostName = x[1]
		print "HOSTNAME : ", hostName, " started:\n"
		result = RPMList.new(hostName)
		if(result.rpmArray == nil) then
			next
		end
		result.rpmArray.each {  |y| 
				package = RPM.new( y )
				if(package.signature == nil) then next end
				print "."
				STDOUT.flush
				sql = RPMMysql.new(package,hostName)
		}
		print "HOSTNAME : ", hostName, " ended:\n"
	}
end
