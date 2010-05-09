require "htmlentities"
require "rubypants"
require "html2tex/version"
require "html2tex/basic_processor"

class HTML2TeX
  def initialize(html)
    @html = html
  end

  def to_tex(buffer="")
    BasicProcessor.new(StringScanner.new(@html)).to_tex(buffer)
  end
end
