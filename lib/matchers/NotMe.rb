class NotMe < Matcher
	def match(string)
        matches = []
        string.split("\n").each do |line| 
            matches << line unless line =~ /doto7679/
        end
        package(matches.map{|full| {:full => full}})
	end
end
