class MatchSet
	attr_reader :matches
	def initialize(obj)
		@matches = []
		if obj.is_a?(Array)
			# Verify the array only consists of Match objects, and then push them into @matches
			obj.each do |element|
				if element.is_a?(Match)
					@matches.push(element)
				else
					raise "MatchSets can only be comprised of Matches, not #{element.class.name}"
				end
			end
		elsif obj.is_a?(MatchSet)
			@matches |= obj.matches
		else
			raise "Cannot create MatchSet from #{obj.class.name}"
		end
	end
	def full_errors
		@matches.map { |match| match.full_error }
	end

	def -(other)
		if other.is_a?(MatchSet)
			MatchSet.new(@matches - other.matches)
		else
			raise "Cannot subtract #{other.class.name} from MatchSet"
		end
	end

end
