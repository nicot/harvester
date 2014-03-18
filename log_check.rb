#!/usr/bin/env ruby
require_relative 'config'

class Logs
    # NOTE This reading method slurps the entire file in, which doesn't scale
    # well with memory. The alternative is chunking the pieces semantically.
    # One way to do this is to have each matcher run line by line, but only if
    # if the previous line matches.
    def self.diff(file, oldFile)
        first = File.open(file, 'r') { |handle| handle.readline()}
        firstOld = File.open(oldFile, 'r') { |handle| handle.readline()}
        # If the first lines of the files are different, its a new log so blank out the oldfile
        if (firstOld != first)
            File.open(oldfile, 'w') { |handle| handle.write("") }
        end
        lineCount = %x{wc -l #{oldFile}}.split.first.to_i
        `tail -n +#{lineCount+1} #{file}`
    end

    def self.read(file)
        oldFile = file + ".old"
        if (File.exist?(oldFile))
            diff(file, oldFile)
        else
            File.read(file)
        end
    end
end

CONFIGS.each do |config|
    config.runMatchers
end

#TODO DELETEME for deployment
#load "spec.rb"
