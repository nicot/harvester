class MatchSet
	attr_reader :matches
	def initialize(obj)
		# TODO: Verify these are Matches
		@matches = []
		if obj.is_a?(Array)
			@matches |= obj
		elsif obj.is_a?(MatchSet)
			@matches |= obj.matches
		else
			raise "Cannot create MatchSet from #{obj.class.name}"
		end
	end
	def append(obj)
		
	end
	def full_errors
		@matches.map { |match| match.full_error }
	end
end
