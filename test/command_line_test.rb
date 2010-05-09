# encoding: UTF-8
$KCODE = "u" unless "1.9".respond_to?(:encoding)

lib = File.expand_path("../../lib", __FILE__)
$:.unshift lib unless $:.include?(lib)

require "html2tex/cli"
require "test/unit"
require "shoulda"

class CommandLineTest < Test::Unit::TestCase

  def invoke_with(*args)
    cli = HTML2TeX::CLI.new(args)
    cli.parse
    cli
  end

  should "raise CleanExit when -h passed" do
    assert_raises HTML2TeX::CLI::CleanExit do
      invoke_with "-h"
    end
  end

  should "raise CleanExit when --help passed" do
    assert_raises HTML2TeX::CLI::CleanExit do
      invoke_with "--help"
    end
  end

  should "raise DirtyExit when no file names are given" do
    assert_raises HTML2TeX::CLI::DirtyExit do
      invoke_with # nothing
    end
  end

  should "return usage information" do
    cli = HTML2TeX::CLI.new([])
    assert_match /Usage/, cli.usage
  end

  context "when making output file from input file name" do
    should "turn .html into .tex" do
      cli = invoke_with("foo/bar/baz.html")
      assert_equal "foo/bar/baz.tex", cli.output_file
    end

    should "turn .HTM into .tex" do
      cli = invoke_with("foo/bar/baz.HTM")
      assert_equal "foo/bar/baz.tex", cli.output_file
    end

    should "turn append .tex when there is no extension" do
      cli = invoke_with("foo/bar/baz")
      assert_equal "foo/bar/baz.tex", cli.output_file
    end
  end

  should "use supplied output file" do
    cli = invoke_with("foo", "bar")
    assert_equal "bar", cli.output_file
  end

  context "when parsing options" do
    should "have author if specified" do
      cli = invoke_with("--author", "Humpty Dumpty", "foo")
      assert_equal "Humpty Dumpty", cli.options[:author]
    end

    should "not have author if not specified" do
      cli = invoke_with("foo")
      assert !cli.options.has_key?(:author)
    end

    should "have title" do
      cli = invoke_with("--title", "A Novel", "foo")
      assert_equal "A Novel", cli.options[:title]
    end

    should "have document class" do
      cli = invoke_with("--document-class", "ebook", "foo")
      assert_equal "ebook", cli.options[:class]
    end

    should "remove options from list" do
      cli = invoke_with("--document-class", "ebook", "--author", "Humpty Dumpty", "foo", "bar")
      assert_equal "foo", cli.input_file
      assert_equal "bar", cli.output_file
    end
  end
end
