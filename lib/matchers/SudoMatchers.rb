class SudoMatchers
	def self.findMatches(string, matchers)
		# This method should find all matches, and gather any important information about them,
		#  such as user, command, etc
		matchesHash = {}

		matchers.each do |matcher|
			matcherBlock = getMatcher(matcher)
			matchesHash[matcher] = matcherBlock.call(string)
		end
		matchesHash
	end

	def self.good?(matchesHash, configs)
		matchesHash.each do |id, array|
			case id
			when "notAuthorized"
				userCountHash = self.userCount(array)
				userCountHash.each do |user, count|
					if configs["trustedUsers"].include? user
						if count > 2
							return false
						end
					else
						return false
					end
				end
			end
		end
		return true
	end

	def self.bad?(matchesHash)
		! self.good?(matchesHash)
	end


	def self.userCount(array)
		count = {}
		array.each do |hash|
			user = hash[:user]
			if count[user] == nil
				count[user] = 0
			end
			count[user] += 1
		end
		count
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