#Matchers
require './lib/matchers/NotAuthorizedMatcher.rb'
require './lib/matchers/NotInSudoersMatcher.rb'
require './lib/matchers/RMTEInfoFilterMatcher.rb'
require './lib/matchers/RejectingIOToOfflineDeviceMatcher.rb'

{
	"../sudo.log" => [
		{
			:matchers => [
				RMTEInfoFilterMatcher.new,
                CatchAllMatcher.new
			],
		 	:responders => [
		 		Email.new
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
