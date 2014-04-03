#!/usr/bin/env ruby
require_relative 'config'

class Log
    def initialize(file, oldFile)
        @file = file
        @oldFile = oldFile
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
            warn "File #{@file} does not exist." # maybe delete for deployment
            return ''
        end

        # If the first lines of the files are different its a new log so blank out the @oldFile
        if new?
            File.open(@oldFile, 'w') { |handle| handle.write("") }
        end
        
        # If we would read a ton of new logs into memory, do it line by line.
        if size > 10**8 # arbitrary limit of 100 MB ~ 10^8 bytes
            readInc(matcher)
        elsif size > 0
            read(matcher)
        else
            ''
        end
        #copy over the new file
    end

    def size
        File.size?(@file).to_i - File.size?(@oldFile).to_i
    end

    def readInc(matcher)
        # Read the file bit by bit
        # Possible errors: There's not a newline in 1000 characters.
        # Solution: Write better log messages.
        handle = File.new(@file)
        handle.sysseek(File.size?(@oldFile).to_i)
        # We need to define size.
        # We could do until we find a newline.
        # What we really want is paragraphs, or groups of semantic meaning.
        # It's important that we send the whole thing into the matcher.
        #matcher.match(handle.sysread(bytes))
        bytes = handle.sysread(1000).reverse.index("\n")
        handle.sysseek(-1000, IO::SEEK_CUR)
        matcher.match(handle.sysread(1000-bytes))
    end

    def read(matcher)
        # Slurp it all into memory!
        handle = File.new(@file)
        handle.sysseek(File.size?(@oldFile).to_i)
        matcher.match(handle.sysread(size))
    end
end

CONFIGS.each do |config|
    config.runMatchers
end
