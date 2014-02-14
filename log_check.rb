#!/usr/bin/env ruby

#require 'bundler/setup'
require 'optparse'
require 'yaml'
require 'pp'
load 'lib/matcher.rb'

debug_level = 1 # Higher == more detail

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

# Read in config file
configs = YAML.load_file('etc/config.yaml')

# check if command line specified file exists in config
if options["file"]
    argfile = options["file"]
    if configs.has_key?(argfile)
        configs = {argfile => configs[argfile]}
    else
        puts "Error: ${argfile} must be in etc/config.yaml"
        exit
    end
end

matchesHash = {}

## For each logfile
configs.each do |title, spec|
	file = spec['file']
	old_file = spec['old_file']
	matchers = spec['matchers']

	### Check if the file exists
	if !File.exist?(file) 
		if debug_level > 0
			puts "The log file for "+title+" does not exist."
		end
		next
	end

	### Open the log file, and read the first line
	log_firstline = `head -1 #{file}`
	logfile_contents = ""

	### If there's a copy file
	if (File.exist?(old_file))
		### Read the first line from the oldlog file
		oldlog_firstline = `head -1 #{old_file}`
		#### compare the first lines from each file. 
		#--- If they differ, the log has been rotated since the last run.
		if (log_firstline != oldlog_firstline)
			##### Blank out the copy
			#---- This will prevent the copy of the log growing infinitely long
			File.open(old_file, 'w') { |handle| handle.write("")}
		end
		#--- Now we have two files to diff
		#### Diff the files and store the result into a variable
		# An easy way to do this is to count the number of lines in the copy file, 
		#  and take that many lines off the top of the real file, then use the rest
		oldfile_linecount = %x{wc -l #{old_file}}.split.first.to_i
		logfile_contents = `tail -n +#{oldfile_linecount+1} #{file}`

	### Else
	else
		#### Read in the whole thing to a variable (same variable as above)
		logfile_contents = `cat #{file}`
	end
	### Check the variable against each of the appropriate matchers (as defined in the config)
	matchers.each do |matcher|
		require './lib/matchers/'+matcher+'.rb'
		matchesHash[matcher] = eval(matcher).run(logfile_contents)
	end



	### Write out differences to the copy file
	#File.open(old_file, 'a') { |handle| handle.write(logfile_contents)}

	### Close the file
	
end



if matchesHash.length > 0
    if options["out"] == "nagios"
        puts "New unusual logs found."
    elsif options["out"] == "mail"
        # TODO this should probably format the output in an email-friendly way
        puts output
    else
        pp matchesHash
    end
end
