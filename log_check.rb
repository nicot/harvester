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
            diffInc(matcher)
        elsif size > 0
            diff(matcher)
        else
            ''
        end
    end

    def size
        File.size?(@file).to_i - File.size?(@oldFile).to_i
    end

    def diffInc(matcher)
        # Read the file line by line
        line = %x{wc -l #{@oldFile}}.split.first.to_i
        total = %x{wc -l #{@file}}.split.first.to_i
        while line < total
            matcher.match(read(line, line+1))
        end
    end

    def diff(matcher)
        # Slurp all of the new lines into memory
        line = %x{wc -l #{@file}}.split.first.to_i - %x{wc -l #{@oldFile}}.split.first.to_i
        matcher.match(`tail -n #{line} #{@file}`)
    end
end

TAIL_BUF_LENGTH = 3 #FIXME
CONFIGS.each do |config|
    config.runMatchers
end

#TODO DELETEME for deployment
#load "spec.rb"
