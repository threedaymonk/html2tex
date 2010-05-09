# encoding: UTF-8
$KCODE = 'u' unless "1.9".respond_to?(:encoding)

lib = File.expand_path("../../lib", __FILE__)
$:.unshift lib unless $:.include?(lib)

require "html2tex"
require "test/unit"
require "shoulda"

class DocumentTest < Test::Unit::TestCase

  should 'insert the document pre- and postamble' do
    expected = <<'END'
\documentclass{book}
\title{TITLE}
\author{AUTHOR}
\begin{document}
\maketitle

foo

\end{document}
END
    input = "foo"
    actual = HTML2TeX.new(input).to_tex
    assert_equal expected, actual
  end

  should 'use the title and author if supplied' do
    actual = HTML2TeX.new("", :author => "foo", :title => "bar").to_tex
    assert_match /\\author\{foo\}/, actual
    assert_match /\\title\{bar\}/, actual
  end

  context 'parsing HTML with META information' do
    setup do
      @html = File.read(File.expand_path("../metadata_sample.html", __FILE__))
    end

    should 'use title from HTML' do
      actual = HTML2TeX.new(@html).to_tex
      assert_match /\\title\{Some Wonderful Novel\}/, actual
    end

    should 'use author from META author' do
      actual = HTML2TeX.new(@html).to_tex
      assert_match /\\author\{John Barleycorn\}/, actual
    end
  end

  context 'parsing HTML with Dublin Core metadata' do
    setup do
      @html = File.read(File.expand_path("../dublin_core_sample.html", __FILE__))
    end

    should 'use title from DC.Title' do
      actual = HTML2TeX.new(@html).to_tex
      assert_match /\\title\{The Real Title\}/, actual
    end

    should 'use author from DC.Creator' do
      actual = HTML2TeX.new(@html).to_tex
      assert_match /\\author\{John Barleycorn\}/, actual
    end
  end
end
