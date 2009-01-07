require 'timeout'
require 'net/ssh'

class ShadowCollectData
	attr_reader :shadowOutput, :status

	def initialize(hostName)
		begin
                timeoutStatus = Timeout::timeout(20) {
		begin
		 	Net::SSH.start( hostName ) do |session|
	        		shell = session.shell.sync
	        	        data = shell.cat " /etc/shadow"
	        	        @shadowOutput = data.stdout
	        	       	shell.exit
        	       	end
		rescue Net::SSH::Exception => e
		        print "\nNet SSH Failed: #{hostName}\n"
        		print "\n", e.err, "\n", e.errstr, "\n"
               	rescue
        	        print "\nGroupCollectData Failed: #{hostName}\n"
			print "\nNot SSH Exception\n"
        	       	print "\n", $!, "\n"
			@status = "bad"
			return
               	end
		}
		rescue Timeout::Error => e
                        @status = "bad"
                        return
                end
	end
end
