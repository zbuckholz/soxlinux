class RPM
	attr_reader :name, :relocations, :version, :vendor, :release, :buildDate, :installDate, :buildHost, :group, :sourceRPM, :size, :license, :signature, :packager, :summary, :description, :installTime, :status, :arch
	def initialize( data )
		
		data.gsub!("\^\|\|\|","")
		rpmAttributes = data.split( /\|\|\|/ )
		#print "rpmAttributes.inspect : #{rpmAttributes.inspect}\n"
		if(rpmAttributes.length >= 17) then
			@name = rpmAttributes[0]
			@relocations = rpmAttributes[9]
			@version = rpmAttributes[1]
			@vendor = rpmAttributes[6]
			@release = rpmAttributes[2]
			@buildDate = rpmAttributes[11]
			@buildHost = rpmAttributes[12]
			@group = rpmAttributes[3]
			@sourceRPM = rpmAttributes[13]
			@size  = rpmAttributes[4]
			@license = rpmAttributes[14]
			@signature = rpmAttributes[5]
			@packager = rpmAttributes[10]
			@summary = rpmAttributes[7]
			@description = rpmAttributes[8]
			@installTime = rpmAttributes[16]
			@arch =	rpmAttributes[17]
		elsif (rpmAttributes.length == 6) then
			#print "\nrpmAttributes.length #{rpmAttributes.length}\n"
                        @name = rpmAttributes[0]
                        @release = rpmAttributes[1]
                        @version = rpmAttributes[2]
                        @signature = rpmAttributes[3]
			@installTime = rpmAttributes[4]
			@arch = rpmAttributes[5]
		elsif (rpmAttributes.length >= 1) then
			print "Duplicate package in local rpm database\n"
			p rpmAttributes.inspect
			@status = "BAD"
			print "\nRAW DATA : #{data}\n"
			print "rpmAttributes.inspect : #{rpmAttributes.inspect}\n"
                	rpmAttributes.each { |x| print x, "\n" }
		end
		#print "@name = #{@name}\n"
		#print "@relocations = #{@relocations}\n"
		#print "@version = #{@version}\n"
		#print "@vendor = #{@vendor}\n"
		#print "@release = #{@release}\n"
		#print "@buildDate = #{@buildDate}\n"
		#print "@buildHost = #{@buildHost}\n"
		#print "@group = #{@group}\n"
		#print "@sourceRPM = #{@sourceRPM}\n"
		#print "@size  = #{@size}\n"
		#print "@license = #{@license}\n"
		#print "@signature = #{@signature}\n"
		#print "@packager = #{@packager}\n"
		#print "@summary = #{@summary}\n"
		#print "@description = #{@description}\n"
		#print "@installTime = #{@installTime}\n"
		#rpmAttributes.each { |x| print x, "\n" }
	end
end
