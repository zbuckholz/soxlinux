require 'timeout'

class CollectData
	attr_reader :rpmOutput, :status
        def initialize(hostName,package="none",packageVersion="none",packageRelease="none",needDate="no")
	begin
		timeoutStatus = Timeout::timeout(20) {
		begin
			if(package != "none" && needDate == "no") then
				 	rpmQuery = " -q --qf '%{NAME}|||%{VERSION}|||%{RELEASE}|||%{GROUP}|||%{SIZE}|||%{SIGMD5}|||%{PACKAGER}|||%{SUMMARY}|||%{DESCRIPTION}|||%{PREFIXES}|||%{VENDOR}|||%{BUILDTIME}|||%{BUILDHOST}|||%{SOURCERPM}|||%{LICENSE}|||%{INSTALLTIME}|||%{ARCH}' --pkgid #{package}"
				begin
	 				Net::SSH.start( hostName, :paranoid => false ) do |session|
        	                	        shell = session.shell.sync
                	                	data = shell.rpm " #{rpmQuery}"
                        	        	@rpmOutput = data.stdout
						if (@rpmOutput.include? "is not installed") then
							rpmQuery = " -q --qf '|||%{NAME}|||%{VERSION}|||%{RELEASE}|||%{GROUP}|||%{SIZE}|||%{SIGMD5}|||%{PACKAGER}|||%{SUMMARY}|||%{DESCRIPTION}|||%{PREFIXES}|||%{VENDOR}|||%{BUILDTIME}|||%{BUILDHOST}|||%{SOURCERPM}|||%{LICENSE}|||%{INSTALLTIME}|||%{ARCH}' --pkgid #{package}"
							data = shell.rpm " #{rpmQuery}"
							@rpmOutput = data.stdout
						end
						print "\nRPM OUTPUT IN COLLECT : #{@rpmOutput}\n"
                                		shell.exit
                        		end
				rescue Net::SSH::Exception => e
	                                print "\nNet SSH Failed: in package != none and needDate == no #{hostName}\n"
        	                        print e.err, "\n", e.errstr, "\n"
                		rescue
                        	        print "\nCollectData Failed 1: in package != none and needDate == no  #{hostName}\n"
					print "Not SSH Exception"
                                	print $!
                		end
				return
			end
			if(hostName == "localhost") then
				rpmQuery = " -qa --qf '^|||%{NAME}|||%{VERSION}|||%{RELEASE}|||%{GROUP}|||%{SIZE}|||%{SIGMD5}|||%{PACKAGER}|||%{SUMMARY}|||%{DESCRIPTION}|||%{PREFIXES}|||%{VENDOR}|||%{BUILDTIME}|||%{BUILDHOST}|||%{SOURCERPM}|||%{LICENSE}'|||%{ARCH}"
				@rpmOutput = `rpm #{rpmQuery}`
			end
			if(needDate != "yes" && package == "none") then
				rpmQuery = " -qa --qf '^|||%{NAME}|||%{VERSION}|||%{RELEASE}|||%{SIGMD5}|||%{INSTALLTIME}|||%{ARCH}'"
				begin
       	        			Net::SSH.start( hostName, :paranoid => false ) do |session|
                        			shell = session.shell.sync
	                		        data = shell.rpm " #{rpmQuery}" 
	                		        @rpmOutput = data.stdout
        	        		        shell.exit
	                		end
				rescue Net::SSH::Exception => e
	                                print "\nNet SSH Failed: in needDate != yes & package == none #{hostName}\n"
        	                        print e.err, "\n", e.errstr, "\n"
                		rescue
                	                print "\nCollectData Failed 2: in needDate != yes & package == none #{hostName}\n"
					print "Not SSH Exception"
                	                print $!
                		end

			end
			if(needDate == "yes") then
                                rpmQuery = " -q --qf '%{INSTALLTIME}' --pkgid #{package}"
				begin
                        		Net::SSH.start( hostName, :paranoid => false ) do |session|
                        		        shell = session.shell.sync
                        		        data = shell.rpm " #{rpmQuery}"
                        		        @rpmOutput = data.stdout
                        		        shell.exit
                        		end
				rescue Net::SSH::Exception => e
	                                print "\nNet SSH Failed: in needDate == yes #{hostName}\n"
	                                print e.err, "\n", e.errstr, "\n"
		                rescue
                	                print "\nCollectData Failed 3: in needDate == yes #{hostName}\n"
					print "Not SSH Exception"
                        	        print $!
                		end

                        	return
                	end
		rescue Net::SSH::Exception => e
                                print "\nNet SSH Failed: #{hostName}\n"
                                print e.err, "\n", e.errstr, "\n"
                rescue
                                print "\nCollectData Failed: #{hostName}\n"
                                print $!
                end
	}
	rescue Timeout::Error => e
		@status = "bad"
		return
	end
	end
end
