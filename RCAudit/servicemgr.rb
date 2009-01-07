require 'collectdata'
require 'servicemysql'

class ServiceMgr

	attr_reader :sqlInsertArray

        def initialize(hostName)
puts "Working on #{hostName[1]}"
		@sqlInsertArray = Array.new
                services = CollectData.new(hostName[1])
                if (services.status == "bad") then return end
		servicesArray = services.chkconfigOutput.split(%r{\n})
		#servicesArray.each { |x| p x }
		servicesArray.each { |x|
puts x
			serviceInfo = x.split(%r{\t})
			if(serviceInfo.length == 8) then
				#print "serviceInfo is rc\n"
				serviceName = serviceInfo[0].strip
				bitmask = 0
				serviceInfo[1...7].each{ |x|
					if(x.include? "on" ) then
						bit = 0
						value = x.split(":")
						bit = case value[0].to_i
							when 0 then 1.to_i 
							when 1 then 2.to_i
							when 2 then 4.to_i
							when 3 then 8.to_i
							when 4 then 16.to_i
							when 5 then 32.to_i
							when 6 then 64.to_i
						end
					else
						bit = 0
					end
					bitmask += bit
				}
				serviceHash = Hash[serviceName,bitmask]
				@sqlInsertArray.push(serviceHash)
			elsif(serviceInfo.length == 3)
				serviceName = serviceInfo[1].strip
				serviceStatus = serviceInfo[2].strip
				serviceName.delete!(':')
				bitmask = (serviceStatus.to_s == "on") ? 128 : 256
				serviceHash = Hash[serviceName,bitmask]
				@sqlInsertArray.push(serviceHash)
			else
				#print "serviceInfo is ??? ", serviceInfo.inspect, "\n"
				#print "serviceInfo length ", serviceInfo.length, "\n"
			end
		}
		ServiceMysql.new(@sqlInsertArray,hostName)
        end
end

