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
