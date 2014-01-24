class Matcher
	def initialize(matchBlock, responseBlock)
		# TODO: research blocks, procs, and lambdas
		# http://www.robertsosinski.com/2008/12/21/understanding-ruby-blocks-procs-and-lambdas/
		# matchBlock - A block that is used to check the log against to see if it matches
		# responseBlock - A block with the logic for how to respond. This will probably be "Good" or "Bad"
	end
end