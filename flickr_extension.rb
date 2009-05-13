require 'open-uri'
require 'activesupport'

class FlickrExtension < Radiant::Extension
  version "0.1"
  description "Pulls thumbnails from flickr for display"
  url "http://jon.bandedartists.com/flickr"

  def activate
    Page.send :include, FlickrTags
  end
  
  def deactivate
  end
  
end
