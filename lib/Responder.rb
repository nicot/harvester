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
            warn "OK"
            exit 0
        when 1
            warn "WARNING"
            exit 1
        when 2
            warn "CRITICAL"
            exit 2
        else
            warn "UNKOWN - Unexpected exit code recieved"
            exit 3
        end
    end
end
