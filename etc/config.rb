#Matchers
require './lib/matchers/NotAuthorizedMatcher.rb'
require './lib/matchers/NotInSudoersMatcher.rb'
require './lib/matchers/RMTEInfoFilterMatcher.rb'
require './lib/matchers/RejectingIOToOfflineDeviceMatcher.rb'

#Responders
require './lib/Responder.rb'

$logConfigs = {
	"../sudo.log" => [
		{
			:matchers => [
				RMTEInfoFilterMatcher.new
			],
		 	:responders => [
		 		Email.new
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
				Email.new
			]
		}
	]
}
