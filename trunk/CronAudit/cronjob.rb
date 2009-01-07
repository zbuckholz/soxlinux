class CronJob
        attr_reader :minute, :day, :weekday, :hour, :monthDay, :month, :weekDay, :uid, :command
        def commandName
                dirs = @command.split('/')
                dirs[dirs.length - 1]
        end
        def initialize(minute="*", hour="*", day="*", month="*", weekday="*", uid="*", command="*")
                @minute = minute
                @hour = hour
                @day = day
                @month = month
                @weekday = weekday
		@uid = path2uid(uid)
                @command = command
        end
        def to_s
                "#{@minute}\t#{@hour}\t#{@day}\t#{@month}\t#{@weekday}\t#{@uid}\t#{@command}"
        end
	def path2uid(uid)
		tmpArry = uid.split('/')
		tmpArryLen = tmpArry.length
		uid = tmpArry[tmpArryLen - 1]
		return uid
	end
end

