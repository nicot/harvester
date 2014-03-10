#!/usr/bin/env ruby

require 'optparse'
require 'pp'
require './lib/Match.rb'
require './lib/MatchSet.rb'
require './lib/matchers/Matcher.rb'
require './lib/Responder.rb'
require './lib/Utils.rb'

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
	
	if !File.exist?(file) 
		if debug_level > 0
			puts "The log file "+file+" does not exist."
		end
		next
	end

	# NOTE: One flaw with doing things this way is that we end up reading the 
	# whole file into memory. We could potentially run into memory limitations.
	# An alternative to explore at some point would be to change the workflow 
	# to a streaming method, where, as we read in the file, we run the matchers 
	# and then the responders.

	# Open the log file, and read the first line
	log_firstline = File.open(file, 'r') { |handle| handle.readline()}
	logfile_contents = ""

	# If there's a copy file
	if (File.exist?(copy_file))
		# Read the first line from the copy file
		copyfile_firstline = File.open(file, 'r') { |handle| handle.readline()}
		# compare the first lines from each file. 
		if (log_firstline != copyfile_firstline)
			# If they differ, the log has been rotated since the last run.
			# So, we should blank out the copy
			File.open(copy_file, 'w') { |handle| handle.write("")}
			# This will prevent the copy of the log growing infinitely long
		end
		# iow: only grab the new log messages (since the last time this script ran)
		# An easy way to do this is to count the number of lines in the copy file, 
		#  and take that many lines off the top of the real file, then use the rest
		copyfile_linecount = %x{wc -l #{copy_file}}.split.first.to_i
		logfile_contents = `tail -n +#{copyfile_linecount+1} #{file}`
	# Else
	else
		# Read in the whole thing to a variable (same variable as above)
		logfile_contents = File.open(file, 'r') { |handle| handle.read()}
	end

	#### Matcher/Responder logic
	# Get all the matchers
	allMatchers = config.map{|x| x[:matchers]}.flatten.uniq
	# If we want to do a filter behavior, add CatchAllMatcher
	if config.map{|x| x[:behavior]}.include? :filter
		allMatchers.push(CatchAllMatcher.new)
	end

	# Run those matchers and store the results
	allMatches = {}
	allMatchers.each do |matcher|
		# This line basically says:
		#  run the method who's name is in the matcher, with the argument string
		result = matcher.match(logfile_contents)
		if (! result.is_a?(MatchSet))
			raise "matcher #{matcher.class.name} returned a #{result.class}. It should be a MatchSet"
		end
		allMatches[matcher.class.name] = result
	end

	# Pass the appropriate subset of matches into each responder
	config.each do |mrSet|
		matcherNames = mrSet[:matchers].map{|matcher| matcher.class.name}
		matcherMatches = MatchSet.new(allMatches
			.select{|name,matches| matcherNames.include? name}
			.values
			.map{|matchset| matchset.matches}.flatten)
		if mrSet[:behavior] == :filter
			# If we want to filter, basically do an array subtraction
			# (<everything> - <matches>)
			relevantMatches = allMatches["CatchAllMatcher"] - matcherMatches
		else
			relevantMatches = matcherMatches
		end
		responders = mrSet[:responders]
		responders.each do |responder|
			responder.respond(relevantMatches)
		end
	end

	# This is commented out for development, so that we don't
	#  have to empty the copy logfile every time
	#File.open(copy_file, 'a') { |handle| handle.write(logfile_contents)}
end
