module Matchers
	# Matchers
	def self.brick(string)
        string.scan(/^(.*\s+kernel:\s+(.*)\s+rejecting I\/O to offline device)$/)
        .map{|full,device| {:full => full, :device => device}}
	end
end
