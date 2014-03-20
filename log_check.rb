#!/usr/bin/env ruby
require_relative 'config'

class Log
    def initialize(file, oldFile)
        @file = file
        @oldFile = oldFile
    end
    
    def new?
        first = File.open(@file, 'r') { |handle| handle.readline()}
        firstOld = File.open(@oldFile, 'r') { |handle| handle.readline()}
        first == firstOld
    end
    
    def run(matcher)
        if not File.exist?(@file)
            warn "File #{@file} does not exist." # maybe delete for deployment
            return ''
        end

        # If the first lines of the files are different, its a new log so blank out the @oldFile
        if new?
            File.open(@oldFile, 'w') { |handle| handle.write("") }
        end
        
        # If we would read a ton of new logs into memory, do it line by line.
        if size > 10**8 # arbitrary limit of 100 MB ~ 10^8 bytes
            diffInc(matcher)
        else
            diff(matcher)
        end
    end

    def size
        # Size is in bytes
        if File.exist?(@oldFile)
            File.size?(@file)-File.size?(@oldFile)
        else
            File.size?(@file)
        end
    end

    def read(from, to)

    end

    def diffInc(matcher)
        # Read the file line by line
        lineCount = %x{wc -l #{@oldFile}}.split.first.to_i
        if (File.exist?(@oldFile))
        else
            File.readline(file)
        end
    end

    def diff(matcher)
        # Slurp all of the new lines into memory
        lineCount = %x{wc -l #{@oldFile}}.split.first.to_i
        matcher.match(read(lineCount, Nil))
    end
end

CONFIGS.each do |config|
    config.runMatchers
end

#TODO DELETEME for deployment
#load "spec.rb"
