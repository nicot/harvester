#!/usr/bin/env ruby

#require 'bundler/setup'
require 'optparse'
require 'yaml'
load 'lib/matcher.rb'

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

output = Array.new
loglist = Array.new

# For each config
configs.each do |title, specs|
    loglist.push(Log.new(specs))
end

loglist.each do |current|
    # if the file doesn't exist, thats ok, skip this loop.
    if not current.fileExist
        next
    end

    current.clean
end

if output.length > 0
    if options["out"] == "nagios"
        puts "New unusual logs found."
    elsif options["out"] == "mail"
        # TODO this should probably mail somebody
        puts output
    else
        puts output
    end
end
#exit exitcode
