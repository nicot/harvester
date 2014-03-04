#Matchers
require './lib/matchers/sudo/NotAuthorizedMatcher.rb'
require './lib/matchers/sudo/NotInSudoersMatcher.rb'
require './lib/matchers/sudo/RMTEInfoFilterMatcher.rb'
require './lib/matchers/kernel/RejectingIOToOfflineDeviceMatcher.rb'

#Responders
require './lib/Responder.rb'

$logConfigs = {
	"../sudo.log" => [
		{
			:matchers => [
				RMTEInfoFilterMatcher.new
				#NotAuthorizedMatcher.new
				#NotInSudoersMatcher.new
			],
		 	:responders => [
		 		DefaultResponder.new
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
