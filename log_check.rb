#!/usr/bin/env ruby
require_relative 'config'

class Log
    def initialize(file, oldFile)
        @file = file
        @oldFile = oldFile
        # arbitrary limit of 100 MB ~ 10^8 bytes
        @@max = 10**5
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
        # Read the file bit by bit
        # Possible errors: There's not a newline in 1000 characters.
        # Solution: Write better log messages.
        handle = File.new(@file)
        handle.sysseek(File.size?(@oldFile).to_i)
        # We need to define size.
        # We could do until we find a newline.
        # What we really want is paragraphs, or groups of semantic meaning.
        # It's important that we send the whole thing into the matcher.
        # So the tricky thing is finding the right number of bytes to read.
        content = handle.sysread(@@max)
        bytes = @@max - content.reverse.index("\n")
        handle.sysseek(@@max-bytes, IO::SEEK_CUR)
        content = content.slice(0, bytes)
        File.open(@oldFile, 'a') { |handle| handle.write(content) } #Commented out for development
        puts matcher.match(content)
    end
end

CONFIGS.each do |config|
    config.runMatchers
end
