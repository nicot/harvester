class RejectingIOToOfflineDeviceMatcher < Matcher
	def match(string)
        package(string.scan(/^(.*\s+kernel:\s+(.*)\s+rejecting I\/O to offline device)$/)
        .map{|full,device| {:full => full, :device => device}})
	end
end