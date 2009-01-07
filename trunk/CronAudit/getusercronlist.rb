require 'etc'
require 'timeout'

class GetUserCronList
	attr_reader :userList
        def initialize(hostName)
p hostName
		@userList = Array.new
		timeoutStatus = Timeout::timeout(30) {
		begin
                Net::SSH.start( hostName, :paranoid => false ) do |session|
                        shell = session.shell.sync
			p shell.uname " -a"
			@pathList = shell.find "/var/spool/cron -type f"
			@pathList.stdout.each { |path|
				path.chop!
				if((path.slice(/([[:alpha:]]*$)/)).length > 1) then
					@user = path.slice(/([[:alpha:]]*$)/)
					@isUser = shell.grep "^#{@user}: /etc/passwd"
					if(@isUser.stdout) then
                        	        	@userList.push(path)
					end
				end
			}
                       	shell.exit
		end
		rescue Net::SSH::AuthenticationFailed
                                        print "Authentication Failure - #{hostName}\n"
                                        next
                rescue Net::SSH::Exception => e
                                        print "\nNet SSH Failed : #{hostName}\n"
                                        print "\n", e.err, "\n", e.errstr, "\n"
                                        print "\n", $!, "\n"
                                        next
                rescue Timeout::Error => e
                                        print "\nFailed: #{hostName} Timeout\n"
                                        print "\n", e.err, "\n", e.errstr, "\n"
                                        print "\n", $!, "\n"
                                        next
		end
		}
        end
end
