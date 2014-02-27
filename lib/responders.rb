module Responders
	def self.notAuthorizedResponder(matches)
		userCountHash = Utils.userCount(matches)
		userCountHash.each do |user, count|
			trustedUsers = ["kniffin"]
			if trustedUsers.include? user
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
