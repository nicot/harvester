class Log
    def initialize(specs)
        @file = specs[0]
        @oldfile = specs[1]
        @matcher = specs[2]
        @errors = Array.new
        @exitcode = 0
        require @matcher
    end

    def chunk(file, oldfile)
        newProblems = []
        log = File.read(file).split("\n")
        if File.exist?(oldfile)
            oldlog = File.read(oldfile).split("\n")
            if oldlog.first != log.first
                File.open(oldfile, 'w') { |handle| handle.write("")}
            end
            log.each_with_index do |line, index|
                if !oldlog[index]
                    newProblems.push(line)
                elsif line != oldlog[index]
                    newProblems.push(line)
                end
            end
        else
            newProblems = log
        end
        return newProblems
    end

    def fileExist
        return File.exist?(@file)
    end

    def clean
        File.open(@oldfile, 'w')\
            { |handle| handle.write(File.read(@file))}
    end
end
