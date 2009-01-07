require 'collectdata'

class RPMList
	attr_reader :rpmArray
	def initialize(hostName)
		rpmInfo = CollectData.new(hostName)
		if(rpmInfo.rpmOutput == nil) then
			return
		end
		if(rpmInfo.status == "bad") then
			print "\n SSH TIMEOUT \n"
			return
		end
		@rpmArray = Array.new(rpmInfo.rpmOutput.split( /\^\|\|\|/ )) # string of rpm query
	end
end	
