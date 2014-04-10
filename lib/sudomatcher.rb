require_relative 'matcher'
require_relative '../etc/trusted_users'

class SudoMatcher < Matcher
	def self.match(string)
        results = Array.new
        string.split("\n").each do |line|
            user = line.split(/\s+/)[5].strip
            results << line unless TRUSTED_USERS.include? user
        end
        return results
    end
end

=begin
Let's weed out everything from the following:

../etc/trusted_users

Also, we don't need to see people on their own boxes, although that's
more difficult.
=end
