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
	

	def self.badStuff(matchesHash, configs)
		badStuff = {}
		matchesHash.each do |id, array|
			case id
			when "notAuthorized"
				badStuff["notAuthorized"] = []
				userCountHash = self.userCount(array)
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

	def self.userCount(array)
		# Return a hash describing how many times a user shows up in the array

		# All three options below do the same thing
		# Option 1
		#count = {}
		#array.each do |hash|
			#user = hash[:user]
			#if count[user] == nil
				#count[user] = 0
			#end
			#count[user] += 1
		#end
		#count

		# Option 2
		#users = testArray.map {|x| x[:user]}.group_by {|x|x}
		#user_frequency = Hash[users.map {|k,v| [k, v.length]}]


		# Option 3
		array.map {|x| x[:user]}.inject(Hash.new(0)) { |hash,value| hash[value] += 1; hash }
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