#!/usr/local/bin/ruby
require '../servers'
require "dbi"
require "net/ssh"
require "parseconfig"
require 'crontabmgr'

class CronAudit
myConfig = ParseConfig.new("../las.conf")
mysqlHost = myConfig.get_value("mysqlHost")
mysqlUser = myConfig.get_value("mysqlUser")
mysqlPass = myConfig.get_value("mysqlPass")
database = myConfig.get_value("database")

	serversObj = Servers.new()
        serversObj.all.each { |x|
                        hostName = x[1]
			begin
				cronResult = CronTabMgr.new(hostName)
				cronResult.each { |cronResult|
p cronResult 
p hostName
					begin
	        	             		@dbh = DBI.connect('DBI:Mysql:' + database + ':' + mysqlHost + ':3306', mysqlUser, mysqlPass)
			                        row = @dbh.select_one("SELECT VERSION()")
						print "\nConnected to cronAudit\n"
                			rescue DBI::DatabaseError => e
                	        		puts "An error occured"
                	        		puts "Error code : #{e.err}"
                	        		puts "Error message :  #{e.errstr}"
                			end
					sql = "SELECT id FROM servers WHERE fqdn = ?"
p sql
                	                @sth = @dbh.prepare(sql)
p hostName
                	                @sth.execute(hostName)
                	                result = @sth.fetch_all
                	                @serverID = result
                	                if(result.size < 1) then
                	                        begin
                	                                print "\nNEW HOST\n", hostName, "\n"
                	                                sql = "INSERT INTO #{database}.servers VALUES (?,?)"
                	                                @sth = @dbh.prepare(sql)
                	                                @sth.execute("",hostName)
                	                                sql = "SELECT id FROM #{database}.servers WHERE fqdn = ?"
p sql
                	                                @sth = @dbh.prepare(sql)
                	                                @sth.execute(hostName)
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
					else
					end
					sql = "Insert INTO crontab VALUES (NOW(),?,?,?,?,?,?,?,?)"
	        	                begin
        		                        @sth = @dbh.prepare(sql)
        		                rescue DBI::DatabaseError => e
        		                        puts "An error occured"
        		                        puts "Error code : #{e.err}"
        		                        puts "Error message :  #{e.errstr}"
        		                rescue
        		                        print "\nPrepare Failed: #{cronResult.to_s}\n"
        		                        print "No DBI Prepare error caught\n"
        		                end
        		                begin
						print "\nAbout to execute insert\n"
        		                        @sth.execute("#{@serverID}","#{cronResult.minute}","#{cronResult.hour}","#{cronResult.day}","#{cronResult.month}","#{cronResult.weekday}","#{cronResult.uid}", "#{cronResult.command}")
						print "."
        		                rescue DBI::DatabaseError => e
        		                        print "\nUpdate failed for cron: #{cronResult.to_s}\n"
        		                        print e.err, "\n", e.errstr, "\n"
        		                rescue
                		                print "\nUpdate failed for cron: #{cronResult.to_s}\n"
                			        print $!
						print "\n", cronResult.inspect, "\n"
	        	                        print "\nNo DBI error caught\n"
        		                end
					#print "--- END ---\n"
				}
			rescue
					print "\nError occured\n"
					print $!
					next
		end
	}
end	
