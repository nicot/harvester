class Matcher
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
end