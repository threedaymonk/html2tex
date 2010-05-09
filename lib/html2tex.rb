require "htmlentities"
require "rubypants"
require "html2tex/version"
require "html2tex/basic_processor"
require "html2tex/preamble_processor"
require "html2tex/tex"

class HTML2TeX
  include TeX

  DEFAULT_OPTIONS = {
    :document => true,
    :class    => "book"
  }

  def initialize(html, options={})
    @html    = html
    @options = DEFAULT_OPTIONS.merge(options)
  end

  def to_tex(buffer="")
    scanner = StringScanner.new(@html)

    if @options[:document]
      PreambleProcessor.new(scanner, @options).to_tex(buffer)
    end

    BasicProcessor.new(scanner, @options).to_tex(buffer)

    if @options[:document]
      buffer << "\n\n" << tex(:end, "document")
    end

    buffer << "\n"
    buffer
  end
end
