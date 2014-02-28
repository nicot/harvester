#Matchers
require './lib/matchers/sudo/NotAuthorizedMatcher.rb'
require './lib/matchers/sudo/NotInSudoersMatcher.rb'
require './lib/matchers/kernel/RejectingIOToOfflineDeviceMatcher.rb'

#Responders
require './lib/responders/DefaultResponder.rb'

$logConfigs = {
	"../sudo.log" => [
		{
			:matchers => [
				NotAuthorizedMatcher.new,
				NotInSudoersMatcher.new
			],
		 	:responders => [
		 		DefaultResponder.new
		 	]
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