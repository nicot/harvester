#!/usr/bin/env ruby

#require 'bundler/setup'
require 'optparse'
require 'pp'
require './lib/matchers.rb'
require './lib/responders.rb'
require './lib/utils.rb'

debug_level = 1 # Higher == more detail

options = {"file" => nil, "out" => nil, "config" => "./etc/config.rb"}
OptionParser.new do |opts|
    opts.banner = "Usage: log_check.rb [options]"
    opts.on('-h', '--help', 'This help information') do
        puts opts
        exit
    end
    opts.on('-f', '--file filepath', 'Specifies a file to check') do |filepath|
        options["file"] = filepath
    end
    opts.on('-c', '--config config', 'Specifies a file to check') do |config|
        options["config"] = config
    end
    opts.on('-v', '--verbose', 'Provides more output for debugging purposes') do |level|
        debug_level = 2
    end
end.parse!

# Read in config file
begin
    eval(File.open(options["config"]).read) # Creates LogConfigs
rescue
    puts "The config file has a syntax error"
end

# check if command line specified file exists in config, and if so, load it
if options["file"]
    argfile = options["file"]
    if $logConfigs.has_key?(argfile)
        $logConfigs = {argfile => $logConfigs[argfile]}
    else
        puts "Error: #{argfile} must be in the config file"
        exit
    end
end

$logConfigs.each do |file, config|
	copy_file = file + ".copy"
	

	##############################################
	#### Read in the new part of the log file

	# Check if the log file exists
	if !File.exist?(file) 
		if debug_level > 0
			puts "The log file "+file+" does not exist."
		end
		next
	end

	# TODO: In the following block, replace shell commands with ruby code
	#  The only one to watch out for is "wc -l" we don't want to accidentally 
	#  read the whole file; it could potentially be a LOT of lines

	# Open the log file, and read the first line
	log_firstline = `head -1 #{file}`
	logfile_contents = ""

	# If there's a copy file
	if (File.exist?(copy_file))
		# Read the first line from the copy file
		copyfile_firstline = `head -1 #{copy_file}`

		# compare the first lines from each file. 
		if (log_firstline != copyfile_firstline)
			# If they differ, the log has been rotated since the last run.

			# So, we should blank out the copy
			File.open(copy_file, 'w') { |handle| handle.write("")}
			# This will prevent the copy of the log growing infinitely long
		end
		# Now we need to "diff" the files and store the result into a variable
		# iow: only grab the new log messages (since the last time this script ran)
		
		# An easy way to do this is to count the number of lines in the copy file, 
		#  and take that many lines off the top of the real file, then use the rest
		copyfile_linecount = %x{wc -l #{copy_file}}.split.first.to_i
		logfile_contents = `tail -n +#{copyfile_linecount+1} #{file}`

	# Else
	else
		# Read in the whole thing to a variable (same variable as above)
		logfile_contents = `cat #{file}`
	end
	##############################################
	##############################################
	#### Matcher/Responder logic

	# Get all the matchers
	allMatchers = config.map{|x| x[:matchers]}.flatten.uniq
	# Run those matchers and store the results
	allMatches = Utils.findMatches(logfile_contents, allMatchers)


	# Pass the appropriate subset of matches into each responder
	config.each do |mrSet|
		matcherNames = mrSet[:matchers].map{|method| method.name}
		relevantMatches = allMatches.select {|name,matches| matcherNames.include? name}.values.flatten

		responders = mrSet[:responders]
		responders.each do |responder|
			responder.call relevantMatches
		end
	end

	### Check the variable against each of the appropriate matchers (as defined in the config)
	#matchesHash = Utils.findMatches(logfile_contents, matchers)
	#Utils.processMatches(matchesHash, responders, LogCheckConfig)
	##############################################
	##############################################
	#### Write out differences to the copy file
	# This is commented out for development, so that we don't
	#  have to empty the copy logfile every time
	#File.open(copy_file, 'a') { |handle| handle.write(logfile_contents)}
	##############################################
end
