class Sudo
    def match(newMessage)
        newMessage.each do |line|
            # Match each line
            if /vim/ =~ line
                # Take it out if we don't care
                newMessage.delete(line)
            end
            if /jason/ =~ line
                # Upgrade the priority if its scary
                @exitcode = 2
            end
        end
    end
end
