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

	#def self.respondToMatches(matchesHash)
		#matchesHash[:notAuthorized].each do
	#end

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