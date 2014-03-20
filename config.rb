require_relative 'matchers'
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
           log = Log.new(file, file + ".old")
           @matchers.each do |matcher|
               log.read(matcher)
           end
       end
    end
end

configs = []

sudo = Configuration.new
sudo.files.push("../sudo.log")
sudo.matchers.push(SudoMatcher)
configs.push(sudo)

hardware = Configuration.new
hardware.files.push("../kern.log")
hardware.matchers.push(CatchAllMatcher)
configs.push(hardware)

CONFIGS = configs
