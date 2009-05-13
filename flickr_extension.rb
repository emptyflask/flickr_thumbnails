require 'open-uri'
require 'activesupport'

class FlickrExtension < Radiant::Extension
  version "0.1"
  description "Builds a gallery page from Flickr photosets. For use with Thickbox."
  url "http://jon.bandedartists.com/flickr"

  def activate
    Page.send :include, FlickrTags
  end
  
  def deactivate
  end
  
end
