require 'collectdata'
require 'usermysql'

class UserMgr
        def initialize(hostName)
		users = CollectData.new(hostName[1])
		if (users.status == "bad") then return end
		users.passwdOutput.each { |x|
			x.chomp!
			arry = x.split(':')
			UserMySQL.new(arry,hostName[0])
		}
        end
end
