require_relative 'matcher'
class CatchAllMatcher < Matcher
    def self.match(string)
        string.scan(/^.*$/)
    end
end
