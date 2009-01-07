#!/usr/bin/ruby
require "dbi"
require "parseconfig"

class Servers
	attr_reader :all

	def initialize
myConfig = ParseConfig.new("../las.conf")
mysqlHost = myConfig.get_value("mysqlHost")
mysqlUser = myConfig.get_value("mysqlUser")
mysqlPass = myConfig.get_value("mysqlPass")
database = myConfig.get_value("database")

		begin
			@dbh = DBI.connect('DBI:Mysql:' + database + ':' + mysqlHost + ':3306', mysqlUser, mysqlPass)
			row = @dbh.select_one("SELECT VERSION()")
			print "\nConnected to #{database}:servers\n"
		rescue DBI::DatabaseError => e
			puts "An error occured"
			puts "Error code : #{e.err}"
			puts "Error message :  #{e.errstr}"
		end

		sql = "SELECT * FROM servers"
	
		begin
			sth = @dbh.prepare(sql)
			sth.execute()
			result = sth.fetch_all
			sth.finish
			@all = result
p @all
		rescue DBI::DatabaseError => e
			print "\nSELECT failed in #{self}\n"
			print "\n", e.err, "\n", e.errstr, "\n"
		rescue
			print "SELECT failed in #{self}\n"
			print "\nNot a DBI error\n"
			print "\n", $!
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
