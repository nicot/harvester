#Matchers
require './lib/matchers/DefaultMatcher.rb'
require './lib/matchers/SudoMatcher.rb'
require './lib/matchers/RMTEInfoFilterMatcher.rb'
require './lib/matchers/RejectingIOToOfflineDeviceMatcher.rb'

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
