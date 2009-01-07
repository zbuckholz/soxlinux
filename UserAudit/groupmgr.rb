require 'groupcollectdata'
require 'groupmysql'

class GroupMgr
        def initialize(hostName)
		groups = GroupCollectData.new(hostName[1])
		if (groups.status == "bad") then return end
		groups.groupOutput.each { |x|
			x.chomp!
			arry = x.split(':')
			GroupMySQL.new(arry,hostName[0])
		}
        end
end
