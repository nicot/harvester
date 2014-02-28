class Match
	attr_reader :attribs
	def initialize(hash)
		# TODO: Verify :full key exists, and other assumptions
		@attribs = hash
	end
	def full_error
		@attribs[:full] || ""
	end
end
