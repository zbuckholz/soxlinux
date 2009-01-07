class CollectData
	attr_reader :out
        def initialize(hostName,queryList)
		@out = Array.new
		@cronData = Hash.new
		begin
	                Net::SSH.start( hostName ) do |session|
        	                shell = session.shell.sync
				queryList.each { |path| 
					queryPath = path
					data = shell.cat "#{queryPath}"
					@cronData[queryPath] = data.stdout
				}
				@out.push(@cronData)
                	        shell.exit
                	end
		rescue
			next
		end
        end
end
