class Log
    def initialize(specs)
        @file = specs[0]
        @oldfile = specs[1]
        @matcher = specs[2]
        @errors = Array.new
        @exitcode = 0
    end

    def errors
        return @errors
    end

    def importMatch
        # This is not so great. If the adversary doesn't define matcher
        # in the lib/matchers/*.rb we catch all errors defined by the
        # last one.
        load @matcher
        match(@errors)
    end

    def chunk
        log = File.read(@file).split("\n")
        if File.exist?(@oldfile)
            oldlog = File.read(@oldfile).split("\n")
            if oldlog.first != log.first
                File.open(@oldfile, 'w') { |handle| handle.write("")}
            end
            log.each_with_index do |line, index|
                if !oldlog[index]
                    @errors.push(line)
                elsif line != oldlog[index]
                    @errors.push(line)
                end
            end
        else
            @errors = log
        end
    end

    def fileExist
        return File.exist?(@file)
    end

    def clean
        File.open(@oldfile, 'w')\
            { |handle| handle.write(File.read(@file))}
    end
end
