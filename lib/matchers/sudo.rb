class Sudo
    def match(difference)
        difference.each do |line|
            if /vim/ =~ line
                difference.delete(line)
            end
        end
    end
end
