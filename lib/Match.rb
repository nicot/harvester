class Match
    # The Match class is what we store our results in
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

class Matcher
	def match(string)
		# This method should match something in the string
		raise NotImplementedError.new("You must implement #{name}.")
	end

	private
		def package(array)
			MatchSet.new(array.map{|hash| Match.new(hash)})
		end
end

class CatchAllMatcher < Matcher
	def match(string)
		package(string.scan(/^(.*)$/).map{|full| {:full => full}})
	end
end
