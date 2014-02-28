class RMTEInfoFilterMatcher < Matcher
	def match(string)
		package(string.scan(/^(.*rmteinfo.*)$/).map{|full| {:full => full}})
	end
end