require 'timeout'

class CollectData
	attr_reader :chkconfigOutput, :status
        def initialize(hostName)
	 begin
                timeoutStatus = Timeout::timeout(20) {
                begin
                        Net::SSH.start( hostName, :paranoid => false ) do |session|
                                shell = session.shell.sync
                                data = shell.chkconfig " --list"
                                @chkconfigOutput = data.stdout
                                shell.exit
                        end
                rescue Net::SSH::Exception => e
                        print "\nNet SSH Failed: #{hostName}\n"
                        print "\n", e.err, "\n", e.errstr, "\n"
                rescue
                        print "\nCollectData Failed: #{hostName}\n"
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
