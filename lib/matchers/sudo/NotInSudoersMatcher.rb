class NotInSudoersMatcher < Matcher
	def match(string)
		package(string.scan(/^(.*\s+sudo:\s+(.*)\s+:\s+user NOT in sudoers.*)$/)
		.map{|full,user| {:full => full, :user => user}})
	end
end