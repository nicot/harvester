#!/usr/bin/env ruby

#require 'bundler/setup'
require 'optparse'

# include all the project class files

## Read in options
#  --help|-h  -- prints a usage message
#  --output_format  -- mail, nagios, details, etc
#  --files=<string>  -- A string defining which files to check. If this option is left off, do all files
# TODO: read in options

options = {:files => nil, :out => nil}
OptionParser.new do |opts|
    opts.banner = "Usage: log_check.rb [options]"

    opts.on('-h', '--help', 'This help information') do
        puts opts
        exit
    end

    opts.on('-o', '--output_format out', 'Mail, Nagios, details, etc') do |out|
        options[:out] = out
    end

    # Currently this only takes one file, could be improved.
    opts.on('-f', '--files filepath', 'The files to check') do |filepath|
        options[:files] = filepath
    end
end.parse!


p options # debugging

## Read in config file
# TODO: read in the config file - this defines what log files to look in, and what
# matchers to apply to each

###########################
#- NOTE: this approach is inspired by the existing check_log nagios script
#- Essentially, it keeps a copy of the log from the last time it was run,
#- compares the two, and only processes the differences.
###########################

## For each logfile
### Open the log file
### If there's a copy file
#### compare the first lines from each file.
#--- If they differ, the log has been rotated since the last run.
##### Blank out the copy
#---- This will prevent the copy of the log growing infinitely long
#--- Now we have two files to diff
#### Diff the files and store the result into a variable
### Else
#### Read in the whole thing to a variable (same variable as above)
### Check the variable against each of the appropriate matchers (as defined in the config)
### For Anything that matches, use the response for the matcher to determine what to do
### Write out differences to the copy file
### Close the file


## Once all the log files have been processed, use the options to determine what to do
