class SudoMatchers < Matcher
	def self.notAuthorized(string)
		string.scan(/^(.*\s+sudo:\s+(.*)\s+:\s+user NOT authorized on host.*)$/)
		.map{|full,user| {:full => full, :user => user}}
	end

	def self.notInSudoers(string)
		string.scan(/^(.*\s+sudo:\s+(.*)\s+:\s+user NOT in sudoers.*)$/)
		.map{|full,user| {:full => full, :user => user}}
	end

	def self.notAuthorizedResponder(matchesHash, configs)
		array = matchesHash['notAuthorized']

		userCountHash = Utils.userCount(array)
		userCountHash.each do |user, count|
			if configs["trustedUsers"].include? user
				limit = 2
				if count > limit
					puts "trusted user " + user + " has " + count.to_s + " \"user NOT authorized on host\" messages (limit " + limit.to_s + ")"
				end
			else
				puts "user " + user + " has " + count.to_s + " \"user NOT authorized on host\" messages"
			end
		end
	end
end


# class SudoMatcher < Matcher
# 	def matches?(string)
# 		string.scan(/^.*user NOT in sudoers.*$/)
# 	end
# end