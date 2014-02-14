# This should probably be a proc. The big issue I'm having right now is
# not knowing what file I'm importing, and so I don't know how to overwrite
# functions in a safe way.
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
