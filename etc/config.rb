#Matchers
require './etc/matchers/DefaultMatcher.rb'
require './etc/matchers/SudoMatcher.rb'
require './etc/matchers/RMTEInfoFilterMatcher.rb'
require './etc/matchers/RejectingIOToOfflineDeviceMatcher.rb'

{
	"../sudo.log" => [
		{
			:matchers => [
                #Authorized.new,
                NotMe.new
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
