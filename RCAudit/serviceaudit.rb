#!/usr/local/bin/ruby 
require "../servers"
require 'net/ssh'
require 'servicemgr'

class ServiceAudit
        serversObj = Servers.new()
        serversObj.all.each { |x| ServiceMgr.new(x) }
end
