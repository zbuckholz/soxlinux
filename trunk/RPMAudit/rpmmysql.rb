require "dbi"
require 'collectdata'

class RPMMysql 
	@@prepared = 0
	def initialize(package,hostName)
		begin
			@dbh = DBI.connect('DBI:Mysql:rpmAudit:mysql.domain:3306', 'audit', 'password')
			row = @dbh.select_one("SELECT VERSION()")
			#puts "Server version : " + row[0]
		rescue DBI::DatabaseError => e
			puts "An error occured"
			puts "Error code : #{e.err}"
			puts "Error message :  #{e.errstr}"
		end
		if(hostName == "localhost") then
	                sql = "Insert INTO rpms VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
	                begin
	                        @sth = @dbh.prepare(sql)
	                rescue DBI::DatabaseError => e
	                        puts "An error occured"
	                        puts "Error code : #{e.err}"
	                        puts "Error message :  #{e.errstr}"
	                rescue
	                        print "\nPrepare Failed: #{package.name}\n"
	                        print "No DBI Prepare error caught\n"
	                end
			begin
				@sth.execute("","#{package.name}","#{package.version}","#{package.release}","#{package.group}","#{package.size}","#{package.signature}","#{package.packager}", "#{package.summary}", "#{package.description}","#{package.relocations}", "#{package.vendor}", "#{package.buildDate}", "#{package.buildHost}",  "#{package.sourceRPM}", "#{package.license}", "#{package.arch}")
			rescue DBI::DatabaseError => e
				print "\nUpdate failed for package: #{package.name}\n"
				print e.err, "\n", e.errstr, "\n"
			rescue
				print "\nUpdate failed for package: #{package.name}\n"
				print $!
				print "\nNo DBI error caught\n"
			end
		else
			begin
				sql = "SELECT id FROM servers WHERE fqdn = ?"
				@sth = @dbh.prepare(sql)
                                @sth.execute(hostName)
                                result = @sth.fetch_all
				@serverID = result
				if(result.size < 1) then
					begin
						print "\nNEW HOST\n", hostName, "\n"
						hostInfo = hostName.split(/./,2)
						sql = "INSERT INTO servers VALUES (?,?,?)"
						@sth = @dbh.prepare(sql)
	                                	@sth.execute("",hostInfo[0],hostInfo[1])
						sql = "SELECT id FROM servers WHERE host = ? AND domain = ?"
						@sth = @dbh.prepare(sql)
                                                @sth.execute(hostInfo[0],hostInfo[1])
						result = @sth.fetch
						@serverID = result
					rescue DBI::DatabaseError => e
        		                        print "\nINSERT failed for hostName: #{hostName}\n"
	                	                print e.err, "\n", e.errstr, "\n"
                        		rescue
                                		print "\nINSERT failed for hostName: #{hostName}\n"
                                		print $!
                                		print "\nNo DBI error caught\n"
                        		end
				end
					
				sql = "SELECT id FROM rpms WHERE signature = ?"
                                @sth = @dbh.prepare(sql)
                                @sth.execute(package.signature)
	
				result = @sth.fetch_all
				@RPMID = result
				if(@RPMID[0] == nil) then
					#print "signature : #{package.signature}\n"
					#print "@RPMID = \"\"\n"
				#if(result.size < 1) then
				#print "\nSIGNATURE : #{package.signature}\n" 
				#print "\nPACKAGE NAME : #{package.name}\n"
					print "\nNEW PACKAGE FOUND : ", package.name, "-", package.version, "-", package.release, "\n"
					#if(package.name == nil || package.version == nil || package.version == nil) then
					#	return
					#end
					#print "ABOUT TO CALL CollectData :\n"
					#print "Passing :\n hostname = #{hostName}\n package.name #{package.name}\n package.version = #{package.version}\n package.release = #{package.release}\n"
					rpmInfo2 = CollectData.new(hostName,package.signature)
					#print "rpmInfo2.rpmOutput.to_s : #{rpmInfo2.rpmOutput.to_s}\n"
                                	package2 = RPM.new( rpmInfo2.rpmOutput.to_s )
					#print "\n\npackage2.inspect = #{package2.inspect}\n"
					#print "package2.status = ", package2.status, "\n"
					if(package2.status == "BAD") then 
						print "\nDuplicate Installation\n"
					end
		                        begin
						#print "ABOUT TO EXECUTE INSERT OF NEW PACKAGE\n"
						sql = "Insert INTO rpms VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
                		                @sth = @dbh.prepare(sql)
                                		@sth.execute("","#{package2.name}","#{package2.version}","#{package2.release}","#{package2.group}","#{package2.size}","#{package2.signature}","#{package2.packager}", "#{package2.summary}", "#{package2.description}","#{package2.relocations}", "#{package2.vendor}", "#{package2.buildDate}", "#{package2.buildHost}",  "#{package2.sourceRPM}", "#{package2.license}", "#{package.arch}")
						sql = "SELECT id FROM rpms WHERE signature = ?"
						@sth = @dbh.prepare(sql)
						@sth.execute(package2.signature)
						result = @sth.fetch
						@RPMID = result
                        		rescue DBI::DatabaseError => e
                                		print "\nINSERT failed for package: #{package2.name}\n"
                                		print e.err, "\n", e.errstr, "\n"
						print "QUERY\n"
						print @sth.inspect
						print "\n", "#{package2.name}","\n","#{package2.version}","\n","#{package2.release}","\n","#{package2.group}","\n","#{package2.size}","\n","#{package2.signature}","\n","#{package2.packager}","\n", "#{package2.summary}","\n", "#{package2.description}","\n","#{package2.relocations}","\n", "#{package2.vendor}","\n", "#{package2.buildDate}","\n", "#{package2.buildHost}", "\n", "#{package2.sourceRPM}","\n", "#{package2.license}", "#{package2.arch}", "\n"
                        		rescue
                                		print "\nINSERT failed for package: #{package2.name}\n"
                                		print $!
                                		print "\nNo DBI error caught\n"
                                                print @sth.inspect
						print "\n", "#{package2.name}","\n","#{package2.version}","\n","#{package2.release}","\n","#{package2.group}","\n","#{package2.size}","\n","#{package2.signature}","\n","#{package2.packager}","\n", "#{package2.summary}","\n", "#{package2.description}","\n","#{package2.relocations}","\n", "#{package2.vendor}","\n", "#{package2.buildDate}","\n", "#{package2.buildHost}", "\n", "#{package2.sourceRPM}","\n", "#{package2.license}", "#{package.arch}", "\n"

                        		end
				else
					begin
						sql = "SELECT arch FROM rpms WHERE signature = ?"
						@sth = @dbh.prepare(sql)
						#print "package.signature : ", package.signature, "\n"
	                                	@sth.execute(package.signature)
	                                	result = @sth.fetch_all
						#print "RESULT.INSPECT : ", result.inspect, "\n"
	                                	@RPMARCH = result
						#print "@RPMARCH.INSPECT : ", @RPMARCH.inspect, "\n"
						#print "RPMARCH : #{@RPMARCH}\n"
					rescue DBI::DatabaseError => e
                                                        print "\nArch query failed: #{package.name}\n"
                                                        print "e.err : ", e.err, "\n"
                                                        print "e.errstr : ", e.errstr, "\n"
							exit()
					rescue
						print "ERROR ERROR ERROR\n"
						print $!
							exit()
					end
					#print "@RPMARCH[0] : ", @RPMARCH[0], "\n"
	                                #if(@RPMARCH[1] == nil) then
				#		print "\nARCH IS EMPTY FOR SURE\n"
			#			begin
		#					sql = "UPDATE rpms SET arch = ? WHERE signature = ?"
        	#                                	@sth = @dbh.prepare(sql)
	#						print "\npackage.arch : ", package.arch, "\n"
#							print "\npackage.signature : ", package.signature, "\n"
#                	                        	@sth.execute(package.arch,package.signature)
#						rescue DBI::DatabaseError => e
#                                			print "\nArch update failed: #{package.name}\n"
#                                			print "e.err : ", e.err, "\n"
#                                			print "e.errstr : ", e.errstr, "\n"
#                        			rescue
#                        			        print "\nArch update failed: #{package.name}\n"
#                        			        print $!
#                                			print "\nNo DBI error caught\n"
#                        			end
#					else
#						print "\nARCH IS NOT EMPTY\n"
#					end
				end
						# CollectData.new(hostName,package.name,"yes")
				sql = "INSERT INTO tracking VALUES (NOW(),?,?,FROM_UNIXTIME(#{package.installTime}))"
				#print "About to insert into tracking\n"
				@sth = @dbh.prepare(sql)
                                @sth.execute("#{@serverID}","#{@RPMID}")
				#print @sth.inspect
				#print "\n",$!,"\n"
			rescue DBI::DatabaseError => e
                               	print "\nSignature query failed for package: #{package.name}\n"
                               	print "e.err : ", e.err, "\n"
				print "e.errstr : ", e.errstr, "\n"
                        rescue
                                print "\nSignature query failed for package: #{package.name}\n"
                                print $!
                                print "\nNo DBI error caught\n"
                        end
		end
		@dbh.disconnect
	end
end
