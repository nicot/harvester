module Utils
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