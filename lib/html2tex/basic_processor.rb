require "html2tex/tex"

class HTML2TeX
  class BasicProcessor
    include TeX

    attr_reader :scanner, :options

    def initialize(scanner, options)
      @decoder = HTMLEntities.new
      @scanner = scanner
      @options = options
    end

    def to_tex(buffer="")
      while n = next_element
        buffer << n
      end
      buffer
    end

  private
    def next_element
      if scanner.eos?
        nil
      elsif s = scanner.scan(/<[^>]+>/)
        tag(s[/<([^>\s]+)/, 1].downcase)
      elsif scanner.scan(/\s+/)
        whitespace
      elsif scanner.scan(/\*(\s*\*){2,5}/)
        dinkus
      elsif s = scanner.scan(/[^\s<]+/)
        text(s)
      else
        ""
      end
    end

    def text(s)
      tex_escape(@decoder.decode(RubyPants.new(@decoder.decode(s)).to_html))
    end

    def whitespace
      if @squash_next
        @squash_next = false
        ""
      else
        " "
      end
    end

    def tag(t)
      @squash_next = false
      case t
      when "/p"
        @squash_next = true
        "\n\n"
      when "em", "i"
        "\\textit{"
      when "strong", "b"
        "\\textbf{"
      when "/em", "/i", "/strong", "/b"
        "}"
      when "sup"
        "$^{\\textrm{"
      when "sub"
        "$_{\\textrm{"
      when "/sup", "/sub"
        "}}$"
      when "br"
        "\\\\"
      when "ol"
        "\\begin{enumerate}\n"
      when "/ol"
        "\\end{enumerate}\n"
      when "ul"
        "\\begin{itemize}\n"
      when "/ul"
        "\\end{itemize}\n"
      when "li"
        "\\item "
      when "/li"
        "\n"
      when /^h\d/
        @squash_next = true
        HeadingProcessor.new(scanner, t, @options).to_tex + "\n\n"
      else
        ""
      end
    end

    def dinkus
      "\\begin{center}\n***\n\\end{center}"
    end
  end
end

require "html2tex/heading_processor"
