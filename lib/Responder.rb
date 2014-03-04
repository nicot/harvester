class Responder
	def respond(arrayOfMatches)
		# This method should respond to the matches
		raise NotImplementedError.new("You must implement #{name}.")
	end
end

class DefaultResponder < Responder
	def respond(matchSet)
		puts matchSet.full_errors.join("\n")
	end
end

# Custom responder with complex logic for sudo log, with trusted users, etc
class SudoResponder < Responder
	def initialize
		@trustedUsers = ["kniffin"]
	end
	def respond(matchSet)
		userCountHash = userCount(matchSet)
		puts matchSet.matches
			.select { |match|
				# The user for the match
				matchUser = match.attribs[:user]
				# Boolean: is the user in the trusted users list
				inTrustedUsers = @trustedUsers.include? matchUser
				# How many times does the user show up in the userCount
				count = userCountHash[matchUser]
				# Finally, return a boolean for if it's "okay" or not
				((inTrustedUsers && count > 2) || (!inTrustedUsers && count > 0))
			}
			.map{|match| match.full_error}
	end

	def userCount(matchSet)
		# Given an array like this:
		# [{:full=> "some long string of stuff", :user=> "kniffin"},
		#  {:full=> "some other long line of stuff", :user=>"schoelle"},
     	#  {:full=> "more stuff", :user=>"schoelle"},
     	#  {:full=> "even more stuff", :user=>"thle5086"}]

		# Return a hash describing how many times a user shows up in the array:
		# {"kniffin"=> 1, "schoelle"=> 2, "thle5086" => 1}

		matchSet.matches.map {|match| match.attribs[:user]}
		.inject(Hash.new(0)) { |hash,value| hash[value] += 1; hash }
	end
end
