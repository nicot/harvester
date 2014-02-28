class Match
	@attribs = {}
	def initialize(hash)
		@attribs = hash
	end
	def full_error
		@attribs[:full] || ""
	end
end
