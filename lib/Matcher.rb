class Matcher
	def match(string)
		# This method should match something in the string
		raise NotImplementedError.new("You must implement #{name}.")
	end

	def package(array)
		MatchSet.new(array.map{|hash| Match.new(hash)})
	end
end
