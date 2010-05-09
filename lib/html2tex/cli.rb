require "optparse"

class HTML2TeX
  class CLI
    CleanExit = Class.new(RuntimeError)
    DirtyExit = Class.new(RuntimeError)

    attr_reader :options, :input_file, :output_file

    def initialize(argv)
      @argv    = argv
      @options = {}
    end

    def usage
      parser.to_s
    end

    def parse
      parser.parse!(@argv)

      unless @input_file = @argv[0]
        raise DirtyExit
      end

      @output_file = @argv[1] || @input_file.sub(/\.[^\.]+$|$/, ".tex")
    end

  private
    def parser
      @parser ||= OptionParser.new{ |opts|
        opts.banner = "Usage: #{File.basename($0)} [options] input.html [output.tex]"

        opts.on "-t", "--title TITLE",
                "Set (or override) the title of the document" do |title|
          options[:title] = title
        end
        opts.on "-a", "--author AUTHOR",
                "Set (or override) the author of the document" do |author|
          options[:author] = author
        end
        opts.on "-c", "--document-class CLASS",
                "Set the LaTeX document class to be used; default is book" do |klass|
          options[:class] = klass
        end

        opts.on "-h", "--help",
                "Display this screen" do
          raise CleanExit
        end
      }
    end
  end
end
