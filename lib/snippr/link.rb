# = Snippr::Link
#
# Extends the Snippr module adding support for link helpers like wiki links.
module Snippr
  module Link

    # Regex for links in wiki syntax (eg. [[http://www.google.de|google]]).
    WikiLink = /\[\[([^|]+)\|([^\]]+)\]\]/
    
    # Pattern for general link tags.
    HtmlLink = '<a href="\1">\2</a>'
    
    # Convert all links to html links (eg. wiki links to html links).
    def linkify(content)
      convert_wiki_links content
    end
    
private
    
    # Convert wiki links to html links 
    def convert_wiki_links(content)
      content.gsub WikiLink, HtmlLink
    end

  end
end
