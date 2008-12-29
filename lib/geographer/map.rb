module Geographer
  class Map
    attr_accessor :dom_id, :draggable, :include_onload, :type, :controls, :zoom, :width, :height, :center,
      :markers, :polylines, :icons

    def initialize(options = {})
      @dom_id         = options[:dom_id]    || "#{self.class.to_s.underscore.gsub(/\//, '_')}_#{self.object_id.to_s.gsub('-', '_')}"
      @draggable      = options.has_key?(:draggable) ? options[:draggable] : true
      @include_onload = options.has_key?(:include_onload) ? options[:include_onload] : true
      @type           = options[:type]      || :normal
      @controls       = options[:controls]  || [ :large, :scale, :overview ]
      @zoom           = options[:zoom]      || :bound
      @width          = options[:width]     || "100%"
      @height         = options[:height]    || "100%"

      @markers        = options[:markers]   || []
      @polylines      = options[:polylines] || []
      @icons          = options[:icons]     || []

      @center         = options[:center]    || auto_center
    end
  
    def to_html(options = {})
      width = options[:width] || @width || "100%"
      height = options[:height] || @height || "100%"

      @markers.each { |marker| marker.map = self }

      html = []
      html << "<script type=\"text/javascript\">\n/* <![CDATA[ */"  
      html << to_js(options)
      html << "/* ]]> */</script>"
      html << "<div id='#{@dom_id}' style='width: #{width}; height: #{height}'></div>"
      return html.join("\n")
    end
  
    def to_js(options = {})
      include_onload = options.has_key?(:include_onload) ? options[:include_onload] : @include_onload
    
      script = []
      script << "var #{@dom_id};"
      @markers.collect do |marker| 
        script << "var #{marker.name};"
        script << marker.header_js
      end
    
      script << "function initialize_gmap_#{@dom_id}() {"
      script << "if (!GBrowserIsCompatible || !GBrowserIsCompatible()) return false;"
      script << "#{@dom_id} = new GMap2(document.getElementById(\"#{@dom_id}\"));"

      script << "  #{@dom_id}.disableDragging();" if @draggable == false
    
      if @zoom == :bound && !@markers.empty?
        sw_ne = self.bounding_points
        script << "#{@dom_id}.setCenter(new GLatLng(0,0),0);"
        script << "var #{@dom_id}_bounds = new GLatLngBounds(new GLatLng(#{sw_ne[0][0]}, #{sw_ne[0][1]}), new GLatLng(#{sw_ne[1][0]}, #{sw_ne[1][1]}));"
        script << "#{@dom_id}.setCenter(#{@dom_id}_bounds.getCenter());"
        script << "#{@dom_id}.setZoom(#{@dom_id}.getBoundsZoomLevel(#{@dom_id}_bounds) - 1);"
      else
        zoom = :bound ? 1 : @zoom.to_i
        script << "#{@dom_id}.setCenter(new GLatLng(#{@center[0]}, #{@center[1]}), #{zoom});"
      end

      script << "  #{@dom_id}.setMapType(G_#{@type.to_s.upcase}_MAP);"

      @controls.each do |control|
        script << "  #{@dom_id}.addControl(new " + case control
          when :large, :small, :overview
            "G#{control.to_s.capitalize}MapControl"
          when :scale
            "GScaleControl"
          when :type
            "GMapTypeControl"
          when :zoom
            "GSmallZoomControl"
        end + "());"
      end

      @markers.each { |marker| script << marker.to_js }
      @icons.each { |icon| script << icon.to_js }
      @polylines.each { |polyline| script << polyline.to_js }
    
      script << "}"

      if include_onload
        script << "if (typeof window.onload != 'function')"
        script << "  window.onload = initialize_gmap_#{@dom_id};"
        script << "else {"
        script << "  old_before_geographer_#{@dom_id} = window.onload;"
        script << "  window.onload = function() { "
        script << "    old_before_geographer_#{@dom_id}(); "
        script << "    initialize_gmap_#{@dom_id}(); "
        script << "  }"
        script << "}"      
      else
        script << "initialize_gmap_#{@dom_id}();"
      end
      return script.join("\n")
    end
  
    def to_s
      self.to_html
    end
  
    def auto_center
      return [ 45, 0 ] if @markers.empty?
      return @markers.first.position if @markers.length == 1
      maxlat, minlat, maxlon, minlon = Float::MIN, Float::MAX, Float::MIN, Float::MAX
      @markers.each do |marker| 
        if marker.lat > maxlat then maxlat = marker.lat end
        if marker.lat < minlat then minlat = marker.lat end
        if marker.lon > maxlon then maxlon = marker.lon end 
        if marker.lon < minlon then minlon = marker.lon end
      end
      return [ ((maxlat + minlat) / 2), ((maxlon + minlon) / 2) ]
    end
  
    def bounding_points
      maxlat, minlat, maxlon, minlon = nil, nil, nil, nil
  
      @markers.each do |marker| 
        if ! maxlat || marker.lat > maxlat then maxlat = marker.lat end
        if ! minlat || marker.lat < minlat then minlat = marker.lat end
        if ! maxlon || marker.lon > maxlon then maxlon = marker.lon end 
        if ! minlon || marker.lon < minlon then minlon = marker.lon end
      end
  
      @polylines.each do |line|
        line.points.each do |point|
          if ! maxlat || point[0] > maxlat then maxlat = point[0] end
          if ! minlat || point[0] < minlat then minlat = point[0] end
          if ! maxlon || point[1] > maxlon then maxlon = point[1] end 
          if ! minlon || point[1] < minlon then minlon = point[1] end
        end
      end

      return [ [ minlat, minlon ], [ maxlat, maxlon ] ]
    end
  end
end