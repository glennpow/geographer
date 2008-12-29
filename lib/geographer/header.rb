module Geographer
  class Header
    attr_accessor :uri, :version
  
    def initialize(options = {})
      @version = options[:version] || 2
      @uri = options[:uri] || ''
    end

    def to_s
      html = "\n<!--[if IE]>\n<style type=\"text/css\">v\\:* { behavior:url(#default#VML); }</style>\n<![endif]-->"

      if defined?(Geographer::KEYS) && Geographer::KEYS.has_key?(@uri)
        html << "<script src='http://maps.google.com/maps?file=api&amp;v=#{@version}&amp;key=#{Geographer::KEYS[@uri]}' type='text/javascript'></script>"
      end
      return html
    end

    def self.header_for(request, version = nil)
      self.new(:version => version, :uri => request.env["HTTP_HOST"]).to_s
    end
  end
end