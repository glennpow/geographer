module GeographerHelper
  def geographer_header(version = nil)
    Geographer::Header.header_for(request, version)
  end
  
  def map_tag(options = {})
    if options[:query]
      options[:markers] ||= []
      Geographer::Geocoder.geocode(options[:query]).each do |result|
        options[:markers] << Geographer::Marker.new(:position => [ result[:lat], result[:long] ], :title => options[:query])
      end
    end
    Geographer::Map.new(options).to_html
  end
end