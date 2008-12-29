module GeographerHelper
  def geographer_header(options = {})
    Geographer::Header.new(options).to_s
  end
  
  def map_tag(options = {})
    if options[:query] && defined?(Geokit::Geocoders::MultiGeocoder)
      options[:markers] ||= []
      geo = Geokit::Geocoders::MultiGeocoder.geocode(options[:query])
      if geo.success
        options[:markers] << Geographer::Marker.new(:position => [ geo.lat, geo.lng ], :title => options[:query])
      end
    end
    if options[:mappable]
      options[:markers] ||= []
      options[:markers] << Geographer::Marker.new(
        :position => [ options[:mappable].send(options[:mappable].lat_column_name),
          options[:mappable].send(options[:mappable].lng_column_name) ],
        :title => options[:query])
    end
    Geographer::Map.new(options).to_html
  end
end