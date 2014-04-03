require_relative 'matcher'
class SudoMatcher < Matcher
	def self.match(string)
		string.scan(/^.*yum.*$/)
    end
end
