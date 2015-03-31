Currently I have the following ruby scripts:

CronAudit (audits /etc/crontab and /var/spool/cron)
UserAudit (audits /etc/passwd, /etc/shadow and /etc/group)
RPMAudit (audits all system rpm's)
RCAudit (includes /etc/init.d/ rc scripts and xinetd managed processes)

MySQL Database Structure
coming soon.

The above scripts run from one central server and require:
Net::SSH
http://rubyforge.org/projects/net-ssh/
Ruby/DBI
http://rubyforge.org/projects/ruby-dbi/

