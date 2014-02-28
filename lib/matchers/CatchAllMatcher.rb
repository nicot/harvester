class CatchAllMatcher < Matcher
	def match(string)
		package(string.scan(/^(.*)$/).map{|full| {:full => full}})
	end
end