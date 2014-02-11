# initialize matchers for all messages appearing in sudo.log
def match(difference)
    difference.each do |line|
        if /vim/ =~ line
            difference.delete(line)
        end
    end
end
