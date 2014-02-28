#Matchers
require './lib/matchers/sudo/NotAuthorizedMatcher.rb'
require './lib/matchers/sudo/NotInSudoersMatcher.rb'
require './lib/matchers/kernel/RejectingIOToOfflineDeviceMatcher.rb'

#Responders
require './lib/responders/DefaultResponder.rb'
require './lib/responders/SudoResponder.rb'

$logConfigs = {
	"../sudo.log" => [
		{
			:matchers => [
				NotAuthorizedMatcher.new
				#NotInSudoersMatcher.new
			],
		 	:responders => [
		 		SudoResponder.new
		 	],
		 	:behavior => :filter
		}
	],
	"../kern.log" => [
		{
			:matchers => [
				RejectingIOToOfflineDeviceMatcher.new
			],
			:responders => [
				DefaultResponder.new
			]
		}
	]
}