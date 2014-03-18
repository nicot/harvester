class Matcher
    def self.match(string)
        raise NotImplementedError.new("You must implement a matcher.")
    end
end

class SudoMatcher < Matcher
    def self.match(string)
        string.scan(/^.*yum.*$/)
    end
end

class CatchAllMatcher < Matcher
    def self.match(string)
        string
    end
end
