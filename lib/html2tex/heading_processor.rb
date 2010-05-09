require "html2tex/basic_processor"

class HTML2TeX
  class HeadingProcessor < BasicProcessor
    HEADINGS = %w[part chapter section subsection subsubsection]

    def initialize(scanner, label)
      @label = label
      super(scanner)
    end

    def to_tex(buffer="")
      buffer << wrap(super(""))
      buffer
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
