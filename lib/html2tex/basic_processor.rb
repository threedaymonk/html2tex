class HTML2TeX
  class BasicProcessor
    attr_reader :scanner

    def initialize(scanner)
      @decoder = HTMLEntities.new
      @scanner = scanner
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
      tex_escape(@decoder.decode(RubyPants.new(s).to_html))
    end

    def tex_escape(s)
      return nil if s.nil?
      s.gsub(/[\\{}$&#%^_~]/, '\\\\\\0')
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
      when "br"
        "\\\\"
      when /^h\d/
        @squash_next = true
        HeadingProcessor.new(scanner, t).to_tex + "\n\n"
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
