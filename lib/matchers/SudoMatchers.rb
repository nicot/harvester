class SudoMatchers < Matcher
	def self.badStuff(matchesHash, configs)
		badStuff = {}
		matchesHash.each do |id, array|
			case id
			when "notAuthorized"
				badStuff["notAuthorized"] = []
				userCountHash = Utils.userCount(array)
				userCountHash.each do |user, count|
					if configs["trustedUsers"].include? user
						limit = 2
						if count > limit
							badStuff["notAuthorized"].push("trusted user " + user + " appears " + count.to_s + " time(s) (limit " + limit.to_s + ")")
						end
					else
						badStuff["notAuthorized"].push("user " + user + " appears " + count.to_s + " time(s)")
					end
				end
			end
		end
		return badStuff
	end

	def self.getMatcher(id)
		case id
		when "notAuthorized"
			return Proc.new do |string|
				string.scan(/^(.*\s+sudo:\s+(.*)\s+:\s+user NOT authorized on host.*)$/)
				.map{|full,user| {:full => full, :user => user}}
			end
		when "notInSudoers"
			return Proc.new do |string|
				string.scan(/^(.*\s+sudo:\s+(.*)\s+:\s+user NOT in sudoers.*)$/)
				.map{|full,user| {:full => full, :user => user}}
			end
		end
	end
end


# class SudoMatcher < Matcher
# 	def matches?(string)
# 		string.scan(/^.*user NOT in sudoers.*$/)
# 	end
# end