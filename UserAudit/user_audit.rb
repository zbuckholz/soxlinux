#!/usr/local/bin/ruby
require "dbi"
require "../servers"
require "usermgr"
require "groupmgr"
require "shadowmgr"

class UserAudit
	serversObj = Servers.new()
	serversObj.all.each { |x| UserMgr.new(x) }
	serversObj.all.each { |x| GroupMgr.new(x) }
	serversObj.all.each { |x| ShadowMgr.new(x) }
end

