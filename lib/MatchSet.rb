class MatchSet
	@matches
	def initialize(array=[])
		@matches = array
	end
	def append(obj)
		if obj.is_a?(Match)
			@matches.push(obj)
		elsif obj.is_a?(MatchSet)
			@matches |= MatchSet.matches
		else
			raise "Cannot append #{obj.class.name} to MatcheSet"
		end
	end
	def matches
		@matches
	end
	def full_errors
		@matches.map { |match| match.full_error }
	end
end
