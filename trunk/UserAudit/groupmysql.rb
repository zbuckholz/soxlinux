require "dbi"

class GroupMySQL
	def initialize(group,hostName)
		begin
			@dbh = DBI.connect('DBI:Mysql:userAudit:mysql.domain:3306', 'audit', 'password')
			row = @dbh.select_one("SELECT VERSION()")
			#puts "Server version : " + row[0]
		rescue DBI::DatabaseError => e
			puts "An error occured"
			puts "Error code : #{e.err}"
			puts "Error message :  #{e.errstr}"
		end
                begin
	        	sql = "INSERT INTO `group` VALUES (NOW(),?,?,?,?,?)"
			if(group[3] == nil) then
				group[3] = ""
			end
                        @sth = @dbh.prepare(sql)
			@sth.execute("#{hostName}","#{group[0]}","#{group[1]}","#{group[2]}","#{group[3]}")
			@sth.finish
		rescue DBI::DatabaseError => e
			print "\nInsert failed for : #{hostName} #{group[0]}\n"
			print "@sth.inspect : \n", @sth.inspect, "\n"
			print e.err, "\n", e.errstr, "\n"
		rescue
			print "\nInsert failed for : #{hostName} #{group[0]}\n"
			print "@sth.inspect : \n", @sth.inspect, "\n"
			print $!
			print "\nNo DBI error caught\n"
		end
		begin
                        @dbh.disconnect
                rescue DBI::DatabaseError => e
                        print "\nClose @dbh failed in #{self}\n"
                        print "\n", e.err, "\n", e.errstr, "\n"
                rescue
                        print "Close @dbh failed in #{self}\n"
                        print "\nNot a DBI error\n"
                        print "\n", $!
                end
	end
end
