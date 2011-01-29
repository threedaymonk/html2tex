lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'html2tex/version'

Gem::Specification.new do |s|
  s.name        = "html2tex"
  s.version     = HTML2TeX::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paul Battley"]
  s.email       = ["pbattley@gmail.com"]
  s.homepage    = "http://github.com/threedaymonk/html2tex"
  s.summary     = "HTML to LaTeX converter"
  s.description = "Converts an HTML document to a LaTeX version with reasonably sensible markup."

  s.add_dependency "htmlentities", ">=4.2.0"
  s.add_dependency "rubypants",    ">=0.2.0"

  s.add_development_dependency "shoulda"

  s.files        = Dir["{bin,lib}/**/*"] + %w[README.md COPYING]
  s.executables  = ['html2tex']
  s.require_path = 'lib'
end
