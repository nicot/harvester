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
    oldfile = specs[0]
    matcher = specs[1]
    diff = []
    # if the file doesn't exist, thats ok, skip this loop.
    if not File.exist?(file)
        next
    end
    # Open the log file
    log = File.read(file).split("\n")
    # If there's a copy file
    if File.exist?(oldlog)
    # compare the first lines from each file.
        oldlog = File.read(oldfile).split("\n")
        # If they differ, the log has been rotated since the last run.
        if oldlog.first != log.first
            # Blank out the copy
            File.open(oldfile, 'w') { |zoomba| zoomba.write("")}
        end
        # Diff the files and store the result into a variable
        log.each_with_index do |line, index|
            if !oldlog[index]
                diff.append(line)
            elsif line != oldlog[index]
                diff.append(line)
            end
        end
    else
        # Read in the whole thing to a variable (same variable as above)
        diff = log
    end
    # Check the variable against each of the appropriate matchers (as defined in the config)
    # Should the matcher be defined in the config or the matchers.rb?
    diff.each do |line|
        # import the matcher file.
        # match each line against every matcher.
        # I wonder if this is the most efficient way to do it.
        # if a line doesn't get tagged by any filters, it stays in diff
    end
    # For Anything that matches, use the response for the matcher to determine what to do
    # Write out differences to the copy file
    # Close the file
    # Once all the log files have been processed, use the options to determine what to do
end
# AGGH BUT WHAT IF THE LOG GETS ROTATED WHILE AN ERROR IS ON THE END
# Solutions: We could use 'inotify' to run the script on a specific
# file when it is updated
