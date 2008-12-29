module Geographer
  class PolyLine
    attr_accessor :name, :color, :points, :map, :weight, :opacity
  
    def initialize(options = {})
      @name    = options[:name]    || "#{self.class.to_s.underscore.gsub(/\//, '_')}_#{self.object_id.to_s.gsub('-', '_')}"
      @color   = options[:color]   || '#0000ff'
      @weight  = options[:width]   || options[:weight] || 3
      @opacity = options[:opacity] || 0.5
      @points  = options[:points]  || []
      options[:markers].each { |marker| @points.push([marker.position.first, marker.position.last]) } if options[:markers]
      @map     = options[:map]
    end
  
    def width=(width)
      @weight = width
    end
  
    def to_html
      html = []
      html << "<script type='text/javascript'>"
      html << to_js
      html << "</script>\n"
      html.join("\n")
    end
  
    def to_js
      js_point_array_name = "g_polyline_points_for__#{@name}"
      js_GPolyline_opts = "'#{@color}', #{@weight}, #{@opacity}"

      script = []
      script << "var #{js_point_array_name} = [];"
      @points.each { |point|
        script << "#{js_point_array_name}.push(new GLatLng(#{p.first}, #{point.last}));"
      }
      script << "#{@map.name}.addOverlay(new GPolyline(#{js_point_array_name}, #{js_GPolyline_opts}));\n"
      script.join("\n  ")
    end
  end
end