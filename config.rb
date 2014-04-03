require_relative 'sudomatcher'
require_relative 'catchallmatcher'
# This file defines the global constant CONFIGS.
# CONFIGS is an array of configuration objects.
# files is an array of file paths

class Configuration
    attr_accessor :files, :matchers, :responders, :behavior

    def initialize
        @files = []
        @matchers = []
        @responders = []
        @behavior = []
    end

    def runMatchers
       @files.each do |file|
           log = Log.new(file, file + '.old')
           @matchers.each do |matcher|
               log.run(matcher)
           end
       end
    end
end

configs = []

# SUDO
sudo = Configuration.new
sudo.files.push('../sudo.log')
sudo.matchers.push(SudoMatcher)
configs.push(sudo)

# HARDWARE
hardware = Configuration.new
hardware.files.push('../kern.log')
hardware.matchers.push(CatchAllMatcher)
configs.push(hardware)

# NRPE
nrpe = Configuration.new
nrpe.files.push("../nrpe.log")
nrpe.matchers.push(CatchAllMatcher)
configs.push(nrpe)

CONFIGS = configs
