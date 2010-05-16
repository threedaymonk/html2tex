# encoding: UTF-8
$KCODE = 'u' unless "1.9".respond_to?(:encoding)

lib = File.expand_path("../../lib", __FILE__)
$:.unshift lib unless $:.include?(lib)

require "html2tex"
require "test/unit"
require "shoulda"

class FormattingTest < Test::Unit::TestCase

  def assert_converted(expected, input)
    actual = HTML2TeX.new(input, :document => false).to_tex.strip
    assert_equal expected.strip, actual
  end

  should 'collapse space within paragraphs' do
    input    = "<p>test text\n\nin a paragraph</p>"
    expected = "test text in a paragraph"
    assert_converted expected, input
  end

  should 'convert paragraphs to double line breaks' do
    input    = "<p>para 1</p><p>para 2</p>"
    expected = "para 1\n\npara 2"
    assert_converted expected, input
  end

  should 'convert <br> to \\' do
    assert_converted "foo bar \\\\ baz", "foo bar\n<br>\nbaz"
  end

  should 'centre * * * or ***' do
    assert_converted "\\begin{center}\n***\n\\end{center}", "* * *"
    assert_converted "\\begin{center}\n***\n\\end{center}", "***"
  end

  context 'when processing text' do
    should 'convert <i> to \textit' do
      assert_converted "\\textit{foo}", "<i>foo</i>"
    end

    should 'convert <em> to \textit' do
      assert_converted "\\textit{foo}", "<em>foo</em>"
    end

    should 'convert <b> to \textbf' do
      assert_converted "\\textbf{foo}", "<b>foo</b>"
    end

    should 'convert <strong> to \textbf' do
      assert_converted "\\textbf{foo}", "<strong>foo</strong>"
    end

    should 'convert HTML entities' do
      assert_converted "é", "&eacute;"
    end

    should 'escape TeX markup' do
      assert_converted "\\&\\$", "&$"
    end

    should 'put in nice quotes' do
      assert_converted "“hello”",       '"hello"'
      assert_converted "‘hello’",       "'hello'"
      assert_converted "it’s",          "it's"
      assert_converted "O’Shaughnessy", "O'Shaughnessy"
    end

    should 'unescape quotes before converting to nice quotes' do
      assert_converted "“hello”",       '&quot;hello&quot;'
      assert_converted "‘hello’",       "&apos;hello&apos;"
      assert_converted "it’s",          "it&apos;s"
      assert_converted "O’Shaughnessy", "O&apos;Shaughnessy"
    end

    should 'convert superscripts' do
      assert_converted "on the 21$^{\\textrm{st}}$ floor", "on the 21<sup>st</sup> floor"
    end

    should 'convert subscripts' do
      assert_converted "atmospheric CO$_{\\textrm{2}}$ levels", "atmospheric CO<sub>2</sub> levels"
    end

    should 'convert numbered lists' do
      assert_converted "\\begin{enumerate}\n\\item Foo\n\\item Bar\n\\end{enumerate}",
                       "<ol><li>Foo</li><li>Bar</li></ol>"
    end

    should 'convert bulletted lists' do
      assert_converted "\\begin{itemize}\n\\item Foo\n\\item Bar\n\\end{itemize}",
                       "<ul><li>Foo</li><li>Bar</li></ul>"
    end
  end

  context 'when processing headings' do
    should 'convert <h1> to \part' do
      assert_converted "\\part*{foo}", "<h1>foo</h1>"
    end

    should 'convert <h2> to \chapter' do
      assert_converted "\\chapter*{foo}", "<h2>foo</h2>"
    end

    should 'convert <h3> to \section' do
      assert_converted "\\section*{foo}", "<h3>foo</h3>"
    end

    should 'convert <h4> to \subsection' do
      assert_converted "\\subsection*{foo}", "<h4>foo</h4>"
    end

    should 'ignore case' do
      assert_converted "\\chapter*{foo}\n\nblah blah", "<h2>foo</H2>\nblah blah"
    end

    should 'ignore markup' do
      assert_converted "\\chapter*{foo bar}", "<h2>foo <i>bar</i></h2>"
    end

    should 'skip empty elements' do
      assert_converted "", "<h2><br></h2>"
    end
  end
end
