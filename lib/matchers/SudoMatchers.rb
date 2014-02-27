module Matchers
	# Matchers
	def self.notAuthorized(string)
		string.scan(/^(.*\s+sudo:\s+(.*)\s+:\s+user NOT authorized on host.*)$/)
		.map{|full,user| {:full => full, :user => user}}
	end

	def self.notInSudoers(string)
		string.scan(/^(.*\s+sudo:\s+(.*)\s+:\s+user NOT in sudoers.*)$/)
		.map{|full,user| {:full => full, :user => user}}
	end
end