class Matcher
	def self.findMatches(string, matchers)
		# This method should find all matches, and gather any important information about them,
		#  such as user, command, etc
		matchesHash = {}

		matchers.each do |matcher|
			# This line basically says:
			#  run the method who's name is in the matcher, with the argument string
			matchesHash[matcher] = send matcher, string
		end
		matchesHash
	end

	def self.processMatches(matchesHash, responders, configs)
		# This method should take in the hash of matches, a list of responder methods
		# and some configs. It should run those responders, which will print stuff
		responders.each do |responder|
			send(responder, matchesHash, configs)
		end
	end
end