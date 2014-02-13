class Log
    # All matchers should have the same "new" method
    def new(specs)
        @file = specs[0]
        @oldfile = specs[1]
        @matcher = specs[2]
        @errors = Array.new
        @exitcode = 0
    end
end
