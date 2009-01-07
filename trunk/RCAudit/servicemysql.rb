require "dbi"

class ServiceMysql 
	def initialize(sqlInsertArray,hostName)
		begin
			@dbh = DBI.connect('DBI:Mysql:serviceAudit:mysql.domain:3306', 'audit', 'password')
			row = @dbh.select_one("SELECT VERSION()")
			#puts "Server version : " + row[0]
		rescue DBI::DatabaseError => e
			puts "An error occured"
			puts "Error code : #{e.err}"
			puts "Error message :  #{e.errstr}"
		end
		sqlInsertArray.each { |x| 
			x.each { |x,y| 
				sql = "SELECT id FROM services WHERE ? = name"
	                	begin
	                	        @sth = @dbh.prepare(sql)
	                	rescue DBI::DatabaseError => e
	                	        puts "An error occured"
	                	        puts "Error code : #{e.err}"
	                	        puts "Error message :  #{e.errstr}"
	                	rescue
	                	        print "\nPrepare Failed: #{x}\n"	
					print $!
	                	        print "No DBI Prepare error caught\n"
	                	end
				begin
					@sth.execute("#{x}")
                        	        result = @sth.fetch_all
					@service = result
					if(result.size < 1) then
						begin
							sql = "INSERT INTO services VALUES(?,?)"
							@sth = @dbh.prepare(sql)
	                	                	@sth.execute("","#{x}")
							sql = "SELECT id FROM services WHERE name = ?"
							@sth = @dbh.prepare(sql)
                        	                        @sth.execute("#{x}")
							result = @sth.fetch
							@service = result
						rescue DBI::DatabaseError => e
        			                        print "\nINSERT failed for service: #{x}\n"
	                		                print e.err, "\n", e.errstr, "\n"
                        			rescue
                        	        		print "\nINSERT failed for service: #{x}\n"
                        	        		print $!
                        	        		print "\nNo DBI error caught\n"
                        			end
					end
				rescue DBI::DatabaseError => e
					print "\nSelect failed for service: #{x}\n"
					print e.err, "\n", e.errstr, "\n"
				rescue
					print "\nSelect failed for service: #{x}\n"
					print $!
					print "\nNo DBI error caught\n"
				end
				begin
					sql = "INSERT INTO tracking VALUES(NOW(),?,?,?)"
					@sth = @dbh.prepare(sql)
	                        rescue DBI::DatabaseError => e
                                        puts "An error occured"
                                        puts "Error code : #{e.err}"
                                        puts "Error message :  #{e.errstr}"
                                rescue
                                        print "\nPrepare Failed: #{x} , #{y}\n"
                                        print "No DBI Prepare error caught\n"
                                end
				begin
                                	@sth.execute("#{@service}",hostName[0],"#{y}")
				rescue DBI::DatabaseError => e
                                        print "\nInsert failed for service tracking: #{@service}, #{hostName[0]}, #{y}\n"
                                        print e.err, "\n", e.errstr, "\n"
                                rescue
                                        print "\nInsert failed for service: #{@service}, #{hostName[0]}, #{y}\n"
                                        print $!
                                        print "\nNo DBI error caught\n"
				end
			}
		}
				@dbh.disconnect
		end
end
