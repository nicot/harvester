class SudoMatchers
	def self.run(string)
		# This method should find all matches, and gather any important information about them,
		#  such as user, command, etc
		matchesHash = {}

		# user NOT authorized on host
		matchesHash[:notAuthorized] = string
			# TODO: Fix this. Between "sudo:" and the user, there could be an [ID #### auth.notice]
			.scan(/^(.*\s+sudo:\s+(.*)\s+:\s+user NOT authorized on host.*)$/)
			.map{|full,user| {:full => full, :user => user}}

		matchesHash
	end
end


# class SudoMatcher < Matcher
# 	def matches?(string)
# 		string.scan(/^.*user NOT in sudoers.*$/)
# 	end
# end