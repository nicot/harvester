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
