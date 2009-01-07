require 'collectdata'
require 'cronjob'
require 'etc'
require 'getusercronlist'

class CronTabMgr < Array
        def initialize(hostName)
p hostName
		@queryList = Array.new
		baseCrontab = "/etc/crontab"
		userCrontabArray = GetUserCronList.new(hostName)
		@queryList.push(baseCrontab)
		userCrontabArray.userList.each { |user| @queryList.push(user) }
                crontab = CollectData.new(hostName,@queryList)
		cronData = crontab.out # cronData is an array of hashes, each hash key is the path to the cron file
		cronData.each { |cronHash| # for each hash
			cronHash.each_key { |path|
				lineEach = cronHash[path]
					@lineArray = lineEach.split("\n")
					@lineArray.each { |line|
						next if line =~ /^#/
						next if ! (line =~ /^[[:digit:]]/)
	       	                 		jobAttributes = line.split()
						if(path =~ /crontab$/) then
                        				6.upto(jobAttributes.length - 1) { |i|
                        			       		jobAttributes[6] =  " " + jobAttributes[i]
							}
                					job = CronJob.new(jobAttributes[0],
                        					jobAttributes[1], jobAttributes[2],
                        					jobAttributes[3], jobAttributes[4],
                        					jobAttributes[5], jobAttributes[6])
						#	self.push(job)
						else
							5.upto(jobAttributes.length - 1) { |i|
                        			        	jobAttributes[5] = jobAttributes[5] +
                        			                " " + jobAttributes[i]
                        			        }
								jobAttributes[6] = jobAttributes[5]
								jobAttributes[5] = path
                        			        job = CronJob.new(jobAttributes[0],
                        			                jobAttributes[1], jobAttributes[2],
                        			                jobAttributes[3], jobAttributes[4],
                        			                jobAttributes[5], jobAttributes[6])
                        			#        self.push(job)
						end
                        			        self.push(job)
		#				print "DEBUG \n " , job , "\n END JOB DEBUG \n"
					}
			}
		}
        end
        def to_s
		
                self.each { |job| puts job }
        end
end
