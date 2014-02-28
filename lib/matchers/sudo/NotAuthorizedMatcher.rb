class NotAuthorizedMatcher < Matcher
	def match(string)
		package(string.scan(/^(.*\s+sudo:\s+(.*)\s+:\s+user NOT authorized on host.*)$/)
		.map{|full,user| {:full => full, :user => user}})
	end
end
