#!/usr/bin/env ruby

# TODO get rid of all the bad hardcoded filepaths.
# TODO figure out what bundler is for, and if we need it. I think we don't because
# we don't have any gems except the testing one, and that doesn't need to be disted?
#require 'bundler/setup'
require 'optparse'
require 'yaml'

# include all the project class files

## Read in options
#  --help|-h  -- prints a usage message
#  --output_format  -- mail, nagios, details, etc
#  --files=<string>  -- A string defining which files to check. If this option is left off, do all files

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

## Read in config file

config = YAML.load_file('etc/config.yaml')
if options["file"]
    if config.has_key?(options["file"])
        config = {options["file"] => config[options["file"]]}
    else
        puts "Error: file must be in etc/config.yaml"
        exit
    end
end

###########################
#- NOTE: this approach is inspired by the existing check_log nagios script
#- Essentially, it keeps a copy of the log from the last time it was run,
#- compares the two, and only processes the differences.
###########################

## For each logfile
config.each do |file, specs|
    oldlog = specs[0]
    matcher = specs[1]
    if not File.exist?(file)
        print "File #{file} specified in etc/config.yaml does not exist"
        exit
    end
### Open the log file
    log = File.read(file)
### If there's a copy file
    if File.exist?(oldlog)
#### compare the first lines from each file.
        if oldlog.split("\n").first == log.split("\n").first

        end
#--- If they differ, the log has been rotated since the last run.
##### Blank out the copy
#---- This will prevent the copy of the log growing infinitely long
#--- Now we have two files to diff
#### Diff the files and store the result into a variable
    else
### Else
#### Read in the whole thing to a variable (same variable as above)
### Check the variable against each of the appropriate matchers (as defined in the config)
### For Anything that matches, use the response for the matcher to determine what to do
### Write out differences to the copy file
### Close the file
    end
## Once all the log files have been processed, use the options to determine what to do
end
