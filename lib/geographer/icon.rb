module Geographer
  class Icon
    attr_accessor :name, :color, :letter, :width, :height, :shadow_width, :shadow_height, :image_url, :shadow_url,
      :anchor_x, :anchor_y, :info_anchor_x, :info_anchor_y

    def initialize(options = {})
      @name          = options[:name]          || "#{self.class.to_s.underscore.gsub(/\//, '_')}_#{self.object_id.to_s.gsub('-', '_')}"
      @color         = options[:color]         || "red"
      @letter        = options[:letter]        || ""
      @image_url     = options[:image_url]     || "http://www.google.com/mapfiles/marker_#{@color}#{@letter.upcase}.png"
      @shadow_url    = options[:shadow_url]    || "http://www.google.com/mapfiles/shadow50.png"
      @width         = options[:width]         || 20
      @height        = options[:height]        || 34
      @shadow_width  = options[:shadow_width]  || 37
      @shadow_height = options[:shadow_height] || 34
      @anchor_x      = options[:anchor_x]      || 6
      @anchor_y      = options[:anchor_y]      || 20
      @info_anchor_x = options[:anchor_x]      || 5
      @info_anchor_y = options[:anchor_y]      || 1
    end  

    def to_js
      script = []
      script << "var #{@name} = new GIcon();"
      script << "#{@name}.image = \"#{@image_url}\";"
      script << "#{@name}.shadow = \"#{@shadow_url}\";"
      script << "#{@name}.iconSize = new GSize(#{@width}, #{@height});"
      script << "#{@name}.shadowSize = new GSize(#{@shadow_width}, #{@shadow_height});"
      script << "#{@name}.iconAnchor = new GPoint(#{@anchor_x}, #{@anchor_y});"
      script << "#{@name}.infoWindowAnchor = new GPoint(#{@info_anchor_x}, #{@info_anchor_y});\n"
      return script.join("\n    ")
    end

    def to_html
      html = []
      html << "<script type='text/javascript'>"
      html << to_js
      html << "</script>\n"
      return html.join("\n")
    end
  end
end