require_relative 'matchers'
# This file defines the global constant CONFIGS.
# CONFIGS is an array of configurations.

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
           newLogs = Logs.read(file)
           @matchers.each do |matcher|
               puts matcher.match(newLogs)
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
sudo.files.push("../kern.log")
sudo.matchers.push(CatchAllMatcher)
configs.push(hardware)

CONFIGS = configs
