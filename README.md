HTML2TeX
========

This is a simple library and command-line tool to convert HTML documents into
LaTeX. The intended use is for preparing ebooks, but it might also be useful
for other purposes.

Library use
-----------

    require "html2tex"
    
    # Return output as a string
    tex = HTML2TeX.new(html).to_tex
    
    # Write directly to a stream
    File.open("output.tex", "w") do |f|
      HTML2TeX.new(html).to_tex(f)
    end

Command-line use
----------------

    html2tex source.html destination.tex

Dependencies
------------

* htmlentities, to decode character entities
* rubypants, to convert `'` and `"` into something more appealing

Limitations
-----------

The HTML recognised is currently limited to headings, paragraphs, and bold and
italic mark-up. This covers the majority of novels, but it's far from
comprehensive.

StringScanner is used to process the HTML, but cannot read from a stream
directly, so the entire input document must be read into memory as a string
first.
