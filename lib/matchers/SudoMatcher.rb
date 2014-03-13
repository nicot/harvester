class NotAuthorizedMatcher < Matcher
	def match(string)
		package(string.scan(/^(.*\s+sudo:\s+(.*)\s+:\s+user NOT authorized on host.*)$/)
		.map{|full,user| {:full => full, :user => user}})
	end
end

class NotInSudoersMatcher < Matcher
	def match(string)
		package(string.scan(/^(.*\s+sudo:\s+(.*)\s+:\s+user NOT in sudoers.*)$/)
		.map{|full,user| {:full => full, :user => user}})
	end

end

class NotMe < Matcher
	def match(string)
        matches = []
        trustedUsers = ['doto7679']
        string.split("\n").each do |line| 
            user = line.scan(/.*\s+sudo:\s+(\w+).*/).first.first
            matches << line unless trustedUsers.include?(user)
        end

        exitcode = []
        matches.each do |line|
            if line =~ /wenzl/
                exitcode << 2
            else
                exitcode << 1
            end
        end

        matches = matches.zip(exitcode)
        package(matches.map{|full,exitcode| {:full => full, :exitcode => exitcode}})
	end
end
