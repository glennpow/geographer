module Geographer
  class Header
    attr_accessor :version
  
    def initialize(options = {})
      @version = options[:version] || 2
    end

    def to_s
      key = nil
      if defined?(Geographer::GOOGLE_KEY)
        key = Geographer::GOOGLE_KEY
      elsif defined?(Geokit::Geocoders::google)
        key = Geokit::Geocoders::google
      end
      if key
        html = "\n<!--[if IE]>\n<style type=\"text/css\">v\\:* { behavior:url(#default#VML); }</style>\n<![endif]-->"
        html << "<script src='http://maps.google.com/maps?file=api&amp;v=#{@version}&amp;key=#{key}' type='text/javascript'></script>"
      elsif ENV['RAILS_ENV'] == 'development'
        logger.error("No Google Key defined!  Set Geographer::GOOGLE_KEY in an initializer.")
        html << "<!-- No Google Key defined!  Set Geographer::GOOGLE_KEY in an initializer. -->"
      end
      return html
    end
  end
end