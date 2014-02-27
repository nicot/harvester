require './lib/matchers/SudoMatchers.rb'

$logConfigs = {
	"../sudo.log" => [
		{
			:matchers => [
				Matchers.method(:notAuthorized),
				Matchers.method(:notInSudoers)
			],
		 	:responders => [
		 		Responders.method(:notAuthorizedResponder)
		 	]
		},
		{
			:matchers => [
				Matchers.method(:notAuthorized)
			],
		 	:responders => [
		 		Responders.method(:notAuthorizedResponder)
		 	]
		}
	]
}

# The idea here should be that we will run a bunch of matchers, that pull out pieces into a hash;
# Then, we run a bunch of responders on various pieces of that hash, based on the config above

## Workflow ##
# 1. Pull out all the matchers from above
# 2. Run them all
# 3. Run the various responders with the data relevant to them
