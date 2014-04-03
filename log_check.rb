#!/usr/bin/env ruby
require_relative 'config'

class Log
    def initialize(file, oldFile)
        @file = file
        @oldFile = oldFile
        # arbitrary limit of 100 MB ~ 10^8 bytes
        # 10**8 is around the max that my (wimpy) machine can handle
        @@max = 10**8
        @@matcherSize = 10**6
    end
    
    def new?
        if File.exist?(@oldFile)
            first = File.open(@file, &:gets)
            firstOld = File.open(@oldFile, &:gets)
            first != firstOld
        else
            true
        end
    end
    
    def run(matcher)
        if not File.exist?(@file)
            warn 'File #{@file} does not exist.' # maybe delete for deployment
            return ''
        end

        # If the first lines of the files are different its a new log so blank out the @oldFile
        if new?
            File.open(@oldFile, 'w') { |handle| handle.write('') }
        end
        
        # If we would read a ton of new logs into memory, do it line by line.
        while size > 0
            read(matcher)
        end
    end

    def size
        File.size?(@file).to_i - File.size?(@oldFile).to_i
    end

    def read(matcher)
        handle = File.new(@file)
        handle.sysseek(File.size?(@oldFile).to_i)
        content = handle.sysread(@@max)
        handle.sysseek(@@matcherSize, IO::SEEK_CUR)
        File.open(@oldFile, 'a') { |handle| handle.write(content) }
        puts matcher.match(content)
    end
end

CONFIGS.each do |config|
    config.runMatchers
end
