#!/usr/bin/env ruby

#require 'bundler/setup'
require 'optparse'
require 'yaml'

options = {"file" => nil, "out" => nil}
OptionParser.new do |opts|
    opts.banner = "Usage: log_check.rb [options]"
    opts.on('-h', '--help', 'This help information') do
        puts opts
        exit
    end
    opts.on('-o', '--output_format out', 'Mail, Nagios, details, etc') do |out|
        options["out"] = out
    end
    opts.on('-f', '--file filepath', "Specifies a file to check") do |filepath|
        options["file"] = filepath
    end
end.parse!

# check if command line specified file exists
if options["file"]
    argfile = options["file"]
    if config.has_key?(argfile)
        config = {argfile => config[argfile]}
    else
        puts "Error: ${argfile} must be in etc/config.yaml"
        exit
    end
end

# Read in config file
configs = YAML.load_file('etc/config.yaml')

exitcode = 0
output = []

def chunk(file, oldfile)
    newproblems = []
    log = File.read(file).split("\n")
    if File.exist?(oldfile)
        oldlog = File.read(oldfile).split("\n")
        if oldlog.first != log.first
            File.open(oldfile, 'w') { |handle| handle.write("")}
        end
        log.each_with_index do |line, index|
            if !oldlog[index]
                newproblems.push(line)
            elsif line != oldlog[index]
                newproblems.push(line)
            end
        end
    else
        newproblems = log
    end
    return newproblems
end

# For each config
configs.each do |title, specs|
    # each of these is a string filepath
    file = specs[0]
    oldfile = specs[1]
    matcher = specs[2]

    require matcher
    errors = []

    # if the file doesn't exist, thats ok, skip this loop.
    if not File.exist?(file)
        next
    end

    errors = chunk(file, oldfile)
    # This match function is defined in the most recently imported file
    errors = match(errors)
    exitcode += errors.count
    output.push(errors)

    # Write out differences to the copy file
    File.open(oldfile, 'w') { |handle| handle.write(File.read(file))}
end

if exitcode > 2
    exitcode = 2
end
if exitcode > 0
    if options["out"] == "nagios"
        puts "New unusual logs found."
    elsif options["out"] == "mail"
        # TODO this should probably mail somebody
        puts output
    else
        puts output
    end
end
exit exitcode
