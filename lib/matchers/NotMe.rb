class NotMe < Matcher
	def match(string)
        matches = []
        string.split("\n").each do |line| 
            matches << line unless line =~ /doto7679/
        end

        exitcode = []
        matches.each do |line|
            if line =~ /wenzl/
                exitcode << 2
            else
                exitcode << 1
            end
        end

        matches = matches.zip(exitcode)
        package(matches.map{|full,exitcode| {:full => full, :exitcode => exitcode}})
	end
end
