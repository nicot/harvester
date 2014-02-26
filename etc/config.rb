require './lib/matchers/SudoMatchers.rb'
module LogCheckConfig
	extend self
	
	def trustedUsers 
		["kniffin"]
	end
	def file
		"../sudo.log"
	end
	def old_file 
		"../sudo.log.old"
	end
	def matchers 
		[SudoMatchers.method(:notAuthorized),
		 SudoMatchers.method(:notInSudoers)]
	end
	def responders 
		[SudoMatchers.method(:notAuthorizedResponder)]
	end
end

