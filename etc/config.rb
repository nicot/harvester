#Matchers
require './lib/matchers/NotAuthorizedMatcher.rb'
require './lib/matchers/NotInSudoersMatcher.rb'
require './lib/matchers/RMTEInfoFilterMatcher.rb'
require './lib/matchers/RejectingIOToOfflineDeviceMatcher.rb'
require './lib/matchers/NotMe.rb'

{
	"../sudo.log" => [
		{
			:matchers => [
				RMTEInfoFilterMatcher.new,
                #CatchAllMatcher.new,
                NotMe.new
			],
		 	:responders => [
		 		Nagios.new
		 	]
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
