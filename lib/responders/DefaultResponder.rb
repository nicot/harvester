class DefaultResponder < Responder
	def respond(matchSet)
		puts matchSet.full_errors.join("\n")
	end
end
