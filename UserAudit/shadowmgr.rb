require 'shadowcollectdata'
require 'shadowmysql'

class ShadowMgr
        def initialize(hostName)
		shadow = ShadowCollectData.new(hostName[1])
		if (shadow.status == "bad") then return end
		shadow.shadowOutput.each { |x|
			x.chomp!
			arry = x.split(':')
			ShadowMySQL.new(arry,hostName[0])
		}
        end
end
