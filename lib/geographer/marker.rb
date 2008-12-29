module Geographer
  class Marker
    attr_accessor :name, :position, :icon, :title, :click, :info_window, :map

    def initialize(options = {})
      @name        = options[:name]        || "#{self.class.to_s.underscore.gsub(/\//, '_')}_#{self.object_id.to_s.gsub('-', '_')}"
      @position    = options[:position]    || [0, 0]
      @icon        = options[:icon]
      @title       = options[:title]
      @click       = options[:click]
      @info_window = options[:info_window]
      @map         = options[:map]
    end

    def lat
      @position.first
    end

    def lon
      @position.last
    end

    def header_js
      script = []
      if @info_window
        if @info_window.kind_of?(Array)
          script << "  var #{@name}_infoTabs = ["
          script << @info_window.inject([]) { |tabs, tab|
            tabs << "   new GInfoWindowTab(\"#{tab[:title]}\",\"#{tab[:html]}\")"
          }.join(",\n")
          script << "  ]\n"
          script << "function #{@name}_info_window_function() {"
          script << "  #{@name}.openInfoWindowTabsHtml(#{@name}_infoTabs);"
          script << "}\n"
        else        
          script << "function #{@name}_info_window_function() {"
          script << "  #{@name}.openInfoWindowHtml(\"#{@info_window}\")"
          script << "}\n"
        end
      end
      return script.join("\n  ")
    end

    def to_js
      script = []
      script << @icon.to_js if @icon
      script << "markerOptions = {"
      script << "  icon: #{@icon.name}," if @icon
      script << "  title: '#{@title}'," if @title
      script << "};"
      script << "#{@name} = new GMarker(new GLatLng(#{@position[0]}, #{@position[1]}), markerOptions);\n"
      if @click
        script << "GEvent.addListener(#{name}, \"click\", function() {#{@click}});\n"
      elsif @info_window
        script << "GEvent.addListener(#{name}, \"click\", function() {#{name}_info_window_function()});\n"
      end
      script << "#{@map.dom_id}.addOverlay(#{@name});\n"
      return script.join("\n  ")
    end

    def info_window_link(link_text = 'Show on map', options = {})
      "<a href='##{options[:anchor]}' onClick='#{@name}_info_window_function(); return false;'>#{link_text}</a>"
    end
  
    def zoom_link(link_text = 'Zoom on map')
      "<a href='#' onClick='#{@map.dom_id}.setCenter(new GLatLng(#{@position.first}, #{@position.last}), 8); return false;'>#{link_text}</a>"
    end
  end
end