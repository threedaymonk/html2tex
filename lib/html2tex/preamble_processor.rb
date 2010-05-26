require "html2tex/basic_processor"
require "nokogiri"

class HTML2TeX
  class PreambleProcessor < BasicProcessor

    def to_tex(buffer="")
      read_html_head
      [ tex(:documentclass, options[:class]),
        tex(:title, title),
        tex(:author, author),
        tex(:begin, "document"),
        tex(:maketitle),
        ""
      ].each do |s|
        buffer << s << "\n"
      end
      buffer
    end

  private
    def read_html_head
      scanner.scan %r{\s*}
      scanner.scan %r{<\?xml[^>]*?\?>\s*}i
      scanner.scan %r{<!doctype[^>]*>\s*}i
      scanner.scan %r{<html[^>]*>\s*}i
      if head = scanner.scan(%r{<head[^>]*>.*?</head>}im)
        h = metadata_hash(head)
        @author = h["dc.creator"] || h["author"]
        @title  = h["dc.title"] || head[%r{<title[^>]*>\s*(.*?)\s*</title>}im, 1]
      end
    end

    def author
      @options[:author] || @author || "AUTHOR"
    end

    def title
      @options[:title] || @title || "TITLE"
    end

    def parse_meta_element(meta)
      data = {}
      s = StringScanner.new(meta)
      s.scan(/<meta\s+/i)
      until s.eos? do
        if s.scan(/\s*\/?>/)
          return data
        else
          key = s.scan(/[^=]+/).downcase
          s.scan(/=\s*/)
        end

        if s.scan(/"/)
          data[key] = s.scan(/[^"]+/)
          s.scan(/"/)
        elsif s.scan(/'/)
          data[key] = s.scan(/[^']+/)
          s.scan(/'/)
        else
          data[key] = s.scan(/\S+/)
        end
        s.scan(/\s+/)
      end
    end

    def metadata_hash(head)
      hash = {}
      head.scan(%r{<meta\s[^>]+>}im).each do |meta|
        m = parse_meta_element(meta)
        if (name = m["name"]) && (content = m["content"])
          hash[name.downcase] = content
        end
      end
      hash
    end
  end
end

