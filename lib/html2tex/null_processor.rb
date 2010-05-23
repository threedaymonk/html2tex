class HTML2TeX
  class NullProcessor
    attr_reader :scanner, :options

    def initialize(scanner, end_on, options)
      @scanner = scanner
      @end_on  = end_on
      @options = options
    end

    def to_tex(buffer="")
      scanner.scan(%r{.*?#{Regexp.escape(@end_on)}}im)
      ""
    end
  end
end
