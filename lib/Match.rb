class Match
	attr_reader :attribs
	def initialize(hash)
		# sanity checks
		if ! hash.is_a?(Hash)
			raise "Unexpected argument type"
		end
		if ! hash[:full]
			raise "input hash is missing :full key (the full log message)"
		end
		@attribs = hash
	end
	def full_error
		@attribs[:full]
	end
	def hash
		@attribs.hash
	end
	def eql?(other)
		@attribs.eql? other.attribs
	end
end