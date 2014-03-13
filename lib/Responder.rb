class Responder
	def respond(arrayOfMatches)
		# This method should respond to the matches
		raise NotImplementedError.new("You must implement #{name}.")
	end
end

class Email < Responder
	def respond(matchSet)
		print matchSet.full_errors.join("\n")
        $stdout.flush
	end
end

class Nagios < Responder
    def respond(matchSet)
        case matchSet.exitcode
        when 0
            puts "OK"
            exit 0
        when 1
            puts "WARNING"
            exit 1
        when 2
            puts "CRITICAL"
            exit 2
        else
            puts "UNKOWN - Unexpected exit code recieved"
            exit 3
        end
    end
end
