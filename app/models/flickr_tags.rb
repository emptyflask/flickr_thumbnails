module FlickrTags
  
  include Radiant::Taggable
  
  ATTRIBUTES = %w{api_key user_id tags tag_mode text min_upload_date max_upload_date min_taken_date max_taken_date license sort privacy_filter bbox accuracy safe_search content_type machine_tags machine_tag_mode group_id contacts woe_id place_id media has_geo geo_context lat lon radius radius_units is_commons extras per_page page}
  
  def build_query(tag, options)
    url = 'http://api.flickr.com/services/rest?&format=json&nojsoncallback=1'
    
    ATTRIBUTES.each do |a|
      url += "&#{a}=#{CGI::escape(tag.attr[a].to_s)}" if tag.attr[a]
    end
    
    options.each do |key, value|
      url += "&#{key}=#{CGI::escape(value)}"
    end
    
    return url
  end
  
  
  def get_data(url)
    json = Net::HTTP.get(URI.parse(url))
    result = ActiveSupport::JSON.decode(json)
    return result
  end
  
  
  def add_photos(photos)
    output = ''
    photoset_id = photos['photoset']['id']
    photos = photos['photoset']['photo']

    unless photos.empty?
      output += '<ul class="gallery">'

      photos[0..photos.size-1].each do |photo|
        thumb = "http://farm#{photo['farm']}.static.flickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}_s.jpg"
        output += %{<li><a href="http://farm#{photo['farm']}.static.flickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}.jpg?v=0" class="thickbox" rel="#{photoset_id}"><img src="#{thumb}" alt="#{photo['title']}" /></a></li>}
      end

      output += '</ul>'
    end
    return output
  end
  
  
  tag 'flickr' do |tag|
    output = ''

    begin
      # flickr_search = build_query(tag, {'method' => "flickr.photos.search"})
      photosets = get_data( build_query(tag, {'method' => "flickr.photosets.getList"}) )
      photosets = photosets['photosets']['photoset']
      
      photosets.each do |photoset|
        photos = get_data( build_query(tag, {'method' => "flickr.photosets.getPhotos", 'photoset_id' => photoset['id']}) )
        output += '<div class="photoset">'
        output += "<h3>#{photoset['title']['_content'].to_s}</h3>"
        output += add_photos(photos)
        output += '</div>'
      end
            
    rescue
      $stderror.puts "Something broke!"
    end
    
    output
  end

end
