module Utils
	def self.findMatches(string, matchers)
		# This method should find all matches, and gather any important information about them,
		#  such as user, command, etc
		matchesHash = {}

		matchers.each do |matcher|
			# This line basically says:
			#  run the method who's name is in the matcher, with the argument string
			matchesHash[matcher.name] = matcher.call string
		end
		matchesHash
	end

	def self.processMatches(matchesHash, responders, configs)
		# This method should take in the hash of matches, a list of responder methods
		# and some configs. It should run those responders, which will print stuff
		responders.each do |responder|
			responder.call matchesHash, configs
		end
	end

	def self.userCount(array)
		# Given an array like this:
		# [{:full=> "some long string of stuff", :user=> "kniffin"},
		#  {:full=> "some other long line of stuff", :user=>"schoelle"},
     	#  {:full=> "more stuff", :user=>"schoelle"},
     	#  {:full=> "even more stuff", :user=>"thle5086"}]

		# Return a hash describing how many times a user shows up in the array:
		# {"kniffin"=> 1, "schoelle"=> 2, "thle5086" => 1}

		array.map {|x| x[:user]}
		.inject(Hash.new(0)) { |hash,value| hash[value] += 1; hash }
	end
end