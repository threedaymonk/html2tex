require "htmlentities"
require "rubypants"

class HTML2TeX
  def initialize(html)
    @html = html
  end

  def to_tex(buffer="")
    BasicProcessor.new(StringScanner.new(@html)).to_tex(buffer)
  end

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

  class HeadingProcessor < BasicProcessor
    HEADINGS = %w[part chapter section subsection subsubsection]

    def initialize(scanner, label)
      @label = label
      super(scanner)
    end

    def to_tex(*args)
      wrap(super(*args))
    end

  private
    def wrap(content)
      return "" if content.strip.empty?
      index = @label[/\d/].to_i - 1
      "\\#{HEADINGS[index]}*{#{content}}"
    end

    def tag(t)
      case t
      when "/#{@label}"
        nil
      else
        ""
      end
    end
  end
end
